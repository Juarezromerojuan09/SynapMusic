// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String startupError(String error) {
    return 'Noget gik galt under app opstarten. Fejlen er $error\n\nVenligst opret en sag på github.com/UnicornsOnLSD/finamp med et skærmbillede af denne side. Hvis dette problem forbliver, så kan du fjerne dine app data for at nulstille appen.';
  }

  @override
  String get serverUrl => 'Server URL';

  @override
  String get internalExternalIpExplanation =>
      'Hvis du vil være i stand til at tilgå din Jellyfin server udefra, skal du bruge din eksterne IP.\n\nHvis din server er på HTTP porten (80/443), behøver du ikke angive en port. Dette er som regel tilfældet, hvis din server er bag en reverse proxy.';

  @override
  String get emptyServerUrl => 'Server URL kan ikke være tom';

  @override
  String get urlStartWithHttps => 'URL skal starte med http:// eller https://';

  @override
  String get urlTrailingSlash =>
      'URL må ikke indeholde en efterfølgnede stråstreg';

  @override
  String get username => 'Brugernavn';

  @override
  String get password => 'Adgangskode';

  @override
  String get logs => 'Log';

  @override
  String get next => 'Næste';

  @override
  String get selectMusicLibraries => 'Vælg musik biblioteker';

  @override
  String get couldNotFindLibraries => 'Kunne ikke finde nogle biblioteker.';

  @override
  String get unknownName => 'Ukendt navn';

  @override
  String get songs => 'Sange';

  @override
  String get albums => 'Albummer';

  @override
  String get artists => 'Kunstnere';

  @override
  String get genres => 'Genre';

  @override
  String get playlists => 'Afspilningslister';

  @override
  String get startMix => 'Start blanding';

  @override
  String get startMixNoSongsArtist =>
      'Tryk (lang tid) på en kunstner for at tilføje eller fjerne den fra blandingen før du starter en blanding';

  @override
  String get startMixNoSongsAlbum =>
      'Tryk (lang tid) på et album for at tilføje eller fjerne det fra blandingen for du starter en blanding';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Ryd';

  @override
  String get favourites => 'Favoritter';

  @override
  String get shuffleAll => 'Bland alle';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Overførelser';

  @override
  String get settings => 'Indstillinger';

  @override
  String get offlineMode => 'Offline tilstand';

  @override
  String get sortOrder => 'Sorter efter';

  @override
  String get sortBy => 'Sortér efter';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album kunstner';

  @override
  String get artist => 'Kunstner';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Fællesskab bedømmelse';

  @override
  String get criticRating => 'Kritiker bedømmelse';

  @override
  String get dateAdded => 'Dato tilføjet';

  @override
  String get datePlayed => 'Afspillet den';

  @override
  String get playCount => 'Antal afspilninger';

  @override
  String get premiereDate => 'Udgivelsesdato';

  @override
  String get productionYear => 'Produktionsår';

  @override
  String get name => 'Navn';

  @override
  String get random => 'Tilfældig';

  @override
  String get revenue => 'Omsætning';

  @override
  String get runtime => 'Spilletid';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Overførelse mangler billeder';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Overførte $count manglende billeder',
      one: 'Overførte $count manglende billeder',
      zero: 'Ingen manglende billeder blev fundet',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Overførelsesfejl';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overførelser',
      one: '$count overført',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emner',
      one: '$count emne',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billeder',
      one: '$count billede',
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
    return '$count færdige';
  }

  @override
  String dlFailed(int count) {
    return '$count fejlede';
  }

  @override
  String dlEnqueued(int count) {
    return '$count i kø';
  }

  @override
  String dlRunning(int count) {
    return '$count er igang';
  }

  @override
  String get downloadErrorsTitle => 'Overførelsesfejl';

  @override
  String get noErrors => 'Ingen fejl!';

  @override
  String get errorScreenError =>
      'Der opstod en fejl under hentningen af listen med fejl! På dette tidspunkt, bedes du oprette en fejl på Github og slette appens data';

  @override
  String get failedToGetSongFromDownloadId =>
      'Fejlede under hentning af sang fra overførelse ID';

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
  String get error => 'Fejl';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'AFSPIL';

  @override
  String get shuffleButtonLabel => 'BLAND';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sange',
      one: '$count Sang',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Rediger afspilningslistens navn';

  @override
  String get editPlaylistNameTitle => 'Rediger afspilningslistens navn';

  @override
  String get required => 'Påkrævet';

  @override
  String get updateButtonLabel => 'OPDATÉR';

  @override
  String get playlistNameUpdated => 'Afspilningslistens navn er opdateret.';

  @override
  String get favourite => 'Favorit';

  @override
  String get downloadsDeleted => 'Overførelser slettet.';

  @override
  String get addDownloads => 'Tilføj overførelser';

  @override
  String get location => 'Placering';

  @override
  String get downloadsAdded => 'Overførelse tilføjet.';

  @override
  String get addButtonLabel => 'TILFØJ';

  @override
  String get shareLogs => 'Del log';

  @override
  String get logsCopied => 'Log kopieret.';

  @override
  String get message => 'Besked';

  @override
  String get stackTrace => 'Bunke spor';

  @override
  String get applicationLegalese =>
      'Licenseret med Mozilla Public License 2.0. Kildeteksten er tilgængelig på:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Omkoder';

  @override
  String get downloadLocations => 'Overførelse placering';

  @override
  String get audioService => 'Lyd tjeneste';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Udseende & tema';

  @override
  String get notAvailableInOfflineMode => 'Ikke tilgængelig i offline tilstand';

  @override
  String get logOut => 'Log af';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Overførte sange vil ikke blive slettet';

  @override
  String get areYouSure => 'Er du sikker?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin bruger AAC ved omkodning';

  @override
  String get enableTranscoding => 'Aktivér omkodning';

  @override
  String get enableTranscodingSubtitle =>
      'Omkoder musik under afspilning på serveren.';

  @override
  String get bitrate => 'Bithastighed';

  @override
  String get bitrateSubtitle =>
      'En højere bithastighed giver højere lydkvalitet men bruger mere båndbredde.';

  @override
  String get customLocation => 'Vælg placering';

  @override
  String get appDirectory => 'App katalog';

  @override
  String get addDownloadLocation => 'Tilføj overførelse placering';

  @override
  String get selectDirectory => 'Vælg katalog';

  @override
  String get unknownError => 'Ukendt fejl';

  @override
  String get pathReturnSlashErrorMessage =>
      'Stier, der returnerer \"/\", kan ikke anvendes';

  @override
  String get directoryMustBeEmpty => 'Katalog skal være tomt';

  @override
  String get customLocationsBuggy =>
      'Valgfrie placeringer er ekstremt fejlramte grundet manglende rettigheder. Jeg prøver at finde måder at løse dette, men for nu anbefaler jeg ikke, at de anvendes.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Gå i lav prioritet tilstand når musik afspilning er på pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Tillader notifikationer bliver strøget væk, når afspilning er sat på pause. Dette tillader også Android, at afbryde servicen når den er på pause.';

  @override
  String get shuffleAllSongCount => 'Bland alle sange antal';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Mængde af sange der skal indlæses, når bland alle sange knappen bruges.';

  @override
  String get viewType => 'Visning tilstand';

  @override
  String get viewTypeSubtitle => 'Visningstype for musik skærmen';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Gitter';

  @override
  String get portrait => 'Portræt';

  @override
  String get landscape => 'Landskab';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Gitter tværakse antal';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Antal gitrebrikker som bruges per række $value.';
  }

  @override
  String get showTextOnGridView => 'Vis tekst i gitter visning';

  @override
  String get showTextOnGridViewSubtitle =>
      'Vælg om tekst skal vises (titel, kunstner osv.) på gitteret musik skærm.';

  @override
  String get showCoverAsPlayerBackground =>
      'Vis sløret cover som afspiller baggrund';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Vælg om der skal bruges sløret omslagskunst som vises som baggrund på afspiller skærmen.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Skjul sang kunstner, hvis det er den samme som albummets kunstner';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Vælg om sangens kunstner skal vises på albummet, hvis den ikke er forskellig fra albummets kunstner.';

  @override
  String get disableGesture => 'Deaktivér bevægelser';

  @override
  String get disableGestureSubtitle => 'Vælg om bevægelser skal deaktiveres.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'System';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get tabs => 'Faner';

  @override
  String get cancelSleepTimer => 'Vil du annullere sove timeren?';

  @override
  String get yesButtonLabel => 'JA';

  @override
  String get noButtonLabel => 'NEJ';

  @override
  String get setSleepTimer => 'Indtil sove timer';

  @override
  String get minutes => 'Minutter';

  @override
  String get invalidNumber => 'Ugyldig nummer';

  @override
  String get sleepTimerTooltip => 'Sove timer';

  @override
  String get addToPlaylistTooltip => 'Tilføj til afspilningsliste';

  @override
  String get addToPlaylistTitle => 'Tilføj til afspilningsliste';

  @override
  String get removeFromPlaylistTooltip => 'Fjern fra afspilningsliste';

  @override
  String get removeFromPlaylistTitle => 'Fjern fra afspilningsliste';

  @override
  String get newPlaylist => 'Ny afspilningsliste';

  @override
  String get createButtonLabel => 'OPRET';

  @override
  String get playlistCreated => 'Afspilningsliste er oprettet.';

  @override
  String get noAlbum => 'Intet album';

  @override
  String get noItem => 'Intet objekt';

  @override
  String get noArtist => 'Ingen kunstner';

  @override
  String get unknownArtist => 'Ukendt kunstner';

  @override
  String get streaming => 'STREAMER';

  @override
  String get downloaded => 'OVERFØRELSER';

  @override
  String get transcode => 'OMKOD';

  @override
  String get direct => 'DIREKTE';

  @override
  String get statusError => 'Status fejl';

  @override
  String get queue => 'Kø';

  @override
  String get addToQueue => 'Tilføj til kø';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Udskift køen';

  @override
  String get instantMix => 'Hurtig blanding';

  @override
  String get goToAlbum => 'Gå til album';

  @override
  String get removeFavourite => 'Fjern favorit';

  @override
  String get addFavourite => 'Tilføj favorit';

  @override
  String get addedToQueue => 'Tilføjet til kø.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Køen er udskiftet.';

  @override
  String get removedFromPlaylist => 'Fjernet fra afspilningslisten.';

  @override
  String get startingInstantMix => 'Starter hurtig blanding.';

  @override
  String get anErrorHasOccured => 'Der opstod en fejl.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status kode $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status kode $statusCode. Dette betyder, at du har anvendt et forkert brugernavn/adgangskode eller at din klient ikke længere er logget på.';
  }

  @override
  String get removeFromMix => 'Fjern fra blanding';

  @override
  String get addToMix => 'Tilføj til blanding';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Genoverfører $count objekter',
      one: 'Genoverførte $count objekt',
      zero: 'Ingen genoverførsel er nødvendig.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Buffer varighed';

  @override
  String get bufferDurationSubtitle =>
      'Hvor meget afspilleren skal forudindlæse i sekunder. En genstart er nødvendig.';

  @override
  String get language => 'Sprog';

  @override
  String get confirm => 'Confirm';

  @override
  String get showUncensoredLogMessage =>
      'This log contains your login information. Show?';

  @override
  String get resetTabs => 'Reset tabs';

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
