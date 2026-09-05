import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/synap_api_service.dart';
import 'package:finamp/services/synap_events.dart';
import 'package:get_it/get_it.dart';

class LikesPlaylistHelper {
  static const String likesPlaylistName = 'My likes';

  /// Retorna verdadero si la playlist proporcionada es la playlist fija "My likes"
  static bool isLikesPlaylist(BaseItemDto? playlist) {
    if (playlist == null || playlist.name == null) return false;
    return playlist.name!.trim().toLowerCase() == likesPlaylistName.toLowerCase();
  }

  /// Obtiene la playlist "My likes" para el usuario actual o la crea en Jellyfin si no existe.
  static Future<BaseItemDto?> getOrCreateLikesPlaylist() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUserId;
      final apiService = SynapApiService();
      final jellyfin = GetIt.instance<JellyfinApiHelper>();

      // 1. Buscar en las playlists del usuario
      final playlistsData = await apiService.getUserPlaylists(userId: userId);
      for (final raw in playlistsData) {
        final dto = BaseItemDto.fromJson(raw);
        if (isLikesPlaylist(dto)) {
          return dto;
        }
      }

      // 2. Si no existe, crear la playlist "My likes"
      final newId = await apiService.createPlaylist(likesPlaylistName, userId: userId);
      if (newId != null) {
        SynapEvents.fireLibraryRefresh();
        try {
          final item = await jellyfin.getItemById(newId);
          return item;
        } catch (_) {
          return BaseItemDto(id: newId, name: likesPlaylistName);
        }
      }
    } catch (e) {
      print('Error en getOrCreateLikesPlaylist: $e');
    }
    return null;
  }

  /// Agrega una pista por su ID a la playlist "My likes" si aún no está presente.
  static Future<void> addSongToLikes(String songId) async {
    try {
      final likesPl = await getOrCreateLikesPlaylist();
      if (likesPl?.id == null) return;

      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final items = await jellyfin.getItems(parentItem: likesPl, isGenres: false) ?? [];
      final alreadyIn = items.any((i) => i.id == songId);

      if (!alreadyIn) {
        await jellyfin.addItemstoPlaylist(
          playlistId: likesPl!.id,
          ids: [songId],
        );
        SynapEvents.fireLibraryRefresh();
      }
    } catch (e) {
      print('Error al agregar canción a My likes: $e');
    }
  }

  /// Remueve una pista por su ID de la playlist "My likes".
  static Future<void> removeSongFromLikes(String songId) async {
    try {
      final likesPl = await getOrCreateLikesPlaylist();
      if (likesPl?.id == null) return;

      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final items = await jellyfin.getItems(parentItem: likesPl, isGenres: false) ?? [];
      
      final match = items.where((i) => i.id == songId).firstOrNull;

      if (match?.playlistItemId != null) {
        await jellyfin.removeItemsFromPlaylist(
          playlistId: likesPl!.id,
          entryIds: [match!.playlistItemId!],
        );
        SynapEvents.fireLibraryRefresh();
      }
    } catch (e) {
      print('Error al remover canción de My likes: $e');
    }
  }
}
