import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/album_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../artists_text_spans.dart';

/// Creates some text that shows the song's name, album and the artist.
class SongName extends StatelessWidget {
  const SongName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final JellyfinApiHelper jellyfinApiHelper =
        GetIt.instance<JellyfinApiHelper>();

    const textColour = Color(0xFFA0A0A0);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final MediaItem mediaItem = snapshot.data!;
          BaseItemDto songBaseItemDto =
              BaseItemDto.fromJson(mediaItem.extras!["itemJson"]);

          List<TextSpan> separatedArtistTextSpans = [];

          if (songBaseItemDto.artistItems?.isEmpty ?? true) {
            separatedArtistTextSpans = [
              TextSpan(
                text: AppLocalizations.of(context)!.unknownArtist,
                style: TextStyle(color: textColour),
              )
            ];
          } else {
            songBaseItemDto.artistItems
                ?.map((e) => TextSpan(
                    text: e.name,
                    style: TextStyle(color: textColour),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Offline artists aren't implemented yet so we return if
                        // offline
                        if (FinampSettingsHelper.finampSettings.isOffline) {
                          return;
                        }

                        jellyfinApiHelper.getItemById(e.id).then((artist) =>
                            Navigator.of(context).popAndPushNamed(
                                ArtistScreen.routeName,
                                arguments: artist));
                      }))
                .forEach((artistTextSpan) {
              separatedArtistTextSpans.add(artistTextSpan);
              separatedArtistTextSpans.add(TextSpan(
                text: ", ",
                style: TextStyle(color: textColour),
              ));
            });
            separatedArtistTextSpans.removeLast();
          }

          return SongNameContent(
              songBaseItemDto: songBaseItemDto,
              mediaItem: mediaItem,
              separatedArtistTextSpans: ArtistsTextSpans(
                songBaseItemDto,
                textColour,
                context,
                true,
              ));
        }

        return const SongNameContent(
          songBaseItemDto: null,
          mediaItem: null,
          separatedArtistTextSpans: [],
        );
      },
    );
  }
}

class SongNameContent extends StatelessWidget {
  const SongNameContent({
    Key? key,
    required this.songBaseItemDto,
    required this.mediaItem,
    required this.separatedArtistTextSpans,
  }) : super(key: key);
  final BaseItemDto? songBaseItemDto;
  final MediaItem? mediaItem;
  final List<TextSpan> separatedArtistTextSpans;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mediaItem == null
              ? AppLocalizations.of(context)!.noItem
              : mediaItem!.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: mediaItem == null || mediaItem!.artist == null
                ? [
                    TextSpan(
                      text: AppLocalizations.of(context)!.noArtist,
                      style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
                    )
                  ]
                : separatedArtistTextSpans,
            style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
          ),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
      ],
    );
  }
}
