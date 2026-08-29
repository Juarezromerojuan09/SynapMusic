// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String startupError(String error) {
    return 'Dogodila se greška prilikom pokretanja aplikacije. Greška: $error\n\nPrijavi problem na github.com/UnicornsOnLSD/finamp sa snimkom ekrana ove stranice. Ako ovaj problem ustraje, izbriši svoje podatke aplikacije i resetiraj aplikaciju.';
  }

  @override
  String get serverUrl => 'URL servera';

  @override
  String get internalExternalIpExplanation =>
      'Ako želiš pristupiti Jellyfin serveru na daljinski način moraš korisititi tvoju externu IP adresu.\n\nAko je tvoj server na HTTP priključku (80/443), ne moraš navesti priključak. To će vjerojatno slučaj ako se tvoj server nalazi iza obrnutog proxija.';

  @override
  String get emptyServerUrl => 'URL servera ne smije biti prazan';

  @override
  String get urlStartWithHttps => 'URL mora početi s http:// ili https://';

  @override
  String get urlTrailingSlash => 'URL ne smije sadržavati kosu crtu na kraju';

  @override
  String get username => 'Korisničko ime';

  @override
  String get password => 'Lozinka';

  @override
  String get logs => 'Zapisi';

  @override
  String get next => 'Dalje';

  @override
  String get selectMusicLibraries => 'Odaberi fonoteke';

  @override
  String get couldNotFindLibraries =>
      'Nije bilo moguće pronaći niti jednu fonoteku.';

  @override
  String get unknownName => 'Nepoznato ime';

  @override
  String get songs => 'Pjesme';

  @override
  String get albums => 'Albumi';

  @override
  String get artists => 'Izvođači';

  @override
  String get genres => 'Žanrovi';

  @override
  String get playlists => 'Playliste';

  @override
  String get startMix => 'Pokreni miks';

  @override
  String get startMixNoSongsArtist =>
      'Pritisni dugo na izvođača za dodavanje ili uklanjanje izvođača iz miksera prije pokretanja miksa';

  @override
  String get startMixNoSongsAlbum =>
      'Pritisni dugo na album za dodavanje ili uklanjanje albuma iz miksera prije pokretanja miksa';

  @override
  String get music => 'Glazba';

  @override
  String get clear => 'Izbriši';

  @override
  String get favourites => 'Omiljeno';

  @override
  String get shuffleAll => 'Izmiješaj sve';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Preuzimanja';

  @override
  String get settings => 'Postavke';

  @override
  String get offlineMode => 'Neumrežen modus';

  @override
  String get sortOrder => 'Redoslijed razvrstavanja';

  @override
  String get sortBy => 'Razvrstaj po';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Izvođač albuma';

  @override
  String get artist => 'Izvođač';

  @override
  String get budget => 'Budžet';

  @override
  String get communityRating => 'Ocjena zajednice';

  @override
  String get criticRating => 'Ocjena kritičara';

  @override
  String get dateAdded => 'Datum dodavanja';

  @override
  String get datePlayed => 'Datum reprodukcije';

  @override
  String get playCount => 'Broj reprodukcija';

  @override
  String get premiereDate => 'Datum premijere';

  @override
  String get productionYear => 'Godina produkcije';

  @override
  String get name => 'Ime';

  @override
  String get random => 'Slučajno';

  @override
  String get revenue => 'Prihod';

  @override
  String get runtime => 'Vrijeme trajanja';

  @override
  String get syncDownloadedPlaylists => 'Sinkroniziraj preuzete playliste';

  @override
  String get downloadMissingImages => 'Preuzmi nedostajuće slike';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preuzeto je $count nedostajućih slika',
      few: 'Preuzete su $count nedostajuće slike',
      one: 'Preuzeta je $count nedostajuća slika',
      zero: 'Nema nedostajućih slika',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Greške preuzimanja';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preuzimanja',
      few: '$count preuzimanja',
      one: '$count preuzimanje',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stavki',
      few: '$count stavke',
      one: '$count stavka',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slika',
      few: '$count slike',
      one: '$count slika',
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
    return '$count dovršeno';
  }

  @override
  String dlFailed(int count) {
    return '$count neuspjelo';
  }

  @override
  String dlEnqueued(int count) {
    return '$count dodano u red';
  }

  @override
  String dlRunning(int count) {
    return '$count u tijeku';
  }

  @override
  String get downloadErrorsTitle => 'Greške preuzimanja';

  @override
  String get noErrors => 'Nema grešaka!';

  @override
  String get errorScreenError =>
      'Dogodila se greška prilikom dohvaćanja popisa grešaka! Prijavi problem na GitHubu i izbriši podatke aplikacije';

  @override
  String get failedToGetSongFromDownloadId =>
      'Neuspjelo dohvaćanje pjesme s ID-a preuzimanja';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlistu',
        'artist': 'izvođača',
        'genre': 'žanr',
        'track': 'pjesmu',
        'other': '',
      },
    );
    return 'Stvarno želiš izbrisati $_temp0 \'$itemName\' s ovog uređaja?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Izbriši';

  @override
  String get deleteDownloadsAbortButtonText => 'Odustani';

  @override
  String get error => 'Greška';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'POKRENI';

  @override
  String get shuffleButtonLabel => 'IZMIJEŠAJ';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pjesama',
      few: '$count pjesme',
      one: '$count pjesma',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Uredi ime playliste';

  @override
  String get editPlaylistNameTitle => 'Uredi ime playliste';

  @override
  String get required => 'Obavezno';

  @override
  String get updateButtonLabel => 'AŽURIRAJ';

  @override
  String get playlistNameUpdated => 'Ime playliste je ažurirano.';

  @override
  String get favourite => 'Omiljeno';

  @override
  String get downloadsDeleted => 'Preuzimanja izbrisana.';

  @override
  String get addDownloads => 'Dodaj preuzimanja';

  @override
  String get location => 'Lokacija';

  @override
  String get downloadsAdded => 'Preuzimanja dodana.';

  @override
  String get addButtonLabel => 'DODAJ';

  @override
  String get shareLogs => 'Dijeli zapise';

  @override
  String get logsCopied => 'Zapisi su kopirani.';

  @override
  String get message => 'Poruka';

  @override
  String get stackTrace => 'Trag Stacka';

  @override
  String get applicationLegalese =>
      'Licenca: Mozilla Public License 2.0. Izvorni kod je dostupan na:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkodiranje';

  @override
  String get downloadLocations => 'Lokacija preuzimanja';

  @override
  String get audioService => 'Usluga audioreprodukcije';

  @override
  String get interactions => 'Interakcije';

  @override
  String get layoutAndTheme => 'Izgled i tema';

  @override
  String get notAvailableInOfflineMode => 'Nije dostupno u neumreženom modusu';

  @override
  String get logOut => 'Odjavi se';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Preuzete pjesme neće biti izbrisane';

  @override
  String get areYouSure => 'Jeste li sigurni?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin koristi AAC za transkodiranje';

  @override
  String get enableTranscoding => 'Omogući transkodiranje';

  @override
  String get enableTranscodingSubtitle =>
      'Transkodira stream glazbe na server strani.';

  @override
  String get bitrate => 'Brzina prijenosa';

  @override
  String get bitrateSubtitle =>
      'Veća brzina prijenosa daje veću kvalitetu zvuka, ali troši veću količinu prometa.';

  @override
  String get customLocation => 'Prilagođena lokacija';

  @override
  String get appDirectory => 'Direktorij aplikacije';

  @override
  String get addDownloadLocation => 'Dodaj lokaciju preuzimanja';

  @override
  String get selectDirectory => 'Odaberi direktorij';

  @override
  String get unknownError => 'Nepoznata greška';

  @override
  String get pathReturnSlashErrorMessage =>
      'Staze sa znakom „/” se ne mogu koristiti';

  @override
  String get directoryMustBeEmpty => 'Direktorij mora biti prazan';

  @override
  String get customLocationsBuggy =>
      'Prilagođene lokacije su izrazito pune grešaka zbog problema oko dozvola. Razmišljam o načinima da ovo ispravim, ali za sada ne bih preporučio korištenje.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Unesite stanje niskog prioriteta za vrijeme pauze';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Omogućuje brisanje obavijesti kada je pauzirano. Također omogućuje Androidu da prekine uslugu kada je pauzirana.';

  @override
  String get shuffleAllSongCount => 'Broj pjesama za miješanje';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Broj pjesama koje se učitavaju kada se koristi gumb „Izmiješaj sve pjesme”.';

  @override
  String get viewType => 'Vrsta prikaza';

  @override
  String get viewTypeSubtitle => 'Vrsta prikaza za ekran glazbe';

  @override
  String get list => 'Popis';

  @override
  String get grid => 'Rešetka';

  @override
  String get portrait => 'Uspravno';

  @override
  String get landscape => 'Polegnuto';

  @override
  String gridCrossAxisCount(String value) {
    return '$value broj rešetkastih linija';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Količina rešetkastih polja po redu kada $value.';
  }

  @override
  String get showTextOnGridView => 'Prikaži tekst u rešetkastom prikazu';

  @override
  String get showTextOnGridViewSubtitle =>
      'Da li prikazati tekst (naslov, izvođač itd.) u rešetkastom ekranu glazbe.';

  @override
  String get showCoverAsPlayerBackground =>
      'Prikaži mutnu sliku omota kao pozadinu playera';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Da li koristiti mutnu sliku omota kao pozadinu na ekranu playera.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Sakrij izvođače pjesama ako su isti kao izvođači albuma';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Da li prikazati izvođače pjesama na ekranu albuma ako se ne razlikuju od izvođača albuma.';

  @override
  String get disableGesture => 'Deaktiviraj geste';

  @override
  String get disableGestureSubtitle => 'Da li deaktivirati geste.';

  @override
  String get showFastScroller => 'Prikaži traku za brzo listanje';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sustav';

  @override
  String get light => 'Svijetla';

  @override
  String get dark => 'Tamna';

  @override
  String get tabs => 'Kartice';

  @override
  String get cancelSleepTimer => 'Prekinuti odbrojavanje?';

  @override
  String get yesButtonLabel => 'DA';

  @override
  String get noButtonLabel => 'NE';

  @override
  String get setSleepTimer => 'Postavi odbrojavanje';

  @override
  String get minutes => 'Minute';

  @override
  String get invalidNumber => 'Neispravan broj';

  @override
  String get sleepTimerTooltip => 'Odbrojavanje';

  @override
  String get addToPlaylistTooltip => 'Dodaj u playlistu';

  @override
  String get addToPlaylistTitle => 'Dodaj u playlistu';

  @override
  String get removeFromPlaylistTooltip => 'Ukloni iz playliste';

  @override
  String get removeFromPlaylistTitle => 'Ukloni iz playliste';

  @override
  String get newPlaylist => 'Nova playlista';

  @override
  String get createButtonLabel => 'STVORI';

  @override
  String get playlistCreated => 'Playlista je stvorena.';

  @override
  String get noAlbum => 'Nema albuma';

  @override
  String get noItem => 'Nema stavki';

  @override
  String get noArtist => 'Nema izvođača';

  @override
  String get unknownArtist => 'Nepoznat izvođač';

  @override
  String get streaming => 'PRIJENOS';

  @override
  String get downloaded => 'PREUZETO';

  @override
  String get transcode => 'TRANSKODIRAJ';

  @override
  String get direct => 'DIREKTNO';

  @override
  String get statusError => 'GREŠKA STANJA';

  @override
  String get queue => 'Red čekanja';

  @override
  String get addToQueue => 'Dodaj u red čekanja';

  @override
  String get playNext => 'Reproduciraj kao sljedeću';

  @override
  String get replaceQueue => 'Zamijeni red čekanja';

  @override
  String get instantMix => 'Instant miks';

  @override
  String get goToAlbum => 'Idi na album';

  @override
  String get removeFavourite => 'Izbriši omiljene';

  @override
  String get addFavourite => 'Dodaj omiljene';

  @override
  String get addedToQueue => 'Dodano u red čekanja.';

  @override
  String get insertedIntoQueue => 'Umetnuto u red čekanja.';

  @override
  String get queueReplaced => 'Red čekanja je zamijenjen.';

  @override
  String get removedFromPlaylist => 'Uklonjeno iz playliste.';

  @override
  String get startingInstantMix => 'Pokretanje instant miksa.';

  @override
  String get anErrorHasOccured => 'Dogodila se greška.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Kȏd stanja $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Kȏd stanja $statusCode. Ovo vjerojatno znači da si koristio/la pokrešno korisničko ime/lozinku ili da tvoj klijent više nije prijavljen.';
  }

  @override
  String get removeFromMix => 'Ukloni iz miksa';

  @override
  String get addToMix => 'Dodaj u miks';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ponovo je preuzeto $count stavki',
      few: 'Ponovo su preuzete $count stavke',
      one: 'Ponovo je preuzeta $count stavka',
      zero: 'Ponovna preuzimanja nisu potrebna.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Trajanje međuspremnika';

  @override
  String get bufferDurationSubtitle =>
      'Količina koju player treba spremiti u međuspremnik, u sekundama. Zahtijeva ponovno pokretanje.';

  @override
  String get language => 'Jezik';

  @override
  String get confirm => 'Potvrdi';

  @override
  String get showUncensoredLogMessage =>
      'Ovaj zapis sadrži tvoje podatke za prijavu. Prikazati?';

  @override
  String get resetTabs => 'Resetiraj kartice';

  @override
  String get noMusicLibrariesTitle => 'Nema fonoteka';

  @override
  String get noMusicLibrariesBody =>
      'Finamp nije mogao pronaći nijednu fonoteku. Provjeri sadrži li tvoj Jellyfin poslužitelj barem jednu biblioteku s vrstom sadržaja postavljenom na „Glazba”.';

  @override
  String get refresh => 'AKTUALIZIRAJ';

  @override
  String get swipeInsertQueueNext =>
      'Reproduciraj pjesmu kao sljedeću povlačenjem';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Omogući umetanje pjesme kao sljedeću pjesmu u redu reprodukcije povlačenjem pjesme iz popisa pjesama umjesto dodavanja pjesme na kraj popisa.';

  @override
  String get redesignBeta => 'Probaj beta verziju';

  @override
  String get playbackOrderShuffledTooltip =>
      'Miješanje. Uključi/isključi dodirom.';

  @override
  String get playbackOrderLinearTooltip =>
      'Reprodukcija redom. Uključi/isključi dodirom.';

  @override
  String get loopModeAllTooltip =>
      'Ponavljanje svih. Uključi/isključi dodirom.';

  @override
  String get loopModeOneTooltip =>
      'Ponavljanje jedne. Uključi/isključi dodirom.';

  @override
  String get loopModeNoneTooltip =>
      'Bez ponavljanja. Uključi/isključi dodirom.';

  @override
  String get skipToPrevious => 'Prijeđi na prethodnu pjesmu';

  @override
  String get skipToNext => 'Prijeđi na sljedeću pjesmu';

  @override
  String get togglePlayback => 'Uključi/isključi reprodukciju';

  @override
  String playArtist(String artist) {
    return 'Reproduciraj sve albume od $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Izmiješaj sve albume od $artist';
  }

  @override
  String downloadArtist(String artist) {
    return 'Preuzmi sve albume od $artist';
  }

  @override
  String get deleteFromDevice => 'Izbriši s uređaja';

  @override
  String get download => 'Preuzmi';

  @override
  String get sync => 'Sinkroniziraj sa serverom';

  @override
  String get about => 'O aplikaciji Finamp';
}
