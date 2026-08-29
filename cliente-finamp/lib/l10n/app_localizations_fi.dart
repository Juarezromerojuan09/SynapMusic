// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String startupError(String error) {
    return 'Jokin meni pieleen sovelluksen käynnistyksen aikana. Virhe oli: $error\n\nOle hyvä ja luo virheilmoitus osoitteessa github.com/UnicornsOnLSD/finamp, jossa on kuvakaappaus tästä sivusta. Jos ongelma jatkuu, voit tyhjentää sovelluksen tiedot nollataksesi sovelluksen.';
  }

  @override
  String get serverUrl => 'Palvelimen URL';

  @override
  String get internalExternalIpExplanation =>
      'Jos haluat käyttää Jellyfin-palvelintasi etänä, sinun on käytettävä ulkoista IP-osoitettasi.\n\nJos palvelimesi käyttää HTTP-porttia (80/443), sinun ei tarvitse määrittää porttia. Näin on todennäköisesti, jos palvelimesi on reverse proxyn takana.';

  @override
  String get emptyServerUrl => 'Palvelimen URL ei voi olla tyhjä';

  @override
  String get urlStartWithHttps => 'URL pitää alkaa http:// tai https://';

  @override
  String get urlTrailingSlash => 'URL ei saa päättyä vinoviivaan';

  @override
  String get username => 'Käyttäjätunnus';

  @override
  String get password => 'Salasana';

  @override
  String get logs => 'Lokit';

  @override
  String get next => 'Seuraava';

  @override
  String get selectMusicLibraries => 'Valitse musiikkikirjastot';

  @override
  String get couldNotFindLibraries => 'Yhtään kirjastoa ei löytynyt.';

  @override
  String get unknownName => 'Tuntematon Nimi';

  @override
  String get songs => 'Kappaleet';

  @override
  String get albums => 'Albumit';

  @override
  String get artists => 'Artistit';

  @override
  String get genres => 'Tyylilajit';

  @override
  String get playlists => 'Soittolistat';

  @override
  String get startMix => 'Aloita sekoitus';

  @override
  String get startMixNoSongsArtist =>
      'Paina pitkään artistia lisätäksesi tai poistaaksesi sen miksaukseen ennen miksauksen aloittamista';

  @override
  String get startMixNoSongsAlbum =>
      'Paina albumia pitkään lisätäksesi tai poistaaksesi sen miksaukseen ennen miksauksen aloittamista';

  @override
  String get music => 'Musiikki';

  @override
  String get clear => 'Tyhjennä';

  @override
  String get favourites => 'Suosikit';

  @override
  String get shuffleAll => 'Sekoita kaikki';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Lataukset';

  @override
  String get settings => 'Asetukset';

  @override
  String get offlineMode => 'Offline tila';

  @override
  String get sortOrder => 'Lajittelujärjestys';

  @override
  String get sortBy => 'Järjestä';

  @override
  String get album => 'Albumi';

  @override
  String get albumArtist => 'Albumin artisti';

  @override
  String get artist => 'Artisti';

  @override
  String get budget => 'Budjetti';

  @override
  String get communityRating => 'Yhteisön arvostelu';

  @override
  String get criticRating => 'Kriitikoiden arvostelu';

  @override
  String get dateAdded => 'Lisäämisen päivämäärä';

  @override
  String get datePlayed => 'Toiston päivämäärä';

  @override
  String get playCount => 'Toistolaskuri';

  @override
  String get premiereDate => 'Ensiesityspäivä';

  @override
  String get productionYear => 'Tuotantovuosi';

  @override
  String get name => 'Nimi';

  @override
  String get random => 'Satunnainen';

  @override
  String get revenue => 'Tulot';

  @override
  String get runtime => 'Kesto';

  @override
  String get syncDownloadedPlaylists => 'Synkronoi ladatut soittolistat';

  @override
  String get downloadMissingImages => 'Lataa puuttuvat kuvat';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ladattu $count puuttuvia kuvia',
      one: 'Ladattu $count puuttuvaa kuvaa',
      zero: 'Puuttuvia kuvia ei löytynyt',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Latauksen virheet';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lataukset',
      one: '$count lataus',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteet',
      one: '$count kohde',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kuvat',
      one: '$count kuva',
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
    return '$count valmistunut';
  }

  @override
  String dlFailed(int count) {
    return '$count epäonnistui';
  }

  @override
  String dlEnqueued(int count) {
    return '$count Jonossa';
  }

  @override
  String dlRunning(int count) {
    return '$count käynnissä';
  }

  @override
  String get downloadErrorsTitle => 'Latauksen virheet';

  @override
  String get noErrors => 'Ei virheitä!';

  @override
  String get errorScreenError =>
      'Virhe tapahtui virheiden luettelon hakemisessa! Tässä vaiheessa sinun pitäisi luultavasti vain luoda virheilmoitus GitHubiin ja poistaa sovelluksen tiedot';

  @override
  String get failedToGetSongFromDownloadId =>
      'Kappaleen nouto lataus ID:stä epäonnistui';

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
    return 'Oletko varma, että haluat poistaa $_temp0 \'$itemName\' tästä laitteesta?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Poista';

  @override
  String get deleteDownloadsAbortButtonText => 'Peruuta';

  @override
  String get error => 'Virhe';

  @override
  String discNumber(int number) {
    return 'Levy $number';
  }

  @override
  String get playButtonLabel => 'TOISTA';

  @override
  String get shuffleButtonLabel => 'SEKOITA';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kappaleita',
      one: '$count Kappale',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Muokkaa soittolistan nimeä';

  @override
  String get editPlaylistNameTitle => 'Muokkaa soittolistan nimeä';

  @override
  String get required => 'Pakollinen';

  @override
  String get updateButtonLabel => 'PÄIVITÄ';

  @override
  String get playlistNameUpdated => 'Soittolistan nimi päivitetty.';

  @override
  String get favourite => 'Suosikki';

  @override
  String get downloadsDeleted => 'Lataukset poistettu.';

  @override
  String get addDownloads => 'Lisää lataukset';

  @override
  String get location => 'Sijainti';

  @override
  String get downloadsAdded => 'Lataukset lisätty.';

  @override
  String get addButtonLabel => 'LISÄÄ';

  @override
  String get shareLogs => 'Jaa lokit';

  @override
  String get logsCopied => 'Lokit kopioitu.';

  @override
  String get message => 'Viesti';

  @override
  String get stackTrace => 'Pinon jäljitys';

  @override
  String get applicationLegalese =>
      'Lisensoitu Mozilla Public License 2.0 -lisenssillä. Lähdekoodi saatavilla osoitteessa:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkoodaus';

  @override
  String get downloadLocations => 'Latauksen sijainnit';

  @override
  String get audioService => 'Äänipalvelu';

  @override
  String get interactions => 'Vuorovaikutukset';

  @override
  String get layoutAndTheme => 'Asettelu ja Teema';

  @override
  String get notAvailableInOfflineMode => 'Ei saatavilla offline tilassa';

  @override
  String get logOut => 'Kirjaudu ulos';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Ladattuja kappaleita ei poisteta';

  @override
  String get areYouSure => 'Oletko varma?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin käyttää AAC:tä transkoodaukseen';

  @override
  String get enableTranscoding => 'Ota transkoodaus käyttöön';

  @override
  String get enableTranscodingSubtitle =>
      'Transkoodaa musiikin suoratoiston palvelimen päässä.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Suurempi bitrate antaa laadukkaamman äänen, mutta sen käyttämä kaistanleveys on suurempi.';

  @override
  String get customLocation => 'Mukautettu sijainti';

  @override
  String get appDirectory => 'Sovelluksen hakemisto';

  @override
  String get addDownloadLocation => 'Lisää latauksen hakemisto';

  @override
  String get selectDirectory => 'Valitse hakemisto';

  @override
  String get unknownError => 'Tuntematon virhe';

  @override
  String get pathReturnSlashErrorMessage =>
      'Polkuja jotka palauttavat \"/\" ei voi käyttää';

  @override
  String get directoryMustBeEmpty => 'Hakemiston pitää olla tyhjä';

  @override
  String get customLocationsBuggy =>
      'Mukautetut sijainnit ovat erittäin bugisia käyttöoikeusongelmien vuoksi. Mietin tapoja korjata tämä, mutta toistaiseksi en suosittele niiden käyttöä.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Siirtyminen matalan prioriteetin tilaan tauon aikana';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Sallii ilmoituksen pyyhkäisemisen pois, kun toisto on pysäytetty. Antaa myös Androidin lopettaa palvelun, kun toisto on keskeytetty.';

  @override
  String get shuffleAllSongCount => 'Kaikkien sekoitettujen kappaleiden määrä';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Ladattavien kappaleiden määrä, kun käytät sekoita kaikki kappaleet painiketta.';

  @override
  String get viewType => 'Näkymän Tyyppi';

  @override
  String get viewTypeSubtitle => 'Musiikkinäytön näkymätyyppi';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Ruudukko';

  @override
  String get portrait => 'Pysty';

  @override
  String get landscape => 'Vaaka';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Ruudukon poikittaisakselien lukumäärä';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Rivikohtaisesti käytettävien ruudukkotiilien määrä, kun $value.';
  }

  @override
  String get showTextOnGridView => 'Näytä teksti ruudukkonäkymässä';

  @override
  String get showTextOnGridViewSubtitle =>
      'Näytetäänkö teksti (nimi, artisti jne.) ruudukon musiikkinäytöllä vai ei.';

  @override
  String get showCoverAsPlayerBackground =>
      'Näytä sumennettu kansikuva soittimen taustakuvana';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Käytetäänkö sumeaa kansikuvitusta taustana soittimen näytöllä vai ei.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Piilota kappaleen artistit, jos samat kuin albumin artistit';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Näytetäänkö kappaleiden artistit albumin näytöllä, jos ne eivät poikkea albumin artisteista.';

  @override
  String get disableGesture => 'Poista eleet käytöstä';

  @override
  String get disableGestureSubtitle => 'Poistaa eleet käytöstä.';

  @override
  String get showFastScroller => 'Näytä nopea vieritin';

  @override
  String get theme => 'Teema';

  @override
  String get system => 'Järjestelmä';

  @override
  String get light => 'Vaalea';

  @override
  String get dark => 'Tumma';

  @override
  String get tabs => 'Välilehdet';

  @override
  String get cancelSleepTimer => 'Peruuta uniajastin?';

  @override
  String get yesButtonLabel => 'KYLLÄ';

  @override
  String get noButtonLabel => 'EI';

  @override
  String get setSleepTimer => 'Aseta uniajastin';

  @override
  String get minutes => 'Minuutit';

  @override
  String get invalidNumber => 'Virheellinen numero';

  @override
  String get sleepTimerTooltip => 'Uniajastin';

  @override
  String get addToPlaylistTooltip => 'Lisää soittolistalle';

  @override
  String get addToPlaylistTitle => 'Lisää soittolistalle';

  @override
  String get removeFromPlaylistTooltip => 'Poista soittolistalta';

  @override
  String get removeFromPlaylistTitle => 'Poista soittolistalta';

  @override
  String get newPlaylist => 'Uusi soittolista';

  @override
  String get createButtonLabel => 'LUO';

  @override
  String get playlistCreated => 'Soittolista on luotu.';

  @override
  String get noAlbum => 'Ei albumia';

  @override
  String get noItem => 'Ei kohdetta';

  @override
  String get noArtist => 'Ei Artistia';

  @override
  String get unknownArtist => 'Tuntematon artisti';

  @override
  String get streaming => 'SUORATOISTAA';

  @override
  String get downloaded => 'LADATTU';

  @override
  String get transcode => 'TRANSKOODI';

  @override
  String get direct => 'SUORA';

  @override
  String get statusError => 'TILAVIRHE';

  @override
  String get queue => 'Jono';

  @override
  String get addToQueue => 'Lisää jonoon';

  @override
  String get playNext => 'Toista seuraava';

  @override
  String get replaceQueue => 'Korvaa Jono';

  @override
  String get instantMix => 'Välitön Sekoitus';

  @override
  String get goToAlbum => 'Mene albumiin';

  @override
  String get removeFavourite => 'Poista suosikki';

  @override
  String get addFavourite => 'Lisää suosikki';

  @override
  String get addedToQueue => 'Lisätty jonoon.';

  @override
  String get insertedIntoQueue => 'Asetettu jonoon.';

  @override
  String get queueReplaced => 'Jono korvattu.';

  @override
  String get removedFromPlaylist => 'Poistettu soittolistalta.';

  @override
  String get startingInstantMix => 'Käynnistetään välitön sekoitus.';

  @override
  String get anErrorHasOccured => 'Tapahtui virhe.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Tilakoodi $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Tilakoodi $statusCode. Tämä tarkoittaa todennäköisesti, että olet käyttänyt väärää käyttäjätunnusta/salasanaa tai että sovellus ei ole enää kirjautuneena sisään.';
  }

  @override
  String get removeFromMix => 'Poista Sekoituksesta';

  @override
  String get addToMix => 'Lisää Sekoitukseen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uudelleenladatut $count kohteet',
      one: 'Uudelleenladattu $count kohde',
      zero: 'Ei tarvitse ladata uudelleen.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Puskurin kesto';

  @override
  String get bufferDurationSubtitle =>
      'Kuinka paljon soittimen pitäisi puskuroida, sekunteina. Vaatii uudelleenkäynnistyksen.';

  @override
  String get language => 'Kieli';

  @override
  String get confirm => 'Vahvista';

  @override
  String get showUncensoredLogMessage =>
      'Tämä loki sisältää kirjautumistietosi. Näytä?';

  @override
  String get resetTabs => 'Nollaa välilehdet';

  @override
  String get noMusicLibrariesTitle => 'Ei musiikkikirjastoja';

  @override
  String get noMusicLibrariesBody =>
      'Finamp ei löytänyt musiikkikirjastoja. Varmista, että Jellyfin-palvelimellasi on vähintään yksi kirjasto, jonka sisältötyypiksi on asetettu \"Musiikki\".';

  @override
  String get refresh => 'VIRKISTÄ';

  @override
  String get swipeInsertQueueNext => 'Toista Pyyhkäisty Kappale Seuraavaksi';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Mahdollistaa kappaleen lisäämisen jonon seuraavaksi kohteeksi, kun sitä pyyhkäistään kappaleiden luettelossa sen sijaan, että se liitettäisiin loppuun.';

  @override
  String get redesignBeta => 'Kokeile Betaa';

  @override
  String get playbackOrderShuffledTooltip =>
      'Sekoittaminen. Vaihda napauttamalla.';

  @override
  String get playbackOrderLinearTooltip =>
      'Toistaminen järjestyksessä. Vaihda napauttamalla.';

  @override
  String get loopModeAllTooltip => 'Toista kaikki. Vaihda napauttamalla.';

  @override
  String get loopModeOneTooltip => 'Toista yksi. Vaihda napauttamalla.';

  @override
  String get loopModeNoneTooltip => 'Älä toista. Vaihda napauttamalla.';

  @override
  String get skipToPrevious => 'Siirry edelliseen kappaleeseen';

  @override
  String get skipToNext => 'Siirry seuraavaan kappaleeseen';

  @override
  String get togglePlayback => 'Toiston vaihtaminen';

  @override
  String playArtist(String artist) {
    return 'Toista kaikki $artist:n albumit';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Sekoita kaikki $artist:n albumit';
  }

  @override
  String downloadArtist(String artist) {
    return 'Lataa kaikki $artist:n albumit';
  }

  @override
  String get deleteFromDevice => 'Poista laitteelta';

  @override
  String get download => 'Lataa';

  @override
  String get sync => 'Synkronoi palvelimen kanssa';

  @override
  String get about => 'Tietoja Finampista';
}
