// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String startupError(String error) {
    return 'Rakenduse käivitamisel läks midagi valesti. Viga oli: $error\n\nPalun loo probleem github.com/UnicornsOnLSD/finamp koos ekraanipildiga sellest leheküljest. Kui see probleem püsib, võiks rakenduse lähtestamiseks kustutada rakenduse andmed.';
  }

  @override
  String get serverUrl => 'Serveri URL';

  @override
  String get internalExternalIpExplanation =>
      'Kui soovid oma Jellyfini serverile kaugjuurdepääsu saada, pead kasutama oma välist IP-d.\n\nKui server kasutab HTTP-porti (80/443), ei pea porti määrama. See on tõenäoliselt nii, kui server on pöördpuhverserveri taga.';

  @override
  String get emptyServerUrl => 'Serveri URL ei tohi olla tühi';

  @override
  String get urlStartWithHttps => 'URL alguses peab olema http:// või https://';

  @override
  String get urlTrailingSlash => 'URL ei tohi lõppeda kaldkriipsuga';

  @override
  String get username => 'Kasutajanimi';

  @override
  String get password => 'Parool';

  @override
  String get logs => 'Logid';

  @override
  String get next => 'Järgmine';

  @override
  String get selectMusicLibraries => 'Vali muusikakogu';

  @override
  String get couldNotFindLibraries => 'Ühtki muusikakogu ei leitud.';

  @override
  String get unknownName => 'Tundmatu nimi';

  @override
  String get songs => 'Lood';

  @override
  String get albums => 'Albumid';

  @override
  String get artists => 'Esitajad';

  @override
  String get genres => 'Žanrid';

  @override
  String get playlists => 'Esitusloendid';

  @override
  String get startMix => 'Käivita miks';

  @override
  String get startMixNoSongsArtist =>
      'Vajuta pikalt esitajale, et lisada või eemaldada ta enne miksi koostamise alustamist koostajast';

  @override
  String get startMixNoSongsAlbum =>
      'Vajuta pikalt albumile, et lisada või eemaldada ta enne miksi koostamise alustamist koostajast';

  @override
  String get music => 'Muusika';

  @override
  String get clear => 'Puhasta';

  @override
  String get favourites => 'Lemmikud';

  @override
  String get shuffleAll => 'Sega kõik';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Allalaadimised';

  @override
  String get settings => 'Seaded';

  @override
  String get offlineMode => 'Võrguühenduseta režiim';

  @override
  String get sortOrder => 'Sortimisjärjestus';

  @override
  String get sortBy => 'Sordi';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumi esitaja';

  @override
  String get artist => 'Esitaja';

  @override
  String get budget => 'Eelarve';

  @override
  String get communityRating => 'Kogukonna hinnang';

  @override
  String get criticRating => 'Kriitikute hinnang';

  @override
  String get dateAdded => 'Lisamise kuupäev';

  @override
  String get datePlayed => 'Esituse kuupäev';

  @override
  String get playCount => 'Esituste arv';

  @override
  String get premiereDate => 'Avaldamise kuupäev';

  @override
  String get productionYear => 'Tootmisaasta';

  @override
  String get name => 'Nimi';

  @override
  String get random => 'Juhuslik';

  @override
  String get revenue => 'Tulud';

  @override
  String get runtime => 'Kestus';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Laadi alla puuduvad pildid';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Allalaetud $count puuduvat pilti',
      one: 'Allalaetud $count puuduv pilt',
      zero: 'Puuduvaid pilte ei leitud',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Allalaadimisvead';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count allalaadimist',
      one: '$count allalaadimine',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count üksust',
      one: '$count üksus',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pilti',
      one: '$count pilt',
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
    return '$count tehtud';
  }

  @override
  String dlFailed(int count) {
    return '$count nurjus';
  }

  @override
  String dlEnqueued(int count) {
    return '$count järjekorras';
  }

  @override
  String dlRunning(int count) {
    return '$count käsil';
  }

  @override
  String get downloadErrorsTitle => 'Allalaadimisvead';

  @override
  String get noErrors => 'Pole vigu!';

  @override
  String get errorScreenError =>
      'Vigade loendi saamisel tekkis viga! Siinkohal peaksid ilmselt lihtsalt looma probleemi GitHubis ja kustutama rakenduse andmed';

  @override
  String get failedToGetSongFromDownloadId =>
      'Allalaadimise ID-st laulu hankimine nurjus';

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
  String get error => 'Viga';

  @override
  String discNumber(int number) {
    return 'Plaat $number';
  }

  @override
  String get playButtonLabel => 'MÄNGI';

  @override
  String get shuffleButtonLabel => 'SEGA';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugu',
      one: '$count lugu',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Muuda esitusloendi nime';

  @override
  String get editPlaylistNameTitle => 'Muuda esitusloendi nime';

  @override
  String get required => 'Nõutav';

  @override
  String get updateButtonLabel => 'UUENDA';

  @override
  String get playlistNameUpdated => 'Esitusloendi nimi uuendatud.';

  @override
  String get favourite => 'Lemmik';

  @override
  String get downloadsDeleted => 'Allalaadimised kustutati.';

  @override
  String get addDownloads => 'Lisa allalaadimised';

  @override
  String get location => 'Asukoht';

  @override
  String get downloadsAdded => 'Allalaadimised lisatud.';

  @override
  String get addButtonLabel => 'LISA';

  @override
  String get shareLogs => 'Jaga logisid';

  @override
  String get logsCopied => 'Logid kopeeriti.';

  @override
  String get message => 'Sõnum';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String get applicationLegalese =>
      'Litsentsitud Mozilla avaliku litsentsiga 2.0. Lähtekood on saadaval aadressil:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkoodimine';

  @override
  String get downloadLocations => 'Allalaadimiste asukohad';

  @override
  String get audioService => 'Heliteenus';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Paigutus ja teema';

  @override
  String get notAvailableInOfflineMode =>
      'Pole võrguühenduseta režiimis saadaval';

  @override
  String get logOut => 'Logi välja';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Allalaaditud lugusid ei kustutata';

  @override
  String get areYouSure => 'Kas oled kindel?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin kasutab transkodeerimiseks AAC-d';

  @override
  String get enableTranscoding => 'Luba transkodeerimine';

  @override
  String get enableTranscodingSubtitle =>
      'Transkodeerib muusikavooge serveri poolel.';

  @override
  String get bitrate => 'Bitikiirus';

  @override
  String get bitrateSubtitle =>
      'Suurem bitikiirus annab kvaliteetsema heli, kuid see nõuab suuremat ribalaiust.';

  @override
  String get customLocation => 'Kohandatud asukoht';

  @override
  String get appDirectory => 'Rakenduse kataloog';

  @override
  String get addDownloadLocation => 'Lisa allalaadimise asukoht';

  @override
  String get selectDirectory => 'Vali kataloog';

  @override
  String get unknownError => 'Tundmatu viga';

  @override
  String get pathReturnSlashErrorMessage =>
      'Radu, mis tagastavad \"/\", ei saa kasutada';

  @override
  String get directoryMustBeEmpty => 'Kataloog peab olema tühi';

  @override
  String get customLocationsBuggy =>
      'Kohandatud asukohad on äärmiselt vigased, kuna on probleeme õigustega. Ma mõtlen, kuidas seda parandada, kuid praegu ma ei soovitaks neid kasutada.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Kasuta pausil madala prioriteediga olekut';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Laseb pausi ajal märguande ära pühkida. Võimaldab Androidil ka teenuse pausi ajal lõpetada.';

  @override
  String get shuffleAllSongCount => '\'Sega kõik lood\' arv';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Laaditavate lugude hulk, kui kasutada nuppu \'Sega kõik lood\'.';

  @override
  String get viewType => 'Vaate tüüp';

  @override
  String get viewTypeSubtitle => 'Muusikaekraani vaate tüüp';

  @override
  String get list => 'Loend';

  @override
  String get grid => 'Ruudustik';

  @override
  String get portrait => 'Portree';

  @override
  String get landscape => 'Lai pilt';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Ruudustiku risttelgede arv';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Ruudustiku plaatide arv, mida kasutatakse rea kohta, kui $value.';
  }

  @override
  String get showTextOnGridView => 'Kuva teksti ruudustikuvaates';

  @override
  String get showTextOnGridViewSubtitle =>
      'Kas kuvada teksti (pealkiri, esitaja jne) muusikaekraani ruudustikul või mitte.';

  @override
  String get showCoverAsPlayerBackground =>
      'Kuva hägustatud kaanepilt mängija taustana';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Kas kasutada mängija ekraanil taustaks hägustatud kaanekujundust või mitte.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Peida laulu esitajad, kui need on samad kui albumi esitajad';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Kas näidata lugude esitajaid albumiekraanil, kui need ei erine albumi esitajatest.';

  @override
  String get disableGesture => 'Keela žestid';

  @override
  String get disableGestureSubtitle => 'Kas keelata žestid.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Teema';

  @override
  String get system => 'Süsteem';

  @override
  String get light => 'Hele';

  @override
  String get dark => 'Tume';

  @override
  String get tabs => 'Vahekaardid';

  @override
  String get cancelSleepTimer => 'Kas tühistada unetaimer?';

  @override
  String get yesButtonLabel => 'JAH';

  @override
  String get noButtonLabel => 'EI';

  @override
  String get setSleepTimer => 'Määra unetaimer';

  @override
  String get minutes => 'minutit';

  @override
  String get invalidNumber => 'Sobimatu number';

  @override
  String get sleepTimerTooltip => 'Unetaimer';

  @override
  String get addToPlaylistTooltip => 'Lisa esitusloendisse';

  @override
  String get addToPlaylistTitle => 'Lisa esitusloendisse';

  @override
  String get removeFromPlaylistTooltip => 'Remove from playlist';

  @override
  String get removeFromPlaylistTitle => 'Remove from Playlist';

  @override
  String get newPlaylist => 'Uus esitusloend';

  @override
  String get createButtonLabel => 'LOO';

  @override
  String get playlistCreated => 'Esitusloend on loodud.';

  @override
  String get noAlbum => 'Albumit pole';

  @override
  String get noItem => 'Üksust pole';

  @override
  String get noArtist => 'Esitajat pole';

  @override
  String get unknownArtist => 'Tundmatu esitaja';

  @override
  String get streaming => 'VOOGESITUS';

  @override
  String get downloaded => 'ALLALAADITUD';

  @override
  String get transcode => 'TRANSKOODI';

  @override
  String get direct => 'OTSE';

  @override
  String get statusError => 'OLEKUVIGA';

  @override
  String get queue => 'Järjekord';

  @override
  String get addToQueue => 'Lisa järjekorda';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Asenda järjekord';

  @override
  String get instantMix => 'Kiirmiks';

  @override
  String get goToAlbum => 'Ava album';

  @override
  String get removeFavourite => 'Eemalda lemmik';

  @override
  String get addFavourite => 'Lisa lemmik';

  @override
  String get addedToQueue => 'Lisatud järjekorda.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Järjekord asendatud.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Kiirmiksi käivitamine.';

  @override
  String get anErrorHasOccured => 'Ilmnes tõrge.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Olekukood $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Olekukood $statusCode. Tõenäoliselt tähendab see, et kasutasid vale kasutajanime/parooli või klient pole enam autenditud.';
  }

  @override
  String get removeFromMix => 'Eemalda miksist';

  @override
  String get addToMix => 'Lisa miksi';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uuesti laeti alla $count üksust',
      one: 'Uuesti laeti alla $count üksus',
      zero: 'Allalaadimine pole vajalik.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Puhvri kestus';

  @override
  String get bufferDurationSubtitle =>
      'Kui palju mängija peaks puhverdama sekundites. Nõuab taaskäivitamist.';

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
