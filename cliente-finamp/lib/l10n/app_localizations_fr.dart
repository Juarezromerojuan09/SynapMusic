// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String startupError(String error) {
    return 'Une erreur est survenue lors du démarrage de l\'application. L\'erreur est: $error\n\nPlease create an issue on github.com/UnicornsOnLSD/finamp with a screenshot of this page. If this problem persists you can clear your app data to reset the app.';
  }

  @override
  String get serverUrl => 'Adresse du serveur';

  @override
  String get internalExternalIpExplanation =>
      'Si vous souhaitez pouvoir accéder à votre serveur Jellyfin à distance, vous devez utiliser votre adresse IP externe.\n\nSi votre serveur utilise un port HTTP (80/443), vous n\'avez pas besoin de spécifier de port. C\'est probablement le cas si votre serveur est derrière un reverse proxy.';

  @override
  String get emptyServerUrl => 'Vous devez indiquez l\'adresse du serveur.';

  @override
  String get urlStartWithHttps =>
      'L\'adresse doit commencer par http:// ou https://';

  @override
  String get urlTrailingSlash =>
      'L\'adresse ne doit pas inclure de slash final.';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get logs => 'Logs';

  @override
  String get next => 'Prochain';

  @override
  String get selectMusicLibraries => 'Selectionner des bibliothèques';

  @override
  String get couldNotFindLibraries => 'Aucune bibliothèque trouvée';

  @override
  String get unknownName => 'Nom inconnu';

  @override
  String get songs => 'Titres';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artistes';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Playlists';

  @override
  String get startMix => 'Commencer un Mix';

  @override
  String get startMixNoSongsArtist =>
      'Appuyer longuement sur un artiste pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get startMixNoSongsAlbum =>
      'Appuyer longuement sur un album pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get music => 'Musique';

  @override
  String get clear => 'Effacer';

  @override
  String get favourites => 'Favoris';

  @override
  String get shuffleAll => 'Tout mélanger';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get settings => 'Réglages';

  @override
  String get offlineMode => 'Mode hors-ligne';

  @override
  String get sortOrder => 'Ordre de tri';

  @override
  String get sortBy => 'Trier par';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artiste de l\'album';

  @override
  String get artist => 'Artiste';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Note de la communauté';

  @override
  String get criticRating => 'Note de la critique';

  @override
  String get dateAdded => 'Date d\'ajout';

  @override
  String get datePlayed => 'Date de lecture';

  @override
  String get playCount => 'nombre de lectures';

  @override
  String get premiereDate => 'Date de première';

  @override
  String get productionYear => 'Date de production';

  @override
  String get name => 'Nom';

  @override
  String get random => 'Aléatoire';

  @override
  String get revenue => 'Recettes';

  @override
  String get runtime => 'Durée d\'exécution';

  @override
  String get syncDownloadedPlaylists =>
      'Synchroniser les playlists téléchargées';

  @override
  String get downloadMissingImages => 'Télécharger les images manquantes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images téléchargées',
      one: '$count image téléchargée',
      zero: 'Pas d\'image manquante',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Télécharger les erreurs';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléchargements',
      one: '$count téléchargement',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: '$count image',
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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count complétés',
      one: '$count complété',
    );
    return '$_temp0';
  }

  @override
  String dlFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count échecs',
      one: '$count échec',
    );
    return '$_temp0';
  }

  @override
  String dlEnqueued(int count) {
    return '$count en attente';
  }

  @override
  String dlRunning(int count) {
    return '$count en cours';
  }

  @override
  String get downloadErrorsTitle => 'Erreurs de téléchargement';

  @override
  String get noErrors => 'Pas d\'erreur!';

  @override
  String get errorScreenError =>
      'Une erreur est survenue lors de la récupération de la liste des erreurs ! À ce stade, il serait probablement préférable de créer une issue sur GitHub et de supprimer les données de l\'application.';

  @override
  String get failedToGetSongFromDownloadId =>
      'Échec de récupération de la chanson à partir de l\'ID de téléchargement';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'l\'album',
        'playlist': 'la playlist',
        'artist': 'l\'artiste',
        'genre': 'le genre',
        'track': 'le titre',
        'other': '',
      },
    );
    return 'Êtes vour sûr de vouloir supprimer $_temp0 \'$itemName\' de cet appareil ?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Supprimer';

  @override
  String get deleteDownloadsAbortButtonText => 'Annuler';

  @override
  String get error => 'Erreur';

  @override
  String discNumber(int number) {
    return 'Disque $number';
  }

  @override
  String get playButtonLabel => 'LIRE';

  @override
  String get shuffleButtonLabel => 'ALÉATOIRE';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '$count titre',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Modifier le titre de la playlist';

  @override
  String get editPlaylistNameTitle => 'Edit Playlist Name';

  @override
  String get required => 'Requis';

  @override
  String get updateButtonLabel => 'METTRE À JOUR';

  @override
  String get playlistNameUpdated => 'Titre de la playlist mis à jour.';

  @override
  String get favourite => 'Favoris';

  @override
  String get downloadsDeleted => 'Téléchargements supprimés.';

  @override
  String get addDownloads => 'Ajouter les téléchargements';

  @override
  String get location => 'Emplacement';

  @override
  String get downloadsAdded => 'Téléchargements ajoutés.';

  @override
  String get addButtonLabel => 'AJOUTER';

  @override
  String get shareLogs => 'Partager les journaux.';

  @override
  String get logsCopied => 'Journaux copiés.';

  @override
  String get message => 'Message';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String get applicationLegalese =>
      'Soumis à la licence Mozilla Public License 2.0. Le code source est disponible sur :\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcodage';

  @override
  String get downloadLocations => 'Emplacements des téléchargements';

  @override
  String get audioService => 'Service audio';

  @override
  String get interactions => 'Intéractions';

  @override
  String get layoutAndTheme => 'Disposition & Apparence';

  @override
  String get notAvailableInOfflineMode => 'Indisponible en mode hors-ligne';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Les chansons téléchargées ne seront pas supprimées';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin utilise AAC lors du transcodage';

  @override
  String get enableTranscoding => 'Activer le transcodage';

  @override
  String get enableTranscodingSubtitle =>
      'Transcode les flux musicaux côté serveur.';

  @override
  String get bitrate => 'Débit binaire';

  @override
  String get bitrateSubtitle =>
      'Un débit binaire plus élevé offre une meilleure qualité audio au prix d\'une bande passante plus importante.';

  @override
  String get customLocation => 'Emplacement personnalisé';

  @override
  String get appDirectory => 'Répertoire de l\'application';

  @override
  String get addDownloadLocation => 'Ajouter un emplacement de téléchargement';

  @override
  String get selectDirectory => 'Sélectionner un répertoire';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get pathReturnSlashErrorMessage =>
      'Les chemins qui retournent \"/\" ne peuvent pas être utilisés';

  @override
  String get directoryMustBeEmpty => 'Le répertoire doit être vide';

  @override
  String get customLocationsBuggy =>
      'Les emplacements personnalisés sont très bogués en raison de problèmes de permissions. Je réfléchis à des solutions pour corriger cela, mais pour l\'instant, je ne recommande pas de les utiliser.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Faible priorité de l\'application lorsque la lecture est en pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permet de supprimer la notification lorsque la lecture est en pause. Permet également à Android de fermer le service lorsqu\'il est en pause.';

  @override
  String get shuffleAllSongCount => 'Nombre de chansons à mélanger';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Nombre de chansons à charger lors de l\'utilisation du bouton \'Tout mélanger\'.';

  @override
  String get viewType => 'Disposition de l\'affichage';

  @override
  String get viewTypeSubtitle =>
      'Règle la manière dont les musiques sont diposées';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Grille';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Paysage';

  @override
  String gridCrossAxisCount(String value) {
    return 'Nombre de tuiles par ligne en orientation $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Le nombre de tuiles à utiliser par rangée en orientation $value lorsque l\'affichage est en mode mosaïque.';
  }

  @override
  String get showTextOnGridView => 'Afficher le texte dans la grille de vue';

  @override
  String get showTextOnGridViewSubtitle =>
      'Afficher ou non le texte (titre, artiste, etc.) sur l\'écran de la grille musicale.';

  @override
  String get showCoverAsPlayerBackground =>
      'Afficher la couverture floutée en arrière-plan du lecteur';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Choisir d\'utiliser ou non l\'illustration floutée comme arrière-plan sur l\'écran du lecteur.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Masquer les artistes des chansons si identiques aux artistes de l\'album';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Afficher ou non les artistes des chansons sur l\'écran de l\'album si différents des artistes de l\'album.';

  @override
  String get disableGesture => 'Désactiver les gestes';

  @override
  String get disableGestureSubtitle =>
      'Indique si les gestes doivent être désactivés.';

  @override
  String get showFastScroller => 'Afficher le défileur rapide';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Claire';

  @override
  String get dark => 'Sombre';

  @override
  String get tabs => 'Onglets';

  @override
  String get cancelSleepTimer => 'Annuler le minuteur de sommeil ?';

  @override
  String get yesButtonLabel => 'OUI';

  @override
  String get noButtonLabel => 'NON';

  @override
  String get setSleepTimer => 'Configurer le minuteur de sommeil';

  @override
  String get minutes => 'Minutes';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get sleepTimerTooltip => 'Minuteur de sommeil';

  @override
  String get addToPlaylistTooltip => 'Ajouter à une playlist';

  @override
  String get addToPlaylistTitle => 'Ajouter à une playlist';

  @override
  String get removeFromPlaylistTooltip => 'Retirer de la playlist';

  @override
  String get removeFromPlaylistTitle => 'Retirer de la playlist';

  @override
  String get newPlaylist => 'Nouvelle Playlist';

  @override
  String get createButtonLabel => 'CRÉER';

  @override
  String get playlistCreated => 'Playlist créée.';

  @override
  String get noAlbum => 'Aucun album';

  @override
  String get noItem => 'Aucun élément';

  @override
  String get noArtist => 'Aucun artiste';

  @override
  String get unknownArtist => 'Artiste inconnu';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'TÉLÉCHARGÉ';

  @override
  String get transcode => 'TRANSCODAGE';

  @override
  String get direct => 'DIRECT';

  @override
  String get statusError => 'STATUS D\'ERREUR';

  @override
  String get queue => 'File d\'attente';

  @override
  String get addToQueue => 'Ajouter à la file d\'attente';

  @override
  String get playNext => 'Lire ensuite';

  @override
  String get replaceQueue => 'Remplacer la file d\'attente';

  @override
  String get instantMix => 'Mix instantané';

  @override
  String get goToAlbum => 'Voir l\'album';

  @override
  String get removeFavourite => 'Retirer des favoris';

  @override
  String get addFavourite => 'Ajouter aux favoris';

  @override
  String get addedToQueue => 'Ajouté à la fin de la file d\'attente.';

  @override
  String get insertedIntoQueue => 'Ajouté à la file d\'attente.';

  @override
  String get queueReplaced => 'File d\'attente remplacée.';

  @override
  String get removedFromPlaylist => 'Retiré de la playlist.';

  @override
  String get startingInstantMix => 'Mix instantané lancé.';

  @override
  String get anErrorHasOccured => 'Une erreur s\'est produite.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Code de statut $statusCode. Cela signifie probablement que vous avez utilisé un mauvais nom d\'utilisateur/mot de passe, ou que votre client n\'est plus connecté.';
  }

  @override
  String get removeFromMix => 'Retirer du Mix';

  @override
  String get addToMix => 'Ajouter au Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments re-téléchargés',
      one: '$count élément re-téléchargé',
      zero: 'Aucun re-téléchargement nécessaire',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Taille du tampon';

  @override
  String get bufferDurationSubtitle =>
      'Taille du tampon du lecteur, en secondes. Changer ce paramètre nécessite un redémarrage.';

  @override
  String get language => 'Langue';

  @override
  String get confirm => 'Confirmé';

  @override
  String get showUncensoredLogMessage =>
      'Ce journal contient vos informations de connexion. Afficher tout de même ?';

  @override
  String get resetTabs => 'Réinitialiser les onglets';

  @override
  String get noMusicLibrariesTitle => 'Aucune bibliothèque musicale';

  @override
  String get noMusicLibrariesBody =>
      'Finamp n\'a pas trouvé de bibliothèques musicales. Veuillez vous assurer que votre serveur Jellyfin contient au moins une bibliothèque avec le type de contenu défini sur \"Musique\".';

  @override
  String get refresh => 'RAFRAÎCHIR';

  @override
  String get swipeInsertQueueNext => 'Lire la chanson balayée en prochain';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Activer l\'insertion d\'une chanson comme élément suivant dans la file d\'attente lorsqu\'elle est balayée dans la liste des chansons, au lieu de l\'ajouter à la fin.';

  @override
  String get redesignBeta => 'Essayer la bêta';

  @override
  String get playbackOrderShuffledTooltip =>
      'Lecture en aléatoire. Touchez pour activer/désactiver.';

  @override
  String get playbackOrderLinearTooltip =>
      'Lecture dans l\'ordre. Touchez pour activer/désactiver.';

  @override
  String get loopModeAllTooltip =>
      'Lecture en boucle de l\'ensemble. Touchez pour activer/désactiver.';

  @override
  String get loopModeOneTooltip =>
      'Lecture en boucle d\'un seul. Touchez pour activer/désactiver.';

  @override
  String get loopModeNoneTooltip =>
      'Ne pas lire en boucle. Touchez pour activer/désactiver.';

  @override
  String get skipToPrevious => 'Passer à la chanson précédente';

  @override
  String get skipToNext => 'Passer à la chanson suivante';

  @override
  String get togglePlayback => 'Activer/désactiver la lecture';

  @override
  String playArtist(String artist) {
    return 'Lire tous les albums de $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Lire aléatoirement tous les albums de $artist';
  }

  @override
  String downloadArtist(String artist) {
    return 'Télécharger tous les albums de $artist';
  }

  @override
  String get deleteFromDevice => 'Supprimer de l\'appareil';

  @override
  String get download => 'Télécharger';

  @override
  String get sync => 'Synchroniser avec le serveur';

  @override
  String get about => 'À propos de Finamp';
}
