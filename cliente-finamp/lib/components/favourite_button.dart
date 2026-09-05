import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/services/likes_playlist_helper.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {Key? key,
      required this.item,
      this.onlyIfFav = false,
      this.inPlayer = false})
      : super(key: key);

  final BaseItemDto? item;
  final bool onlyIfFav;
  final bool inPlayer;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    if (widget.item == null || widget.item!.userData == null) {
      return const SizedBox.shrink();
    }

    bool isFav = widget.item!.userData!.isFavorite;
    if (widget.onlyIfFav) {
      if (isFav) {
        return Icon(
          Icons.favorite,
          color: Colors.red,
          size: 24.0,
          semanticLabel: AppLocalizations.of(context)!.favourite,
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          color: isFav ? Colors.redAccent : Colors.white,
          size: 26.0,
        ),
        tooltip: AppLocalizations.of(context)!.favourite,
        onPressed: () async {
          try {
            UserItemDataDto? newUserData;
            if (isFav) {
              newUserData =
                  await jellyfinApiHelper.removeFavourite(widget.item!.id);
              await LikesPlaylistHelper.removeSongFromLikes(widget.item!.id);
            } else {
              newUserData =
                  await jellyfinApiHelper.addFavourite(widget.item!.id);
              await LikesPlaylistHelper.addSongToLikes(widget.item!.id);
            }
            if (mounted) {
              setState(() {
                widget.item!.userData = newUserData;
                if (widget.inPlayer) {
                  final extras = audioHandler.mediaItem.valueOrNull?.extras;
                  if (extras != null) {
                    extras['itemJson'] = widget.item!.toJson();
                  }
                }
              });
            }
          } catch (e) {
            errorSnackbar(e, context);
          }
        },
      );
    }
  }
}
