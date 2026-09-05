import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../services/process_artist.dart';
import '../album_image.dart';

class DownloadErrorListTile extends StatelessWidget {
  const DownloadErrorListTile({Key? key, required this.downloadTask})
      : super(key: key);

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final DownloadedSong? downloadedSong =
        downloadsHelper.getJellyfinItemFromDownloadId(downloadTask.taskId);

    if (downloadedSong == null) {
      final downloadedImage =
          downloadsHelper.getDownloadedImageFromDownloadId(downloadTask.taskId);
      return ListTile(
        leading: const Icon(Icons.image, color: Color(0xFF8B93FF), size: 36),
        title: Text(
          downloadedImage != null
              ? "Portada / Imagen adjunta"
              : "Descarga: ${downloadTask.filename ?? downloadTask.taskId}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "Falló al descargar imagen o archivo multimedia",
          style: TextStyle(color: Color(0xFFA0A0A0)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF8B93FF)),
          tooltip: "Reintentar descarga",
          onPressed: () async {
            try {
              await FlutterDownloader.retry(taskId: downloadTask.taskId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reintentando descarga...'), duration: Duration(seconds: 1)),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al reintentar: $e')),
              );
            }
          },
        ),
      );
    }

    return ListTile(
      leading: AlbumImage(item: downloadedSong.song),
      title: Text(
        downloadedSong.song.name == null
            ? AppLocalizations.of(context)!.unknownName
            : downloadedSong.song.name!,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        processArtist(downloadedSong.song.albumArtist, context),
        style: const TextStyle(color: Color(0xFFA0A0A0)),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh, color: Color(0xFF8B93FF)),
        tooltip: "Reintentar descarga",
        onPressed: () async {
          try {
            await FlutterDownloader.retry(taskId: downloadTask.taskId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reintentando descarga...'), duration: Duration(seconds: 1)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al reintentar: $e')),
            );
          }
        },
      ),
    );
  }
}
