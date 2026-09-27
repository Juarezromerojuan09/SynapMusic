import 'dart:async';
import 'package:flutter/material.dart';

class SynapMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final Duration pauseDuration;
  final VoidCallback? onTap;

  const SynapMarqueeText({
    Key? key,
    required this.text,
    this.style,
    this.velocity = 35.0,
    this.pauseDuration = const Duration(seconds: 2),
    this.onTap,
  }) : super(key: key);

  @override
  _SynapMarqueeTextState createState() => _SynapMarqueeTextState();
}

class _SynapMarqueeTextState extends State<SynapMarqueeText> with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  Timer? _timer;
  bool _isAnimating = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startCycle();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SynapMarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _stopAnimation();
      if (_controller.hasClients) {
        _controller.jumpTo(0.0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startCycle();
        }
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _stopAnimation();
    _controller.dispose();
    super.dispose();
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
    _isAnimating = false;
  }

  void _onAnimationStatusChanged() {
    if (_disposed || !mounted) return;
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _startCycle() {
    if (_disposed || !mounted || !_controller.hasClients) return;

    final maxScroll = _controller.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _timer?.cancel();
    _timer = Timer(widget.pauseDuration, () {
      if (_disposed || !mounted) return;
      _runAnimation();
    });
  }

  void _runAnimation() async {
    if (_disposed || !mounted || !_controller.hasClients) return;

    final maxScroll = _controller.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _isAnimating = true;
    final durationMs = ((maxScroll / widget.velocity) * 1000).toInt();

    try {
      await _controller.animateTo(
        maxScroll,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.linear,
      );

      if (_disposed || !mounted) return;

      _timer?.cancel();
      _timer = Timer(widget.pauseDuration, () async {
        if (_disposed || !mounted || !_controller.hasClients) return;
        await _controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
        if (_disposed || !mounted) return;
        _startCycle();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          widget.text,
          style: widget.style,
          maxLines: 1,
        ),
      ),
    );
  }
}
