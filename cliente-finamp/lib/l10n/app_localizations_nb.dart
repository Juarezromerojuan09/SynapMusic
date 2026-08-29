// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String startupError(String error) {
    return 'Noe gikk galt under oppstart av programmet. Feilen var: $error\n\nOpprett en feilrapport på github.com/UnicornsOnLSD/finamp med en skjermavbildning av denne siden. Hvis problemet vedvarer kan du tømme programdata for å tilbakestille programmet.';
  }

  @override
  String get serverUrl => 'Tjener-nettadresse';

  @override
  String get internalExternalIpExplanation =>
      'Hvis du vil ha tilgang til Jellyfin-tjeneren din annensteds fra må du bruke din eksterne IP-adresse.\n\nHvis tjeneren din er på en HTTP-port (80/443) må du angi en port. Dette er sannsynligvis tilfelle hvis tjeneren din er bak en omvendt mellomtjener.';

  @override
  String get emptyServerUrl => 'Tjener-nettadressen kan ikke stå tom';

  @override
  String get urlStartWithHttps =>
      'Nettadressen må starte med http:// eller https://';

  @override
  String get urlTrailingSlash =>
      'Nettadressen kan ikke inneholde avsluttende skråstrek';

  @override
  String get username => 'Brukernavn';

  @override
  String get password => 'Passord';

  @override
  String get logs => 'Loggføring';

  @override
  String get next => 'Neste';

  @override
  String get selectMusicLibraries => 'Velg musikkbibliotek';

  @override
  String get couldNotFindLibraries => 'Fant ikke noen bibliotek.';

  @override
  String get unknownName => 'Ukjent navn';

  @override
  String get songs => 'Spor';

  @override
  String get albums => 'Album';

  @override
  String get artists => 'Artister';

  @override
  String get genres => 'Sjangere';

  @override
  String get playlists => 'Spillelister';

  @override
  String get startMix => 'Start miks';

  @override
  String get startMixNoSongsArtist =>
      'Lang-trykk på en artist for å legge til eller fjerne vedkommende fra miksbyggeren før du starter en miks';

  @override
  String get startMixNoSongsAlbum =>
      'Lang-trykk et album for å legge til eller fjerne det fra miksbyggeren før du starter en miks';

  @override
  String get music => 'Musikk';

  @override
  String get clear => 'Tøm';

  @override
  String get favourites => 'Favoritter';

  @override
  String get shuffleAll => 'Tilfelding avspilling av alt';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Nedlastninger';

  @override
  String get settings => 'Innstillinger';

  @override
  String get offlineMode => 'Frakoblet modus';

  @override
  String get sortOrder => 'Sorteringsrekkefølge';

  @override
  String get sortBy => 'Sorter etter';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumsartist';

  @override
  String get artist => 'Artist';

  @override
  String get budget => 'Budsjett';

  @override
  String get communityRating => 'Gemenskapsvurdering';

  @override
  String get criticRating => 'Kritikervurdering';

  @override
  String get dateAdded => 'Dato lagt til';

  @override
  String get datePlayed => 'Dato avspilt';

  @override
  String get playCount => 'Avspillingsantall';

  @override
  String get premiereDate => 'Premieredato';

  @override
  String get productionYear => 'Produksjonsår';

  @override
  String get name => 'Navn';

  @override
  String get random => 'Tilfeldig';

  @override
  String get revenue => 'Omsetning';

  @override
  String get runtime => 'Lengde';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Last ned manglende bilder';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lastet ned $count manglende bilder',
      one: 'Lastet ned $count manglende bilde',
      zero: 'Fant ingen manglende bilder',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Nedlastingsfeil';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedlastinger',
      one: '$count nedlasting',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementer',
      one: '$count element',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilder',
      one: '$count bilde',
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
    return '$count fullført';
  }

  @override
  String dlFailed(int count) {
    return '$count mislykket';
  }

  @override
  String dlEnqueued(int count) {
    return '$count i kø';
  }

  @override
  String dlRunning(int count) {
    return '$count kjører';
  }

  @override
  String get downloadErrorsTitle => 'Nedlastingsfeil';

  @override
  String get noErrors => 'Ingen feil.';

  @override
  String get errorScreenError =>
      'En feil inntraff under innhenting av listen over feil. Herfra bør du kanskje opprette en feilrapport på GitHub og slette programdataen.';

  @override
  String get failedToGetSongFromDownloadId =>
      'Klarte ikke å hente spor fra nedlastings-ID';

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
  String get error => 'Feil';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'Spill';

  @override
  String get shuffleButtonLabel => 'Tilfeldig avspilling';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spor',
      one: '$count spor',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Rediger spillelistenavn';

  @override
  String get editPlaylistNameTitle => 'Rediger spillelistenavn';

  @override
  String get required => 'Påkrevd';

  @override
  String get updateButtonLabel => 'Oppdater';

  @override
  String get playlistNameUpdated => 'Spillelistenavn oppdatert.';

  @override
  String get favourite => 'Favorittmerk';

  @override
  String get downloadsDeleted => 'Nedlastinger slettet.';

  @override
  String get addDownloads => 'Legg til nedlastinger';

  @override
  String get location => 'Sted';

  @override
  String get downloadsAdded => 'Nedlastinger lagt til.';

  @override
  String get addButtonLabel => 'Legg til';

  @override
  String get shareLogs => 'Del logger';

  @override
  String get logsCopied => 'Logger kopiert';

  @override
  String get message => 'Melding';

  @override
  String get stackTrace => 'Stabelspor';

  @override
  String get applicationLegalese =>
      'Lisensiert MPL 2.0, med kildekode tilgjengelig på\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkoding';

  @override
  String get downloadLocations => 'Nedlastingssteder';

  @override
  String get audioService => 'Lydtjeneste';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Posisjonering og draktvalg';

  @override
  String get notAvailableInOfflineMode => 'Ikke tilgjengelig i frakoblet modus';

  @override
  String get logOut => 'Logg ut';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Nedlastede spor vil ikke slettes';

  @override
  String get areYouSure => 'Er du sikker?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin bruker AAC for transkoding';

  @override
  String get enableTranscoding => 'Skru på transkoding';

  @override
  String get enableTranscodingSubtitle =>
      'Transkoder musikkstrømmer på tjenersiden.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Høyere bitrate gir lyd i bedre kvalitet, på bekostning av høyere båndbreddebruk.';

  @override
  String get customLocation => 'Egendefinert sted';

  @override
  String get appDirectory => 'Programmappe';

  @override
  String get addDownloadLocation => 'Legg til nedlastingssted';

  @override
  String get selectDirectory => 'Velg mappe';

  @override
  String get unknownError => 'Ukjent feil';

  @override
  String get pathReturnSlashErrorMessage =>
      'Stier som returnerer «/» kan ikke brukes.';

  @override
  String get directoryMustBeEmpty => 'Mappen må være tom';

  @override
  String get customLocationsBuggy =>
      'Egendefinerte steder fungerer dårlig som følge av problemer med tilganger. Måter å løse det på vurderes, men akkurat nå anbefales ikke bruk.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Gå inn i lavprioritetstilstand ved pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Lar merknaden bli dratt unna under pause. Tillater også Android å drepe tjenesten når pauset.';

  @override
  String get shuffleAllSongCount => 'Antall spor for tilfeldig avspilling';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Mengden spor å laste inn ved bruk av «Tilfeldig avspilling av alle spor»-knappen.';

  @override
  String get viewType => 'Visningstype';

  @override
  String get viewTypeSubtitle => 'Visningstype for musikkskjermen';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Rutenett';

  @override
  String get portrait => 'Stående';

  @override
  String get landscape => 'Liggende';

  @override
  String gridCrossAxisCount(String value) {
    return '$value rutenettsakseantall';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Mengden rutenettsflis å bruke per rad i $value-modus.';
  }

  @override
  String get showTextOnGridView => 'Vis tekst i rutenettsvisning';

  @override
  String get showTextOnGridViewSubtitle =>
      'Hvorvidt tekst (navn, artist, osv.( skal vises i rutenettsmusikkskjermen.';

  @override
  String get showCoverAsPlayerBackground =>
      'Vis tilslørt omslag som avspillerbakgrunn';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Hvorvidt tilslørt omslag skal brukes som bakgrunn på avspillerskjermen.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Skjul artister for sporet hvis samme som albumsartister';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Hvorvidt sporartister skal vises på albumsskjermen hvis forskjellig fra albumsartister.';

  @override
  String get disableGesture => 'Skru av håndvendinger';

  @override
  String get disableGestureSubtitle => 'Hvorvidt håndvendinger skal skrus av.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Drakt';

  @override
  String get system => 'System';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get tabs => 'Faner';

  @override
  String get cancelSleepTimer => 'Avbryt søvntidsur?';

  @override
  String get yesButtonLabel => 'Ja';

  @override
  String get noButtonLabel => 'Nei';

  @override
  String get setSleepTimer => 'Sett søvntidsur';

  @override
  String get minutes => 'Minutter';

  @override
  String get invalidNumber => 'Ugyldig tall';

  @override
  String get sleepTimerTooltip => 'Søvntidsur';

  @override
  String get addToPlaylistTooltip => 'Legg til i spilleliste';

  @override
  String get addToPlaylistTitle => 'Legg til i spilleliste';

  @override
  String get removeFromPlaylistTooltip => 'Fjern fra spilleliste';

  @override
  String get removeFromPlaylistTitle => 'Fjern fra spilleliste';

  @override
  String get newPlaylist => 'Ny spilleliste';

  @override
  String get createButtonLabel => 'Opprett';

  @override
  String get playlistCreated => 'Spilleliste opprettet.';

  @override
  String get noAlbum => 'Ingen album';

  @override
  String get noItem => 'Ingen elementer';

  @override
  String get noArtist => 'Ingen artister';

  @override
  String get unknownArtist => 'Ukjent artist';

  @override
  String get streaming => 'Strømming';

  @override
  String get downloaded => 'Nedlastet';

  @override
  String get transcode => 'Transkod';

  @override
  String get direct => 'Direkte';

  @override
  String get statusError => 'Statusfeil';

  @override
  String get queue => 'Kø';

  @override
  String get addToQueue => 'Legg til i kø';

  @override
  String get playNext => 'Spill neste';

  @override
  String get replaceQueue => 'Erstatt kø';

  @override
  String get instantMix => 'Umiddelbar miks';

  @override
  String get goToAlbum => 'Gå til album';

  @override
  String get removeFavourite => 'Fjern favoritt';

  @override
  String get addFavourite => 'Legg til favoritt';

  @override
  String get addedToQueue => 'Lagt til i kø.';

  @override
  String get insertedIntoQueue => 'Lagt i kø.';

  @override
  String get queueReplaced => 'Kø erstattet.';

  @override
  String get removedFromPlaylist => 'Fjernet fra spilleliste.';

  @override
  String get startingInstantMix => 'Starter umiddelbar miks …';

  @override
  String get anErrorHasOccured => 'Noe gikk galt.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Statuskode $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Statuskode $statusCode. Dette betyr antagelig at du bruker feil brukernavn eller passord, eller at klienten din ikke lenger er innloget.';
  }

  @override
  String get removeFromMix => 'Fjern fra miks';

  @override
  String get addToMix => 'Legg til i miks';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lastet ned igjen $count elementer',
      one: 'Lastet ned igjen $count element',
      zero: 'Ingenting trenger å lastes ned igjen.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Hurtiglagervarighet';

  @override
  String get bufferDurationSubtitle =>
      'Antall sekunder avspilleren skal mellomlagre. Krever programomstart.';

  @override
  String get language => 'Språk';

  @override
  String get confirm => 'Bekreft';

  @override
  String get showUncensoredLogMessage =>
      'Denne loggen inneholder din innloggingsinfo. Vis?';

  @override
  String get resetTabs => 'Tilbakestill faner';

  @override
  String get noMusicLibrariesTitle => 'Ingen musikkbibliotek';

  @override
  String get noMusicLibrariesBody =>
      'Finamp fant ingen musikkbibliotek. Forsikre deg om at din Jellyfin-tjener inneholder minst ett bibliotek med innholdstype satt til «Musikk».';

  @override
  String get refresh => 'Gjenoppfrisk';

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
