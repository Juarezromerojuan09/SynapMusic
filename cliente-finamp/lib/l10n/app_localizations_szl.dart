// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Silesian (`szl`).
class AppLocalizationsSzl extends AppLocalizations {
  AppLocalizationsSzl([String locale = 'szl']) : super(locale);

  @override
  String startupError(String error) {
    return 'Coś poszło źle przi ôtwiyraniu aplikacyje. Feler to: $error\n\nZgłoś to na github.com/UnicornsOnLSD/finamp ze zopisym ekranu tyj strōny. Jeźli ta strōna niy przestowo sie pokazować, to wymaż dane aplikacyje, żeby ja zresetować.';
  }

  @override
  String get serverUrl => 'Adresa URL ôd serwera';

  @override
  String get internalExternalIpExplanation =>
      'Jeźli chcesz mieć zdalny przistymp do swojigo serwera Jellyfin, to potrzebujesz zewnyntrznego IP..\n\nJeźli twōj serwer je na porcie HTTP (80/443), to niy musisz podować portu. Tak nojczyńścij je, jak serwer je za reverse proxy.';

  @override
  String get emptyServerUrl => 'Adresa URL ôd serwera niy może być prōzno';

  @override
  String get urlStartWithHttps =>
      'URL musi sie zaczynać ôd http:// abo https://';

  @override
  String get urlTrailingSlash => 'URL niy może sie kōńczyć znakym „/”';

  @override
  String get username => 'Miano ôd używocza';

  @override
  String get password => 'Hasło';

  @override
  String get logs => 'Logi';

  @override
  String get next => 'Dalij';

  @override
  String get selectMusicLibraries => 'Wybier bibliotyki ze muzykōm';

  @override
  String get couldNotFindLibraries => 'Niy szło znojś żodnych bibliotyk.';

  @override
  String get unknownName => 'Niyznōme miano';

  @override
  String get songs => 'Śpiywki';

  @override
  String get albums => 'Albumy';

  @override
  String get artists => 'Artyścio';

  @override
  String get genres => 'Gatōnki';

  @override
  String get playlists => 'Playlisty';

  @override
  String get startMix => 'Zacznij mix';

  @override
  String get startMixNoSongsArtist =>
      'Prziciś dugo na artysty, żeby go dodać abo wymazać ze budowanio miksu, podwiela go puścisz';

  @override
  String get startMixNoSongsAlbum =>
      'Prziciś dugo na album, żeby go dodać abo wymazać ze budowanio miksu, podwiela go puścisz';

  @override
  String get music => 'Muzyka';

  @override
  String get clear => 'Wysnoż';

  @override
  String get favourites => 'Ôblubiōne';

  @override
  String get shuffleAll => 'Miyszej wszysko';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Pobrane';

  @override
  String get settings => 'Sztalōnki';

  @override
  String get offlineMode => 'Tryb offline';

  @override
  String get sortOrder => 'Porzōndek zortowanio';

  @override
  String get sortBy => 'Zortuj podug';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artysta albumu';

  @override
  String get artist => 'Artysta';

  @override
  String get budget => 'Budżet';

  @override
  String get communityRating => 'Ôcyna ôd społeczności';

  @override
  String get criticRating => 'Ôcyna ôd krytykōw';

  @override
  String get dateAdded => 'Data dodanio';

  @override
  String get datePlayed => 'Datōm granio';

  @override
  String get playCount => 'Liczba grań';

  @override
  String get premiereDate => 'Datōm prymiery';

  @override
  String get productionYear => 'Rok produkcyje';

  @override
  String get name => 'Nazwa';

  @override
  String get random => 'Lōsowo';

  @override
  String get revenue => 'Dochōd';

  @override
  String get runtime => 'Czas twanio';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Pobier ôbrazy, co brakujōm';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liczba pobranych ôbrazōw, co brakujōm: $count',
      one: 'Pobrany $count ôbroz, co brakuje',
      zero: 'Niy brakuje żodnych ôbrazōw',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Felery pobiyranio';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobrań',
      one: '$count pobranie',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elymyntōw',
      one: '$count elymynt',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ôbrazōw',
      one: '$count ôbroz',
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
    return '$count podarzōne';
  }

  @override
  String dlFailed(int count) {
    return '$count niypodarzōne';
  }

  @override
  String dlEnqueued(int count) {
    return '$count we raji';
  }

  @override
  String dlRunning(int count) {
    return '$count two';
  }

  @override
  String get downloadErrorsTitle => 'Felery pobiyranio';

  @override
  String get noErrors => 'Bez felerōw!';

  @override
  String get errorScreenError =>
      'Doszło do feleru przi pobiyraniu wykazu felerōw! We takim przipodku chyba nojlepij to zgłosić na GitHubie i skasować dane ôd aplikacyje';

  @override
  String get failedToGetSongFromDownloadId =>
      'Niy szło znojś śpiywki ze ID pobiyranio';

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
  String get error => 'Feler';

  @override
  String discNumber(int number) {
    return 'Dysk $number';
  }

  @override
  String get playButtonLabel => 'GREJ';

  @override
  String get shuffleButtonLabel => 'LŌSOWO';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count śpiywek',
      one: '$count śpiywka',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Edytowanie miana ôd playlisty';

  @override
  String get editPlaylistNameTitle => 'Edycyjo miana ôd playlisty';

  @override
  String get required => 'Wymogane';

  @override
  String get updateButtonLabel => 'SPAMIYNTEJ';

  @override
  String get playlistNameUpdated => 'Miano ôd playlisty spamiyntane.';

  @override
  String get favourite => 'Ôblubiōny';

  @override
  String get downloadsDeleted => 'Pobrane skasowane.';

  @override
  String get addDownloads => 'Dodej pobrane';

  @override
  String get location => 'Lokalizacyjo';

  @override
  String get downloadsAdded => 'Pobrane dodane.';

  @override
  String get addButtonLabel => 'DODEJ';

  @override
  String get shareLogs => 'Podziel sie logami';

  @override
  String get logsCopied => 'Logi skopiowane.';

  @override
  String get message => 'Wiadōmość';

  @override
  String get stackTrace => 'Ślod stōsa';

  @override
  String get applicationLegalese =>
      'Na licyncyji Mozilla Public License 2.0. Zdrzōdłowy kod je przistympny na:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkodowanie';

  @override
  String get downloadLocations => 'Lokacyje pobiyranio';

  @override
  String get audioService => 'Usuga audio';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Ukłod i tymat';

  @override
  String get notAvailableInOfflineMode => 'Niyprzistympne we trybie offline';

  @override
  String get logOut => 'Ôdloguj';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Pobrane śpiywki niy bydōm wymazane';

  @override
  String get areYouSure => 'Na zicher?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin używo AAC do transkodowanio';

  @override
  String get enableTranscoding => 'Włōncz transkodowanie';

  @override
  String get enableTranscodingSubtitle =>
      'Jeźli zaznaczōne, to strumiynie muzyki bydōm transkodowane na serwerze.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Wyższy bitrate dowo wyższo jakość audio kosztym srogszego transferu danych.';

  @override
  String get customLocation => 'Włosno lokacyjo';

  @override
  String get appDirectory => 'Katalog ôd aplikacyje';

  @override
  String get addDownloadLocation => 'Dodej lokacyjo pobiyranio';

  @override
  String get selectDirectory => 'Wybier katalog';

  @override
  String get unknownError => 'Niyznōmy feler';

  @override
  String get pathReturnSlashErrorMessage =>
      'Ściyżek, co skazujōm „/”, niy idzie używać';

  @override
  String get directoryMustBeEmpty => 'Katalog musi być prōzny';

  @override
  String get customLocationsBuggy =>
      'Ze włosnymi lokacyjami je moc problymōw skuli turbacyji ze uprawniyniami. Sōm rozwożane spōsoby sprawiynio tego, ale teroz jejich używanie niy ma rekōmyndowane.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Przi pauzie przejdź we stōn niskigo priorytetu';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Kej to je włōnczōne, to powiadōmiynie może być ôdpōnkniynte przi pauzie. Włōnczynie tego przizwolo tyż Androidowi zabic usuga przi pauzie.';

  @override
  String get shuffleAllSongCount => 'Liczba śpiywek przi miyszaniu wszyskich';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Liczba śpiywek do zaladowanio po użyciu knefla miyszanio wszyskich śpiywek.';

  @override
  String get viewType => 'Widok';

  @override
  String get viewTypeSubtitle => 'Widok panelu muzyki';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Krotka';

  @override
  String get portrait => 'Do blaju';

  @override
  String get landscape => 'Poziōmo';

  @override
  String gridCrossAxisCount(String value) {
    return '$value – liczba elymyntōw we rzyńdzie krotki';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Liczba użytych kachelek we rzyńdzie krotki: $value.';
  }

  @override
  String get showTextOnGridView => 'Pokazuj tekst we widoku krotki';

  @override
  String get showTextOnGridViewSubtitle =>
      'Sztaluje, jeźli pokazować tekst (tytuł, artysta itd.) we panelu krotki elymyntōw.';

  @override
  String get showCoverAsPlayerBackground =>
      'Pokazuj rozmazano ôkładzina za tło ôd przegrowacza';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Sztaluje, jeźli pokazować rozmazano ôkładzina za tło ôd przegrowacza.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Skryj artysty śpiywki, jeźli je taki sōm jak artysta albumu';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Sztaluje, jeźli kryć artysty śpiywki, jeźli je taki sōm jak artysta albumu.';

  @override
  String get disableGesture => 'Disable gestures';

  @override
  String get disableGestureSubtitle => 'Whether to disables gestures.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Tymat';

  @override
  String get system => 'Systymowy';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciymny';

  @override
  String get tabs => 'Zokłodki';

  @override
  String get cancelSleepTimer => 'Ôdwołać ôdliczanie do zastawiynio?';

  @override
  String get yesButtonLabel => 'JA';

  @override
  String get noButtonLabel => 'NIY';

  @override
  String get setSleepTimer => 'Nasztaluj ôdliczanie do zastawiynio';

  @override
  String get minutes => 'Minutes';

  @override
  String get invalidNumber => 'Niynoleżno liczba';

  @override
  String get sleepTimerTooltip => 'Ôdliczanie do zastawiynio';

  @override
  String get addToPlaylistTooltip => 'Dodej do playlisty';

  @override
  String get addToPlaylistTitle => 'Dodej do playlisty';

  @override
  String get removeFromPlaylistTooltip => 'Remove from playlist';

  @override
  String get removeFromPlaylistTitle => 'Remove from Playlist';

  @override
  String get newPlaylist => 'Nowo playlista';

  @override
  String get createButtonLabel => 'STWŌRZ';

  @override
  String get playlistCreated => 'Playlista stworzōno.';

  @override
  String get noAlbum => 'Brak albumu';

  @override
  String get noItem => 'Brak elymyntu';

  @override
  String get noArtist => 'Brak artysty';

  @override
  String get unknownArtist => 'Niyznōmy artysta';

  @override
  String get streaming => 'STRUMIYNIOWANIE';

  @override
  String get downloaded => 'POBRANE';

  @override
  String get transcode => 'TRANSKODOWANIE';

  @override
  String get direct => 'BEZPOSTRZEDNIE';

  @override
  String get statusError => 'FELER STATUSU';

  @override
  String get queue => 'Raja';

  @override
  String get addToQueue => 'Dodej do raje';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Zastōmp raja';

  @override
  String get instantMix => 'Wartki mix';

  @override
  String get goToAlbum => 'Idź do albumu';

  @override
  String get removeFavourite => 'Wymaż ze ôblubiōnych';

  @override
  String get addFavourite => 'Dodej do ôblubiōnych';

  @override
  String get addedToQueue => 'Dodane do raje.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Raja zastōmpiōno.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Zaczynanie wartkigo miksu.';

  @override
  String get anErrorHasOccured => 'Doszło do feleru.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Kod statusu $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Kod statusu $statusCode. To bezma ôznaczo, że było użyto niynoleżne miano ôd używocza abo hasło, abo tyż twōj kliynt już niy ma autoryzowany.';
  }

  @override
  String get removeFromMix => 'Wymaż ze miksu';

  @override
  String get addToMix => 'Dodej do miksu';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redownloaded $count items',
      one: 'Redownloaded $count item',
      zero: 'No redownloads needed.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Buffer Duration';

  @override
  String get bufferDurationSubtitle =>
      'How much the player should buffer, in seconds. Requires a restart.';

  @override
  String get language => 'Language';

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
