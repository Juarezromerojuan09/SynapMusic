// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String startupError(String error) {
    return 'Hiba történt az alkalmazás indításakor! A hiba a következő volt: $error\n\nKérjük, hozzon létre egyGithub-problémát a github.com/UnicornsOnLSD/finamp oldalon az oldal képernyőképével. Ha a probléma továbbra is fennáll, törölje az alkalmazás adatait az alkalmazás visszaállításához.';
  }

  @override
  String get serverUrl => 'Szerver webcíme';

  @override
  String get internalExternalIpExplanation =>
      'Ha távolról szeretné elérni Jellyfin szerverét, akkor külső IP-címét kell használnia.\n\nHa a szerver HTTP porton (80/443) van, akkor nem kell portot megadnia. Valószínűleg ez a helyzet akkor, ha a szervere fordított proxy mögött van.';

  @override
  String get emptyServerUrl => 'A szerver URL-címe nem lehet üres';

  @override
  String get urlStartWithHttps =>
      'Az URL-nek \"http://\" vagy \"https://\" előtaggal kell kezdődnie';

  @override
  String get urlTrailingSlash => 'Az URL végén nem lehet \"/\"-jel';

  @override
  String get username => 'Felhasználónév';

  @override
  String get password => 'Jelszó';

  @override
  String get logs => 'Naplók';

  @override
  String get next => 'Következő';

  @override
  String get selectMusicLibraries => 'Zenei könyvtárak kiválasztása';

  @override
  String get couldNotFindLibraries => 'Nem található könyvtár.';

  @override
  String get unknownName => 'Ismeretlen név';

  @override
  String get songs => 'Dalok';

  @override
  String get albums => 'Albumok';

  @override
  String get artists => 'Előadók';

  @override
  String get genres => 'Műfajok';

  @override
  String get playlists => 'Lejátszási listák';

  @override
  String get startMix => 'Mix elindítása';

  @override
  String get startMixNoSongsArtist =>
      'Nyomd meg hosszan az előadót, hogy hozzáadja vagy eltávolítsa őket a mixkészítőből, mielőtt elkezdené a keverést';

  @override
  String get startMixNoSongsAlbum =>
      'Nyomd meg hosszan az albumot, hogy hozzáadja vagy eltávolítsa őket a mixkészítőből, mielőtt elkezdené a keverést';

  @override
  String get music => 'Zene';

  @override
  String get clear => 'Törlés';

  @override
  String get favourites => 'Kedvencek';

  @override
  String get shuffleAll => 'Összes keverése';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Letöltések';

  @override
  String get settings => 'Beállítások';

  @override
  String get offlineMode => 'Offline mód';

  @override
  String get sortOrder => 'Rendezési sorrend';

  @override
  String get sortBy => 'Sorrend eszerint';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album előadó';

  @override
  String get artist => 'Előadó';

  @override
  String get budget => 'Költségvetés';

  @override
  String get communityRating => 'Közösségi értékelés';

  @override
  String get criticRating => 'Kritikusok értékelése';

  @override
  String get dateAdded => 'Hozzáadás dátuma';

  @override
  String get datePlayed => 'Lejátszva ekkor';

  @override
  String get playCount => 'Lejátszások száma';

  @override
  String get premiereDate => 'Premier dátuma';

  @override
  String get productionYear => 'Gyártási év';

  @override
  String get name => 'Név';

  @override
  String get random => 'Véletlen';

  @override
  String get revenue => 'Bevétel';

  @override
  String get runtime => 'Futásidő';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Töltse le a hiányzó képeket';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Letöltött $count hiányzó képet',
      one: 'Letöltődött $count hiányzó kép',
      zero: 'Nem található hiányzó kép',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Letöltési hibák';

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
    return '$count kész';
  }

  @override
  String dlFailed(int count) {
    return '$count nem sikerült';
  }

  @override
  String dlEnqueued(int count) {
    return '$count a sorban';
  }

  @override
  String dlRunning(int count) {
    return '$count Fut';
  }

  @override
  String get downloadErrorsTitle => 'Letöltési Hibák';

  @override
  String get noErrors => 'Nincsenek hibák!';

  @override
  String get errorScreenError =>
      'Hiba történt a hibalista lekérésekor! Ezen a ponton valószínűleg csak problémát kell létrehoznia a GitHubon, és törölnie kell az alkalmazásadatokat';

  @override
  String get failedToGetSongFromDownloadId =>
      'Nem sikerült letölteni a dalt, a letöltési azonosítóból';

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
  String get error => 'Hiba';

  @override
  String discNumber(int number) {
    return 'CD $number';
  }

  @override
  String get playButtonLabel => 'LEJÁTSZÁS';

  @override
  String get shuffleButtonLabel => 'KEVERÉS';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '$count Song',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Lejátszási lista címének szerkesztése';

  @override
  String get editPlaylistNameTitle => 'Lejátszási lista címének szerkesztése';

  @override
  String get required => 'Szükséges';

  @override
  String get updateButtonLabel => 'FRISSÍTÉS';

  @override
  String get playlistNameUpdated => 'A lejátszási lista neve frissítve.';

  @override
  String get favourite => 'Kedvenc';

  @override
  String get downloadsDeleted => 'Letöltések törölve.';

  @override
  String get addDownloads => 'Letöltések hozzáadása';

  @override
  String get location => 'Elhelyezkedés';

  @override
  String get downloadsAdded => 'Letöltések hozzáadva.';

  @override
  String get addButtonLabel => 'HOZZÁADÁS';

  @override
  String get shareLogs => 'Naplók megosztása';

  @override
  String get logsCopied => 'A naplók másolva.';

  @override
  String get message => 'Üzenet';

  @override
  String get stackTrace => 'Kötegelt visszalépés';

  @override
  String get applicationLegalese =>
      'A Mozilla Public License 2.0 licenccel. A forráskód elérhető:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transzkódolás';

  @override
  String get downloadLocations => 'Letöltési hely';

  @override
  String get audioService => 'Hangszolgáltatás';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Elrendezés & Téma';

  @override
  String get notAvailableInOfflineMode => 'Offline módban nem elérhető';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'A letöltött dalok nem törlődnek';

  @override
  String get areYouSure => 'Biztos vagy ebben?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin AAC-t használ az transzkódoláshoz';

  @override
  String get enableTranscoding => 'Transzkódolás engedélyezése';

  @override
  String get enableTranscodingSubtitle =>
      'Transzkódolja a zenestreameket a szerver oldalon.';

  @override
  String get bitrate => 'Bitráta';

  @override
  String get bitrateSubtitle =>
      'A nagyobb bitráta jobb hangminőséget biztosít nagyobb sávszélesség mellett.';

  @override
  String get customLocation => 'Egyéni hely';

  @override
  String get appDirectory => 'Alkalmazás Könyvtára';

  @override
  String get addDownloadLocation => 'Letöltési hely hozzáadása';

  @override
  String get selectDirectory => 'Könyvtár kiválasztása';

  @override
  String get unknownError => 'Ismeretlen hiba';

  @override
  String get pathReturnSlashErrorMessage =>
      'A „/” karaktert használó elérési utak nem értelmezhetőek';

  @override
  String get directoryMustBeEmpty => 'A könyvtárnak üresnek kell lennie';

  @override
  String get customLocationsBuggy =>
      'Az egyéni helyek rendkívül bugosak az engedélyekkel kapcsolatos problémák miatt. Gondolkozom a megoldáson, de egyelőre nem javaslom ezek használatát.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Lépjen az Alacsony-prioritású állapotba a Szünet módban';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Lehetővé teszi az értesítés elcsúsztatását, amikor szünetel. Azt is lehetővé teszi, hogy az Android leállítsa a szolgáltatást, amikor szünetel.';

  @override
  String get shuffleAllSongCount => 'Az összes szám véletlenszerű lejátszása';

  @override
  String get shuffleAllSongCountSubtitle =>
      'A betöltendő zeneszámok száma az \"Összes dal keverése\" gombbal.';

  @override
  String get viewType => 'Nézet típusa';

  @override
  String get viewTypeSubtitle => 'Nézettípus a zenei képernyőhöz';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Rács';

  @override
  String get portrait => 'Álló';

  @override
  String get landscape => 'Fekvő';

  @override
  String gridCrossAxisCount(String value) {
    return '$value rács kereszttengelyek száma';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'A soronként használandó rácscsempék száma $value esetén.';
  }

  @override
  String get showTextOnGridView => 'Szöveg megjelenítése rácsnézetben';

  @override
  String get showTextOnGridViewSubtitle =>
      'Megjelenik-e a szöveg (cím, előadó stb.) a rácszene képernyőn.';

  @override
  String get showCoverAsPlayerBackground =>
      'Elmosódott borító megjelenítése lejátszási háttérként';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Használja-e az elmosódott borítót háttérként a lejátszó képernyőjén.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'A dal előadóinak elrejtése, ha megegyezik az album előadóival';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Megjeleníti-e a dal előadóit az album képernyőjén, ha nem különbözik az album előadóitól.';

  @override
  String get disableGesture => 'Gesztusok letiltása';

  @override
  String get disableGestureSubtitle => 'A gesztusok letiltása.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Téma';

  @override
  String get system => 'Rendszer';

  @override
  String get light => 'Világos';

  @override
  String get dark => 'Sötét';

  @override
  String get tabs => 'Tabok';

  @override
  String get cancelSleepTimer => 'Törlöd az elalvásidőzítőt?';

  @override
  String get yesButtonLabel => 'IGEN';

  @override
  String get noButtonLabel => 'NEM';

  @override
  String get setSleepTimer => 'Elalvásidőzítő beállítása';

  @override
  String get minutes => 'Percek';

  @override
  String get invalidNumber => 'Érvénytelen szám';

  @override
  String get sleepTimerTooltip => 'Elalvás időzítő';

  @override
  String get addToPlaylistTooltip => 'Hozzáadás a lejátszási listához';

  @override
  String get addToPlaylistTitle => 'Hozzáadás a Lejátszási Listához';

  @override
  String get removeFromPlaylistTooltip => 'Remove from playlist';

  @override
  String get removeFromPlaylistTitle => 'Remove from Playlist';

  @override
  String get newPlaylist => 'Új lejátszási lista';

  @override
  String get createButtonLabel => 'LÉTREHOZÁS';

  @override
  String get playlistCreated => 'Lejátszási lista létrehozva.';

  @override
  String get noAlbum => 'Album nélkül';

  @override
  String get noItem => 'Nincs tárgy';

  @override
  String get noArtist => 'Nincs előadó';

  @override
  String get unknownArtist => 'Ismeretlen Előadó';

  @override
  String get streaming => 'STREAMELÉS';

  @override
  String get downloaded => 'LETÖLTVE';

  @override
  String get transcode => 'TRANSZKÓD';

  @override
  String get direct => 'DIREKT';

  @override
  String get statusError => 'ÁLLAPOT HIBA';

  @override
  String get queue => 'Sor';

  @override
  String get addToQueue => 'Hozzáadás a sorhoz';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Sor kicserélése';

  @override
  String get instantMix => 'Instant Keverés';

  @override
  String get goToAlbum => 'Ugrás az albumra';

  @override
  String get removeFavourite => 'Kedvenc eltávolítása';

  @override
  String get addFavourite => 'Hozzáadás a kedvencekhez';

  @override
  String get addedToQueue => 'Hozzáadva a sorhoz.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Sor cserélve.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Instant mix indítása.';

  @override
  String get anErrorHasOccured => 'Hiba történt.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Állapotkód $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Állapotkód: $statusCode. Ez valószínűleg azt jelenti, hogy rossz felhasználónevet/jelszót használt, vagy a kliens már nincs hitelesítve.';
  }

  @override
  String get removeFromMix => 'Kivétel a Mixből';

  @override
  String get addToMix => 'Hozzáadás a Mix-hez';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elemek újra letöltve',
      one: ' $count elem újra letöltve',
      zero: 'Nincs szükség újratöltésre..',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Puffer időtartama';

  @override
  String get bufferDurationSubtitle =>
      'Mennyit kell pufferelnie a lejátszónak másodpercben. Újraindítást igényel.';

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
