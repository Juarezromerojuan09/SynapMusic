import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/music_player_background_task.dart';
import '../../screens/add_to_playlist_screen.dart';

class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final extras = snapshot.data?.extras;
        final itemJson = extras != null ? extras["itemJson"] : null;
        
        if (snapshot.hasData && itemJson != null) {
          return IconButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(
                AddToPlaylistScreen.routeName,
                arguments: BaseItemDto.fromJson(itemJson).id),
            icon: const Icon(Icons.playlist_add),
            tooltip: AppLocalizations.of(context)!.addToPlaylistTooltip,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: null,
            tooltip: AppLocalizations.of(context)!.addToPlaylistTooltip,
          );
        }
      },
    );
  }
}
