// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String startupError(String error) {
    return '¡Algo ha salido mal en el arranque de la aplicación! El error es: $error\n\nPor favor crea una incidencia en github.com/UnicornsOnLSD/finamp con una captura de pantalla de esta página. Si el problema persiste, borra los datos de la aplicación para resetearla.';
  }

  @override
  String get serverUrl => 'URL del servidor';

  @override
  String get internalExternalIpExplanation =>
      'Si quieres acceder a tu servidor Jellyfin remotamente, tendrás que usar tu dirección IP externa.\n\nSi tu servidor está en un puerto HTTP (80/443), no tendrás que especificar el puerto. Este probablemente sea tu caso si tu servidor está detrás de un proxy inverso.';

  @override
  String get emptyServerUrl => 'La URL del servidor no puede estar vacia';

  @override
  String get urlStartWithHttps => 'La URL debe empezar por http:// o https://';

  @override
  String get urlTrailingSlash => 'La URL no debe incluir una barra al final';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get logs => 'Registros';

  @override
  String get next => 'Siguiente';

  @override
  String get selectMusicLibraries => 'Seleccionar las bibliotecas de música';

  @override
  String get couldNotFindLibraries =>
      'No se pudo encontrar ninguna biblioteca.';

  @override
  String get unknownName => 'Nombre desconocido';

  @override
  String get songs => 'Canciones';

  @override
  String get albums => 'Álbumes';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Géneros';

  @override
  String get playlists => 'Listas';

  @override
  String get startMix => 'Empezar mezcla';

  @override
  String get startMixNoSongsArtist =>
      'Mantén pulsado un artista para añadirlo o eliminarlo del creador de mezclas antes de empezar una mezcla';

  @override
  String get startMixNoSongsAlbum =>
      'Mantén pulsado un álbum para añadirlo o eliminarlo del creador de mezclas antes de empezar una mezcla';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpiar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Reproducir aleatoriamente todas las canciones';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Descargas';

  @override
  String get settings => 'Ajustes';

  @override
  String get offlineMode => 'Modo sin conexión';

  @override
  String get sortOrder => 'Ordenar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista del álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Presupuesto';

  @override
  String get communityRating => 'Valoración de la comunidad';

  @override
  String get criticRating => 'Valoración de los críticos';

  @override
  String get dateAdded => 'Fecha de añadido';

  @override
  String get datePlayed => 'Fecha de reproducción';

  @override
  String get playCount => 'Reproducciones';

  @override
  String get premiereDate => 'Fecha de lanzamiento';

  @override
  String get productionYear => 'Año de producción';

  @override
  String get name => 'Nombre';

  @override
  String get random => 'Aleatorio';

  @override
  String get revenue => 'Ingresos';

  @override
  String get runtime => 'Duración';

  @override
  String get syncDownloadedPlaylists =>
      'Sincroniza las listas de reproducción descargadas';

  @override
  String get downloadMissingImages => 'Descargar las imágenes que faltan';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargadas $count que faltaban',
      one: 'Descargada $count imagen que faltaba',
      zero: 'No se han encontrado imágenes que faltan',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Errores en la descarga';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargas',
      one: '$count descarga',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '$count elemento',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imágenes',
      one: '$count imagen',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsImagesCount(
      String downloadedItems, String downloadedImages) {
    return '$downloadedItems, $downloadedImages';
  }

  @override
  String dlComplete(int count) {
    return '$count completadas';
  }

  @override
  String dlFailed(int count) {
    return '$count han fallado';
  }

  @override
  String dlEnqueued(int count) {
    return '$count en cola';
  }

  @override
  String dlRunning(int count) {
    return '$count en progreso';
  }

  @override
  String get downloadErrorsTitle => 'Error al descargar';

  @override
  String get noErrors => '¡Sin errores!';

  @override
  String get errorScreenError =>
      '¡Se ha producido un error al obtener la lista de errores! Llegados a este punto, probablemente deberías crear una incidencia en GitHub y eliminar los datos de la aplicación';

  @override
  String get failedToGetSongFromDownloadId =>
      'No se ha podido obtener la canción desde el identificador de descarga';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'género',
        'track': 'song',
        'other': '',
      },
    );
    return '¿Estás seguro de que quieres eliminar la $_temp0 \'$itemName\' de este dispositivo?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Borrar';

  @override
  String get deleteDownloadsAbortButtonText => 'Cancelar';

  @override
  String get error => 'Error';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'REPRODUCIR';

  @override
  String get shuffleButtonLabel => 'ALEATORIO';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Canciones',
      one: '$count Canción',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip =>
      'Editar el nombre de la lista de reproducción';

  @override
  String get editPlaylistNameTitle =>
      'Modificar el nombre de la lista de reproducción';

  @override
  String get required => 'Requerido';

  @override
  String get updateButtonLabel => 'ACTUALIZAR';

  @override
  String get playlistNameUpdated => 'Se actualizó el nombre de la lista.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Se borraron las descargas.';

  @override
  String get addDownloads => 'Añadir descargas';

  @override
  String get location => 'Ubicación';

  @override
  String get downloadsAdded => 'Se añadieron las descargas.';

  @override
  String get addButtonLabel => 'AÑADIR';

  @override
  String get shareLogs => 'Compartir registros';

  @override
  String get logsCopied => 'Se copiaron los registros.';

  @override
  String get message => 'Mensaje';

  @override
  String get stackTrace => 'Trazado de pila';

  @override
  String get applicationLegalese =>
      'Licenciado con la Mozilla Public License 2.0. El código fuente disponible en:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcodificar';

  @override
  String get downloadLocations => 'Ubicaciones de descarga';

  @override
  String get audioService => 'Servicio de audio';

  @override
  String get interactions => 'Interacciones';

  @override
  String get layoutAndTheme => 'Diseño y tema';

  @override
  String get notAvailableInOfflineMode =>
      'No está disponible en el modo sin conexión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Las canciones descargadas no serán eliminadas';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin usa AAC para transcodificar';

  @override
  String get enableTranscoding => 'Habilitar transcodificación';

  @override
  String get enableTranscodingSubtitle =>
      'Transcodifica los streams de música en el servidor.';

  @override
  String get bitrate => 'Tasa de bits';

  @override
  String get bitrateSubtitle =>
      'Una tasa de bits más alta da una mayor calidad de audio a costa de un mayor ancho de banda.';

  @override
  String get customLocation => 'Ubicación personalizada';

  @override
  String get appDirectory => 'Directorio de la aplicación';

  @override
  String get addDownloadLocation => 'Añadir ubicación de descarga';

  @override
  String get selectDirectory => 'Seleccionar directorio';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get pathReturnSlashErrorMessage =>
      'No se pueden utilizar ubicaciones que contengan \"/\"';

  @override
  String get directoryMustBeEmpty => 'El directorio debe estar vacío';

  @override
  String get customLocationsBuggy =>
      'Las ubicaciones personalizadas son extremadamente problemáticas por problemas con los permisos. Estoy pensando en maneras de arreglarlo, pero por ahora no recomiendo usarlas.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Entrar en estado de baja prioridad al pausar';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permite que la notificación se pueda deslizar cuando la música esté pausada. También permite a Android matar el servicio cuando la música esté pausada.';

  @override
  String get shuffleAllSongCount =>
      'Cantidad de canciones al reproducir aleatoriamente';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Cantidad de canciones a cargar cuando se use el botón de reproducir todo aleatoriamente.';

  @override
  String get viewType => 'Tipo de vista';

  @override
  String get viewTypeSubtitle => 'Tipo de vista para la pantalla de música';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Cuadrícula';

  @override
  String get portrait => 'Vertical';

  @override
  String get landscape => 'Horizontal';

  @override
  String gridCrossAxisCount(String value) {
    return 'Columnas en vista de cuadrícula en $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Cantidad de columnas al usar por fila al estar el dispositivo en $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto en vista de cuadrícula';

  @override
  String get showTextOnGridViewSubtitle =>
      'Muestra el texto (título, artista, etc) en la pantalla de música al usar la vista de cuadrícula.';

  @override
  String get showCoverAsPlayerBackground =>
      'Mostrar la carátula con desenfoque como fondo del reproductor';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Usa la carátula del álbum desenfocada como fondo del reproductor.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Ocultar los artistas de canciones si son los mismos que los artistas del álbum';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Oculta a los artistas de las canciones en la pantalla del álbum si no son diferentes de los artistas del álbum.';

  @override
  String get disableGesture => 'Deshabilitar los gestos';

  @override
  String get disableGestureSubtitle => 'Si desea desactivar los gestos.';

  @override
  String get showFastScroller => 'Mostrar desplazamiento rápido';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get tabs => 'Pestañas';

  @override
  String get cancelSleepTimer => '¿Cancelar el temporizador de sueño?';

  @override
  String get yesButtonLabel => 'SÍ';

  @override
  String get noButtonLabel => 'NO';

  @override
  String get setSleepTimer => 'Ajustar temporizador de sueño';

  @override
  String get minutes => 'Minutos';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get sleepTimerTooltip => 'Temporizador de sueño';

  @override
  String get addToPlaylistTooltip => 'Añadir a lista de reproducción';

  @override
  String get addToPlaylistTitle => 'Agregar a lista de reproducción';

  @override
  String get removeFromPlaylistTooltip =>
      'Eliminar de la lista de reproducción';

  @override
  String get removeFromPlaylistTitle => 'Borrar de la lista de reproducción';

  @override
  String get newPlaylist => 'Nueva lista';

  @override
  String get createButtonLabel => 'CREAR';

  @override
  String get playlistCreated => 'Se creó la lista.';

  @override
  String get noAlbum => 'Sin álbum';

  @override
  String get noItem => 'Ningún elemento';

  @override
  String get noArtist => 'Sin artista';

  @override
  String get unknownArtist => 'Artista desconocido';

  @override
  String get streaming => 'TRANSMITIENDO';

  @override
  String get downloaded => 'DESCARGADO';

  @override
  String get transcode => 'TRANSCODIFICADO';

  @override
  String get direct => 'DIRECTO';

  @override
  String get statusError => 'ERROR DE ESTADO';

  @override
  String get queue => 'Cola';

  @override
  String get addToQueue => 'Añadir a la cola';

  @override
  String get playNext => 'Reproducir la siguiente';

  @override
  String get replaceQueue => 'Reemplazar la cola';

  @override
  String get instantMix => 'Mezcla instantánea';

  @override
  String get goToAlbum => 'Ir al álbum';

  @override
  String get removeFavourite => 'Eliminar favorito';

  @override
  String get addFavourite => 'Añadir favorito';

  @override
  String get addedToQueue => 'Añadido a la cola.';

  @override
  String get insertedIntoQueue => 'Insertado en la cola.';

  @override
  String get queueReplaced => 'Se reemplazó la cola.';

  @override
  String get removedFromPlaylist => 'Eliminado de la lista de reproducción.';

  @override
  String get startingInstantMix => 'Empezando mezcla instantánea.';

  @override
  String get anErrorHasOccured => 'Ha ocurrido un error.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de estado $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de estado $statusCode. Esto posiblemente significa que has usado el nombre de usuario o la contraseña incorrecta, o que tu cliente ya no está autenticado.';
  }

  @override
  String get removeFromMix => 'Eliminar de la mezcla';

  @override
  String get addToMix => 'Añadir a la mezcla';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redescargados $count elementos',
      one: 'Redescargado $count elemento',
      zero: 'No hace falta volver a descargar nada.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duración del búfer';

  @override
  String get bufferDurationSubtitle =>
      'Cuánto debe almacenar en el búfer el reproductor, en segundos. Requiere un reinicio.';

  @override
  String get language => 'Idioma';

  @override
  String get confirm => 'Confirmar';

  @override
  String get showUncensoredLogMessage =>
      'Este registro contiene tu información de acceso. ¿Mostrar?';

  @override
  String get resetTabs => 'Restablecer las pestañas';

  @override
  String get noMusicLibrariesTitle => 'Sin bibliotecas de música';

  @override
  String get noMusicLibrariesBody =>
      'Finamp no ha podido encontrar ninguna biblioteca de música. Asegúrate de que tu servidor Jellyfin contiene al menos una biblioteca con el tipo de \"Música\".';

  @override
  String get refresh => 'REFRESCAR';

  @override
  String get swipeInsertQueueNext =>
      'Reproducir la siguiente canción al deslizarla';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Permite insertar una canción como siguiente elemento en la cola cuando se desliza en la lista de reproducción en lugar de añadirla al final.';

  @override
  String get redesignBeta => 'Prueba la versión Beta';

  @override
  String get playbackOrderShuffledTooltip => 'Mezclando. Toca para alternar.';

  @override
  String get playbackOrderLinearTooltip =>
      'Reproducción en orden. Toca para alternar.';

  @override
  String get loopModeAllTooltip => 'Repitiendo todo. Toca para alternar.';

  @override
  String get loopModeOneTooltip => 'En bucle. Toca para alternar.';

  @override
  String get loopModeNoneTooltip =>
      'No se reproduce en bucle. Toca para alternar.';

  @override
  String get skipToPrevious => 'Saltar a la canción anterior';

  @override
  String get skipToNext => 'Saltar a la siguiente canción';

  @override
  String get togglePlayback => 'Alternar reproducción';

  @override
  String playArtist(String artist) {
    return 'Reproducir todos los álbumes de $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Reproducir aleatoriamente todos los álbumes de $artist';
  }

  @override
  String downloadArtist(String artist) {
    return 'Descargar todos los álbumes de $artist';
  }

  @override
  String get deleteFromDevice => 'Eliminar del dispositivo';

  @override
  String get download => 'Descargar';

  @override
  String get sync => 'Sincronizar con el servidor';

  @override
  String get about => 'Acerca de Finamp';
}
