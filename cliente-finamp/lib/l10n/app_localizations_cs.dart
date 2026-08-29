// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String startupError(String error) {
    return 'Při spouštění aplikace se něco pokazilo. Chyba: $error\n\nNahlaste prosím problém na stránce github.com/UnicornsOnLSD/finamp společně se snímkem obrazovky této stránky. Pokud tento problém přetrvává, můžete vymazat data aplikace pro její obnovení.';
  }

  @override
  String get serverUrl => 'Adresa URL serveru';

  @override
  String get internalExternalIpExplanation =>
      'Pokud budete chtít vzdáleně přistupovat k vašemu serveru Jellyfin, budete muset použít vaši externí IP.\n\nPokud je váš server na portu HTTP (80/443), nemusíte specifikovat port. Toto bývá obvyklé, když máte server za reverzní proxy.';

  @override
  String get emptyServerUrl => 'Adresa URL serveru nemůže být prázdná';

  @override
  String get urlStartWithHttps =>
      'Adresa URL musí začínat s http:// nebo https://';

  @override
  String get urlTrailingSlash => 'Adresa URL nesmí obsahovat koncové lomítko';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get logs => 'Protokoly';

  @override
  String get next => 'Další';

  @override
  String get selectMusicLibraries => 'Vyberte hudební knihovny';

  @override
  String get couldNotFindLibraries => 'Nebyly nalezeny žádné knihovny.';

  @override
  String get unknownName => 'Neznámý název';

  @override
  String get songs => 'Skladby';

  @override
  String get albums => 'Alba';

  @override
  String get artists => 'Umělci';

  @override
  String get genres => 'Žánry';

  @override
  String get playlists => 'Seznamy skladeb';

  @override
  String get startMix => 'Spustit mix';

  @override
  String get startMixNoSongsArtist =>
      'Dlouze podržte prst na umělci pro jeho přidání nebo odebrání z tvorby mixu před jeho spuštěním';

  @override
  String get startMixNoSongsAlbum =>
      'Dlouze podržte prst na albu pro jeho přidání nebo odebrání z tvorby mixu před jeho spuštěním';

  @override
  String get music => 'Hudba';

  @override
  String get clear => 'Vymazat';

  @override
  String get favourites => 'Oblíbené';

  @override
  String get shuffleAll => 'Vše náhodně';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Stažené';

  @override
  String get settings => 'Nastavení';

  @override
  String get offlineMode => 'Režim offline';

  @override
  String get sortOrder => 'Pořadí řazení';

  @override
  String get sortBy => 'Řadit podle';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Umělec alba';

  @override
  String get artist => 'Umělec';

  @override
  String get budget => 'Rozpočet';

  @override
  String get communityRating => 'Komunitní hodnocení';

  @override
  String get criticRating => 'Hodnocení kritiků';

  @override
  String get dateAdded => 'Datum přidání';

  @override
  String get datePlayed => 'Datum přehrání';

  @override
  String get playCount => 'Počet přehrání';

  @override
  String get premiereDate => 'Datum premiéry';

  @override
  String get productionYear => 'Rok produkce';

  @override
  String get name => 'Název';

  @override
  String get random => 'Náhodně';

  @override
  String get revenue => 'Výnos';

  @override
  String get runtime => 'Doba běhu';

  @override
  String get syncDownloadedPlaylists =>
      'Synchronizovat stažené seznamy skladeb';

  @override
  String get downloadMissingImages => 'Stáhnout chybějící obrázky';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Staženo $count chybějících obrázků',
      few: 'Staženy $count chybějící obrázky',
      one: 'Stažen $count chybějící obrázek',
      zero: 'Nenalezeny žádné chybějící obrázky',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Chyby stahování';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stahování',
      one: '$count stahování',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count položek',
      few: '$count položky',
      one: '$count položka',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obrázků',
      few: '$count obrázky',
      one: '$count obrázek',
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
    return '$count dokončeno';
  }

  @override
  String dlFailed(int count) {
    return '$count selhalo';
  }

  @override
  String dlEnqueued(int count) {
    return '$count ve frontě';
  }

  @override
  String dlRunning(int count) {
    return '$count běží';
  }

  @override
  String get downloadErrorsTitle => 'Chyby stahování';

  @override
  String get noErrors => 'Žádné chyby!';

  @override
  String get errorScreenError =>
      'Při načítání seznamu chyb došlo k chybě! Vytvořte prosím problém na GitHubu a vymažte data aplikace';

  @override
  String get failedToGetSongFromDownloadId =>
      'Error nelze sehnat skladbu s ID pro stažení';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'seznam skladeb',
        'artist': 'umělce',
        'genre': 'žánr',
        'track': 'skladbu',
        'other': '',
      },
    );
    return 'Opravdu chcete odstranit $_temp0 \'$itemName\' z tohoto zařízení?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Odstranit';

  @override
  String get deleteDownloadsAbortButtonText => 'Zrušit';

  @override
  String get error => 'Chyba';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'PŘEHRÁT';

  @override
  String get shuffleButtonLabel => 'NÁHODNĚ';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '$count skladba',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Upravit název seznamu skladeb';

  @override
  String get editPlaylistNameTitle => 'Upravit název seznamu skladeb';

  @override
  String get required => 'Vyžadováno';

  @override
  String get updateButtonLabel => 'UPRAVIT';

  @override
  String get playlistNameUpdated => 'Název seznamu skladeb upraven.';

  @override
  String get favourite => 'Oblíbené';

  @override
  String get downloadsDeleted => 'Stahování odstraněna.';

  @override
  String get addDownloads => 'Přidat stahování';

  @override
  String get location => 'Umístění';

  @override
  String get downloadsAdded => 'Stahování přidána.';

  @override
  String get addButtonLabel => 'PŘIDAT';

  @override
  String get shareLogs => 'Sdílet protokoly';

  @override
  String get logsCopied => 'Protokoly zkopírovány.';

  @override
  String get message => 'Zpráva';

  @override
  String get stackTrace => 'Trasování';

  @override
  String get applicationLegalese =>
      'Licence Mozilla Public License 2.0. Zdrojový kód je dostupný na stránce:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Překódování';

  @override
  String get downloadLocations => 'Umístění stažených';

  @override
  String get audioService => 'Služba zvuku';

  @override
  String get interactions => 'Interakce';

  @override
  String get layoutAndTheme => 'Rozložení a motiv';

  @override
  String get notAvailableInOfflineMode => 'Není dostupné v režimu offline';

  @override
  String get logOut => 'Odhlásit se';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Stažené skladby nebudou odstraněny';

  @override
  String get areYouSure => 'Opravdu?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin používá pro překódování formát AAC';

  @override
  String get enableTranscoding => 'Zapnout překódování';

  @override
  String get enableTranscodingSubtitle =>
      'Překóduje hudební streamy na straně serveru.';

  @override
  String get bitrate => 'Datový tok';

  @override
  String get bitrateSubtitle =>
      'Vyšší datový tok poskytuje vyšší kvalitu zvuku, ale zvýší využití internetu.';

  @override
  String get customLocation => 'Vlastní umístění';

  @override
  String get appDirectory => 'Adresář aplikací';

  @override
  String get addDownloadLocation => 'Přidat umístění stažených';

  @override
  String get selectDirectory => 'Vybrat adresář';

  @override
  String get unknownError => 'Neznámá chyba';

  @override
  String get pathReturnSlashErrorMessage =>
      'Cesty, které vracejí „/“, nelze použít';

  @override
  String get directoryMustBeEmpty => 'Adresář musí být prázdný';

  @override
  String get customLocationsBuggy =>
      'Vlastní umístění bývají kvůli problémům s oprávněními extrémně chybové. Snažíme se tento problém opravit, do té doby ale nedoporučujeme jejich používání.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Po pozastavení vstoupit do stavu nízké priority';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Umožní odstranění notifikace při pozastavení. Také umožní systému ukončit službu.';

  @override
  String get shuffleAllSongCount =>
      'Počet skladeb pro náhodné přehrávání všeho';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Počet skladeb, které se mají načíst při použití tlačítka náhodného přehrávání všech skladeb.';

  @override
  String get viewType => 'Typ zobrazení';

  @override
  String get viewTypeSubtitle => 'Typ zobrazení pro hudební obrazovku';

  @override
  String get list => 'Seznam';

  @override
  String get grid => 'Mřížka';

  @override
  String get portrait => 'Na výšku';

  @override
  String get landscape => 'Na šířku';

  @override
  String gridCrossAxisCount(String value) {
    return 'Počet položek mřížky $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Počet položek mřížky na řádek $value.';
  }

  @override
  String get showTextOnGridView => 'Zobrazit text v zobrazení v mřížce';

  @override
  String get showTextOnGridViewSubtitle =>
      'Zda zobrazit text (název, umělce atd.) v mřížkovém zobrazení hudební obrazovky.';

  @override
  String get showCoverAsPlayerBackground =>
      'Zobrazit rozmazaný obal jako pozadí přehrávače';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Zda použít rozmazaný obal alba jako pozadí na obrazovce přehrávače.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Nezobrazovat umělce, pokud je totožný s umělcem alba';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Zda zobrazit umělce skladby na obrazovce alba, pokud se neliší od umělců alba.';

  @override
  String get disableGesture => 'Zakázat gesta';

  @override
  String get disableGestureSubtitle => 'Zda zakázat gesta.';

  @override
  String get showFastScroller => 'Zobrazit rychlý posuvník';

  @override
  String get theme => 'Motiv';

  @override
  String get system => 'Systémový';

  @override
  String get light => 'Světlý';

  @override
  String get dark => 'Tmavý';

  @override
  String get tabs => 'Karty';

  @override
  String get cancelSleepTimer => 'Zrušit časovač spánku?';

  @override
  String get yesButtonLabel => 'ANO';

  @override
  String get noButtonLabel => 'NE';

  @override
  String get setSleepTimer => 'Nastavit časovač spánku';

  @override
  String get minutes => 'Minuty';

  @override
  String get invalidNumber => 'Neplatné číslo';

  @override
  String get sleepTimerTooltip => 'Časovač spánku';

  @override
  String get addToPlaylistTooltip => 'Přidat do seznamu skladeb';

  @override
  String get addToPlaylistTitle => 'Přidat do seznamu skladeb';

  @override
  String get removeFromPlaylistTooltip => 'Odebrat ze seznamu skladeb';

  @override
  String get removeFromPlaylistTitle => 'Odebrat ze seznamu skladeb';

  @override
  String get newPlaylist => 'Nový seznam skladeb';

  @override
  String get createButtonLabel => 'VYTVOŘIT';

  @override
  String get playlistCreated => 'Seznam skladeb vytvořen.';

  @override
  String get noAlbum => 'Žádné album';

  @override
  String get noItem => 'Žádná položka';

  @override
  String get noArtist => 'Žádný umělec';

  @override
  String get unknownArtist => 'Neznámý umělec';

  @override
  String get streaming => 'STREAMOVÁNÍ';

  @override
  String get downloaded => 'STAŽENO';

  @override
  String get transcode => 'PŘEKÓDOVÁNÍ';

  @override
  String get direct => 'PŘÍMÝ';

  @override
  String get statusError => 'CHYBA STAVU';

  @override
  String get queue => 'Fronta';

  @override
  String get addToQueue => 'Přidat do fronty';

  @override
  String get playNext => 'Přehrát další';

  @override
  String get replaceQueue => 'Nahradit frontu';

  @override
  String get instantMix => 'Okamžitý mix';

  @override
  String get goToAlbum => 'Přejít na album';

  @override
  String get removeFavourite => 'Odebrat z oblíbených';

  @override
  String get addFavourite => 'Přidat do oblíbených';

  @override
  String get addedToQueue => 'Přidáno do fronty.';

  @override
  String get insertedIntoQueue => 'Vloženo do fronty.';

  @override
  String get queueReplaced => 'Fronta nahrazena.';

  @override
  String get removedFromPlaylist => 'Odebráno ze seznamu skladeb.';

  @override
  String get startingInstantMix => 'Spouštění okamžitého mixu.';

  @override
  String get anErrorHasOccured => 'Vyskytla se chyba.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Stavový kód $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Stavový kód $statusCode. Toto nejspíše znamená, že jste použili nesprávné uživatelské jméno / heslo, nebo váš klient již není přihlášen.';
  }

  @override
  String get removeFromMix => 'Odebrat z mixu';

  @override
  String get addToMix => 'Přidat do mixu';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znovu staženo $count položek',
      few: 'Znovu staženy$count položky',
      one: 'Znovu stažena$count položka',
      zero: 'Nejsou potřeba žádná opětovná stažení.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Trvání vyrovnávací paměti';

  @override
  String get bufferDurationSubtitle =>
      'Kolik sekund dopředu by měl přehrávač uložit do vyrovnávací paměti. Vyžaduje restart aplikace.';

  @override
  String get language => 'Jazyk';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get showUncensoredLogMessage =>
      'Tento protokol zobrazuje vaše přihlašovací informace. Chcete jej zobrazit?';

  @override
  String get resetTabs => 'Obnovit karty';

  @override
  String get noMusicLibrariesTitle => 'Žádné hudební knihovny';

  @override
  String get noMusicLibrariesBody =>
      'Finamp nenalezl žádné hudební knihovny. Ujistěte se prosím, že váš server Jellyfin obsahuje alespoň jednu knihovnu s typem obsahu nastaveným na „Hudba“.';

  @override
  String get refresh => 'OBNOVIT';

  @override
  String get swipeInsertQueueNext => 'Přehrát posunutou skladbu jako další';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Zapněte pro vložení skladby jako další položku do fronty po posunutí prstem na skladbě v seznamu skladeb, místo jejího přiřazení na konec.';

  @override
  String get redesignBeta => 'Vyzkoušejte beta verzi';

  @override
  String get playbackOrderShuffledTooltip => 'Náhodně. Klepnutím přepnete.';

  @override
  String get playbackOrderLinearTooltip =>
      'Přehrávání v pořadí. Klepnutím přepnete.';

  @override
  String get loopModeAllTooltip => 'Opakování všeho. Klepnutím přepnete.';

  @override
  String get loopModeOneTooltip => 'Opakování jedné. Klepnutím přepnete.';

  @override
  String get loopModeNoneTooltip => 'Bez opakování. Klepnutím přepnete.';

  @override
  String get skipToPrevious => 'Přeskočit na předchozí skladbu';

  @override
  String get skipToNext => 'Přeskočit na další skladbu';

  @override
  String get togglePlayback => 'Přepnout přehrávání';

  @override
  String playArtist(String artist) {
    return 'Přehrát všechna alba umělce $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Přehrát náhodně všechna alba umělce $artist';
  }

  @override
  String downloadArtist(String artist) {
    return 'Stáhnout všechna alba umělce $artist';
  }

  @override
  String get deleteFromDevice => 'Smazat ze zařízení';

  @override
  String get download => 'Stáhnout';

  @override
  String get sync => 'Synchronizovat se serverem';

  @override
  String get about => 'O aplikaci Finamp';
}
