// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String startupError(String error) {
    return 'Er ging iets mis bij het starten van de app. Dit was de foutmelding: $error\n\nCreëer een issue op github.com/UnicornsOnLSD/finamp met een schermafbeelding van deze pagina. Wanneer het probleem zich vaker voordoet, kan je de app-data verwijderen om de app te resetten.';
  }

  @override
  String get serverUrl => 'Server URL';

  @override
  String get internalExternalIpExplanation =>
      'Om toegang tot de Jellyfin server te krijgen op afstand, dien je een extern IP te gebruiken.\n\nWanneer de server een HTTP-poort (80 of 443) gebruikt, hoef je deze niet in te vullen. Dit is waarschijnlijk het geval wanneer de server zich achter een reverse proxy bevindt.';

  @override
  String get emptyServerUrl => 'De URL van je server mag niet leeg zijn';

  @override
  String get urlStartWithHttps =>
      'De URL moet beginnen met http:// of https://';

  @override
  String get urlTrailingSlash => 'De URL mag geen / bevatten aan het einde';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get logs => 'Logbestanden';

  @override
  String get next => 'Volgende';

  @override
  String get selectMusicLibraries => 'Selecteer Muziekbibliotheken';

  @override
  String get couldNotFindLibraries => 'Kon geen bibliotheken vinden.';

  @override
  String get unknownName => 'Onbekende Naam';

  @override
  String get songs => 'Liedjes';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artiesten';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Afspeellijsten';

  @override
  String get startMix => 'Mix starten';

  @override
  String get startMixNoSongsArtist =>
      'Druk lang op een artiest om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get startMixNoSongsAlbum =>
      'Druk lang op een album om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get music => 'Muziek';

  @override
  String get clear => 'Opschonen';

  @override
  String get favourites => 'Favorieten';

  @override
  String get shuffleAll => 'Alles shufflen';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Instellingen';

  @override
  String get offlineMode => 'Offline Modus';

  @override
  String get sortOrder => 'Sorteervolgorde';

  @override
  String get sortBy => 'Sorteer met';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album Artiest';

  @override
  String get artist => 'Artiest';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Gemeenschapsbeoordeling';

  @override
  String get criticRating => 'Criticusbeoordeling';

  @override
  String get dateAdded => 'Datum toegevoegd';

  @override
  String get datePlayed => 'Datum afgespeeld';

  @override
  String get playCount => 'Aantal keren afgespeeld';

  @override
  String get premiereDate => 'Premieredatum';

  @override
  String get productionYear => 'Productiejaar';

  @override
  String get name => 'Naam';

  @override
  String get random => 'Willekeurig';

  @override
  String get revenue => 'Inkomsten';

  @override
  String get runtime => 'Duur';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Download ontbrekende plaatjes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ontbrekende plaatjes gedownloaded',
      one: '$count ontbrekend plaatje gedownloaded',
      zero: 'Geen ontbrekende plaatjes gevonden',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Download fouten';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads',
      one: '$count download',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plaatjes',
      one: '$count plaatje',
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
    return '$count volledig';
  }

  @override
  String dlFailed(int count) {
    return '$count mislukt';
  }

  @override
  String dlEnqueued(int count) {
    return '$count gepland';
  }

  @override
  String dlRunning(int count) {
    return '$count bezig';
  }

  @override
  String get downloadErrorsTitle => 'Download Fouten';

  @override
  String get noErrors => 'Geen fouten!';

  @override
  String get errorScreenError =>
      'Er is een fout opgetreden bij het opvragen van de lijst. Probeer een issue te maken op GitHub en verwijder app data';

  @override
  String get failedToGetSongFromDownloadId =>
      'Het nummer kon niet gevonden worden met deze download ID';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'track': 'song',
        'other': '',
      },
    );
    return 'Are you sure you want to delete the $_temp0 \'$itemName\' from this device?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Delete';

  @override
  String get deleteDownloadsAbortButtonText => 'Cancel';

  @override
  String get error => 'Fout';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'AFSPELEN';

  @override
  String get shuffleButtonLabel => 'SHUFFLE';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nummers',
      one: '$count Nummer',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Pas de naam van de playlist aan';

  @override
  String get editPlaylistNameTitle => 'Pas de naam van de Playlist aan';

  @override
  String get required => 'Verplicht';

  @override
  String get updateButtonLabel => 'UPDATE';

  @override
  String get playlistNameUpdated => 'De naam van de playlist is aangepast.';

  @override
  String get favourite => 'Favoriet';

  @override
  String get downloadsDeleted => 'Downloads verwijderd.';

  @override
  String get addDownloads => 'Voeg downloads toe';

  @override
  String get location => 'Plaats';

  @override
  String get downloadsAdded => 'Downloads toegevoegd.';

  @override
  String get addButtonLabel => 'Toevoegen';

  @override
  String get shareLogs => 'Deel de log';

  @override
  String get logsCopied => 'De log is gekopieerd.';

  @override
  String get message => 'Bericht';

  @override
  String get stackTrace => 'Strack-trace';

  @override
  String get applicationLegalese =>
      'Uitgegeven onder de Mozilla Public License 2.0. Broncode beschikbaar op:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Converteren';

  @override
  String get downloadLocations => 'Downloadlocaties';

  @override
  String get audioService => 'Audiodienst';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Layout & Thema';

  @override
  String get notAvailableInOfflineMode => 'Niet beschikbaar in offline-modus';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Gedownloade nummers worden niet verwijderd';

  @override
  String get areYouSure => 'Bent u zeker?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin gebruikt AAC voor conversie';

  @override
  String get enableTranscoding => 'Conversie inschakelen';

  @override
  String get enableTranscodingSubtitle =>
      'Converteert muziekstreams op de server.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Het gebruik van een hogere bitrate geeft betere audiokwaliteit, maar gebruikt meer netwerkbandbreedte.';

  @override
  String get customLocation => 'Persoonlijke locatie';

  @override
  String get appDirectory => 'Applicatie folder';

  @override
  String get addDownloadLocation => 'Voeg een downloadlocatie toe';

  @override
  String get selectDirectory => 'Selecteer map';

  @override
  String get unknownError => 'Onbekende Fout';

  @override
  String get pathReturnSlashErrorMessage =>
      'Paden met \"/\" kunnen niet worden gebruikt';

  @override
  String get directoryMustBeEmpty => 'Folder moet leeg zijn';

  @override
  String get customLocationsBuggy =>
      'Persoonlijke locaties hebben veel bug door permissies. We denken over oplossingen hiervoor. Voor nu raden we aan deze niet te gebruiken.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Ga naar een lage prioriteit wanneer gepauseerd';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'De notificatie kan weggeswiped worden wanneer gepauseerd. Hierdoor kan Android de service stoppen.';

  @override
  String get shuffleAllSongCount => 'Aantal liedjes in de shuffle';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Hoeveelheid liedjes geladen moeten worden bij gebruik van de shuffle knop.';

  @override
  String get viewType => 'Type bekijken';

  @override
  String get viewTypeSubtitle => 'Type voor het muziekscherm bekijken';

  @override
  String get list => 'Lijst';

  @override
  String get grid => 'Raster';

  @override
  String get portrait => 'Portret';

  @override
  String get landscape => 'Landschap';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Aantal assen';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Hoeveelheid rijen te gebruiken in $value-modus.';
  }

  @override
  String get showTextOnGridView => 'Tekst in rooster tonen';

  @override
  String get showTextOnGridViewSubtitle =>
      'Tekst (titel, artiest, etc.) laten zien op het muziekscherm.';

  @override
  String get showCoverAsPlayerBackground =>
      'Geblurde cover op spelerachtergrond tonen';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Geblurde coverafbeelding gebruiken als achtergrond van het afspeelscherm.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Liedartiest verbergen wanneer deze hetzelfde is als de albumartiest';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Liedjesartiest tonen wanneer deze hetzelfde is als de albumartiest.';

  @override
  String get disableGesture => 'Gebaren uitschakelen';

  @override
  String get disableGestureSubtitle => 'Gebaren in- of uitschakelen.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Thema';

  @override
  String get system => 'Systeem';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get tabs => 'Tabs';

  @override
  String get cancelSleepTimer => 'Annuleer sleep timer?';

  @override
  String get yesButtonLabel => 'JA';

  @override
  String get noButtonLabel => 'NEE';

  @override
  String get setSleepTimer => 'Slaaptimer instellen';

  @override
  String get minutes => 'Minuten';

  @override
  String get invalidNumber => 'Ongeldig getal';

  @override
  String get sleepTimerTooltip => 'Slaaptimer';

  @override
  String get addToPlaylistTooltip => 'Toevoegen aan afspeellijst';

  @override
  String get addToPlaylistTitle => 'Toevoegen aan afspeellijst';

  @override
  String get removeFromPlaylistTooltip => 'Verwijder van afspeellijst';

  @override
  String get removeFromPlaylistTitle => 'Verwijder van afspeellijst';

  @override
  String get newPlaylist => 'Nieuwe afspeellijst';

  @override
  String get createButtonLabel => 'CREËER';

  @override
  String get playlistCreated => 'Afspeellijst gecreëerd.';

  @override
  String get noAlbum => 'Geen album';

  @override
  String get noItem => 'Geen element';

  @override
  String get noArtist => 'Geen artiest';

  @override
  String get unknownArtist => 'Onbekende artiest';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'GEDOWNLOAD';

  @override
  String get transcode => 'CONVERTEREN';

  @override
  String get direct => 'DIRECT';

  @override
  String get statusError => 'STATUS FOUT';

  @override
  String get queue => 'Afspeelrij';

  @override
  String get addToQueue => 'Voeg toe aan rij';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Afspeelrij vervangen';

  @override
  String get instantMix => 'Instant mix';

  @override
  String get goToAlbum => 'Ga naar album';

  @override
  String get removeFavourite => 'Verwijder favoriet';

  @override
  String get addFavourite => 'Toevoegen aan favorieten';

  @override
  String get addedToQueue => 'Toegevoegd aan rij.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Rij vervangen.';

  @override
  String get removedFromPlaylist => 'Verwijderd van afspeellijst.';

  @override
  String get startingInstantMix => 'Instantmix starten.';

  @override
  String get anErrorHasOccured => 'Er is een fout opgetreden.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. Dit betekenr waarschijnlijk dat u de verkeerde gebruikersnaam/wachtwoord hebt gebruikt, of uw apparaat niet langer geauthenticeerd is.';
  }

  @override
  String get removeFromMix => 'Uit mix verwijderen';

  @override
  String get addToMix => 'Aan mix toevoegen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count elementen opnieuw gedownload',
      one: '$count element opnieuw gedownload',
      zero: 'Geen downloads nodig.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Bufferlengte';

  @override
  String get bufferDurationSubtitle =>
      'De lengte van de buffer, in seconden. Dit vereist een herstart.';

  @override
  String get language => 'Taal';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get showUncensoredLogMessage =>
      'Dit logboek bevat uw inloggegevens. Tonen?';

  @override
  String get resetTabs => 'Tabbladen resetten';

  @override
  String get noMusicLibrariesTitle => 'No Music Libraries';

  @override
  String get noMusicLibrariesBody =>
      'Finamp could not find any music libraries. Please ensure that your Jellyfin server contains at least one library with the content type set to \"Music\".';

  @override
  String get refresh => 'REFRESH';

  @override
  String get swipeInsertQueueNext => 'Play Swiped Song Next';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Enable to insert a song as next item in queue when swiped in song list instead of appending it to the end.';

  @override
  String get redesignBeta => 'Try the Beta';

  @override
  String get playbackOrderShuffledTooltip => 'Shuffling. Tap to toggle.';

  @override
  String get playbackOrderLinearTooltip => 'Playing in order. Tap to toggle.';

  @override
  String get loopModeAllTooltip => 'Looping all. Tap to toggle.';

  @override
  String get loopModeOneTooltip => 'Looping one. Tap to toggle.';

  @override
  String get loopModeNoneTooltip => 'Not looping. Tap to toggle.';

  @override
  String get skipToPrevious => 'Skip to Previous Song';

  @override
  String get skipToNext => 'Skip to Next Song';

  @override
  String get togglePlayback => 'Toggle Playback';

  @override
  String playArtist(String artist) {
    return 'Play all albums by $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Shuffle all albums by $artist';
  }

  @override
  String downloadArtist(String artist) {
    return 'Download all albums by $artist';
  }

  @override
  String get deleteFromDevice => 'Delete from Device';

  @override
  String get download => 'Download';

  @override
  String get sync => 'Synchronize with Server';

  @override
  String get about => 'About Finamp';
}
