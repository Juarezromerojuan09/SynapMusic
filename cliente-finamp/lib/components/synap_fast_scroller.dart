import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String extractAlphabetLetter(String? input) {
  if (input == null || input.trim().isEmpty) return '#';
  final trimmed = input.trim();
  const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
  const withoutAccents = 'aeiouunAEIOUUN';
  String firstChar = trimmed[0];
  final accIdx = withAccents.indexOf(firstChar);
  if (accIdx != -1) {
    firstChar = withoutAccents[accIdx];
  }
  firstChar = firstChar.toUpperCase();
  final code = firstChar.codeUnitAt(0);
  if (code >= 65 && code <= 90) {
    return firstChar;
  }
  return '#';
}

class SynapFastScroller extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final int itemCount;
  final String Function(int index)? letterExtractor;
  final double? topPadding;
  final double? bottomPadding;

  const SynapFastScroller({
    Key? key,
    required this.child,
    required this.controller,
    required this.itemCount,
    this.letterExtractor,
    this.topPadding,
    this.bottomPadding,
  }) : super(key: key);

  @override
  State<SynapFastScroller> createState() => _SynapFastScrollerState();
}

class _SynapFastScrollerState extends State<SynapFastScroller> {
  double _scrollRatio = 0.0;
  bool _isDragging = false;
  String? _currentLetter;

  static const double _thumbHeight = 44.0;
  static const double _hitboxWidth = 36.0;
  static const double _bubbleSize = 38.0;

  DateTime? _lastJumpTime;
  Timer? _jumpTimer;
  double _pendingJumpOffset = 0.0;
  int _lastHapticTime = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(SynapFastScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _jumpTimer?.cancel();
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!_isDragging && widget.controller.hasClients) {
      final max = widget.controller.position.maxScrollExtent;
      if (max > 0) {
        final ratio = (widget.controller.offset / max).clamp(0.0, 1.0);
        if ((ratio - _scrollRatio).abs() > 0.005) {
          setState(() {
            _scrollRatio = ratio;
          });
        }
      }
    }
  }

  void _scheduleThrottledJump(double targetOffset) {
    _pendingJumpOffset = targetOffset;
    final now = DateTime.now();

    // Throttling: máximo 1 salto por cada 32ms (~30fps de recálculo de lista)
    // para evitar sobrecargar el hilo de UI de Flutter y no causar ANR
    if (_lastJumpTime == null || now.difference(_lastJumpTime!).inMilliseconds >= 32) {
      _lastJumpTime = now;
      if (widget.controller.hasClients) {
        widget.controller.jumpTo(_pendingJumpOffset);
      }
    } else {
      _jumpTimer?.cancel();
      final remaining = 32 - now.difference(_lastJumpTime!).inMilliseconds;
      _jumpTimer = Timer(Duration(milliseconds: remaining), () {
        if (!mounted) return;
        _lastJumpTime = DateTime.now();
        if (widget.controller.hasClients) {
          widget.controller.jumpTo(_pendingJumpOffset);
        }
      });
    }
  }

  void _triggerHaptic() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastHapticTime > 75) {
      _lastHapticTime = now;
      HapticFeedback.selectionClick();
    }
  }

  void _handleDrag(double localY, double usableHeight, double maxExtent) {
    if (usableHeight <= 0) return;
    final newRatio = ((localY - _thumbHeight / 2) / usableHeight).clamp(0.0, 1.0);

    String? newLetter = _currentLetter;
    if (widget.letterExtractor != null && widget.itemCount > 0) {
      final idx = (newRatio * (widget.itemCount - 1)).round().clamp(0, widget.itemCount - 1);
      final letter = widget.letterExtractor!(idx);
      if (letter != _currentLetter) {
        newLetter = letter;
        _triggerHaptic();
      }
    }

    setState(() {
      _isDragging = true;
      _scrollRatio = newRatio;
      _currentLetter = newLetter;
    });

    if (maxExtent > 0) {
      _scheduleThrottledJump(newRatio * maxExtent);
    }
  }

  void _endDrag() {
    _jumpTimer?.cancel();
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _currentLetter = null;
      });

      // Al soltar el dedo, fijamos de inmediato la posición exacta final
      if (widget.controller.hasClients) {
        final max = widget.controller.position.maxScrollExtent;
        widget.controller.jumpTo(_scrollRatio * max);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final effectiveTopPadding = widget.topPadding ?? (mediaQuery.padding.top + kToolbarHeight + 8);
    final effectiveBottomPadding = widget.bottomPadding ?? (mediaQuery.padding.bottom + 80);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final trackHeight = (totalHeight - effectiveTopPadding - effectiveBottomPadding);
        final usableHeight = (trackHeight - _thumbHeight).clamp(1.0, double.infinity);
        final maxExtent = widget.controller.hasClients
            ? widget.controller.position.maxScrollExtent
            : 0.0;
        final bool canScroll = maxExtent > 80 && widget.itemCount > 3;

        final thumbTop = (_scrollRatio * usableHeight).clamp(0.0, usableHeight);
        final thumbScreenY = effectiveTopPadding + thumbTop;

        // La letra aparece justo arriba del orbe (pegada arriba de la barra)
        final minBubbleTop = mediaQuery.padding.top + 8.0;
        final maxBubbleTop = totalHeight - effectiveBottomPadding - _bubbleSize;
        final bubbleTop = (thumbScreenY - _bubbleSize - 6.0).clamp(minBubbleTop, maxBubbleTop);

        final bool showBubble = _isDragging && _currentLetter != null && _currentLetter!.isNotEmpty;

        return Stack(
          children: [
            widget.child,

            if (canScroll) ...[
              // 1. Hitbox táctil y Orbe/Thumb
              Positioned(
                top: effectiveTopPadding,
                bottom: effectiveBottomPadding,
                right: 0,
                width: _hitboxWidth,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    if (details.localPosition.dy >= (thumbTop - 20) &&
                        details.localPosition.dy <= (thumbTop + _thumbHeight + 20)) {
                      _handleDrag(details.localPosition.dy, usableHeight, maxExtent);
                    }
                  },
                  onTapUp: (_) => _endDrag(),
                  onVerticalDragStart: (details) => _handleDrag(details.localPosition.dy, usableHeight, maxExtent),
                  onVerticalDragUpdate: (details) => _handleDrag(details.localPosition.dy, usableHeight, maxExtent),
                  onVerticalDragEnd: (_) => _endDrag(),
                  onVerticalDragCancel: _endDrag,
                  child: Stack(
                    children: [
                      Positioned(
                        top: thumbTop,
                        right: 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: _isDragging ? 6.5 : 4.5,
                          height: _thumbHeight,
                          decoration: BoxDecoration(
                            color: _isDragging
                                ? const Color(0xFF8B93FF)
                                : Colors.white.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(4.0),
                            boxShadow: _isDragging
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF8B93FF).withOpacity(0.7),
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Burbuja con letra pegada justo arriba del orbe
              if (widget.letterExtractor != null)
                Positioned(
                  top: bubbleTop,
                  right: 2,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: showBubble ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 120),
                      child: Container(
                        width: _bubbleSize,
                        height: _bubbleSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C).withOpacity(0.95),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8B93FF),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B93FF).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _currentLetter ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
