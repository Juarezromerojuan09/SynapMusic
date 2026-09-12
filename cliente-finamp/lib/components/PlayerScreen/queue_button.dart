import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'queue_list.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.queue_music),
        tooltip: AppLocalizations.of(context)!.queue,
        onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          context: context,
          builder: (context) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1.0,
              minChildSize: 0.5,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return QueueList(
                  scrollController: scrollController,
                );
              },
            );
          },
        );
      },
    );
  }
}
