// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String startupError(String error) {
    return 'Någonting gick fel under uppstart. Felet var: $error\n\nSkapa gärna ett ärende på github.com/UnicornsOnLSD/finamp med en skärmdump av denna sida. Om problemet fortsätter kan du rensa appdatan för att återställa appen.';
  }

  @override
  String get serverUrl => 'Länk Till Servern';

  @override
  String get internalExternalIpExplanation =>
      'Om du vill ha åtkomst till din Jellyfin-server utanför hemmet, behöver du använda din externa IP-adress.\n\nOm din server är bakom en HTTP-port (80/443) så behöver du inte manuellt specificera en port. Detta är troligtvis fallet om din server finns bakom en omvänd proxy.';

  @override
  String get emptyServerUrl => 'Länken till servern får inte vara blank';

  @override
  String get urlStartWithHttps =>
      'URL:en måste börja med antingen http:// eller https://';

  @override
  String get urlTrailingSlash =>
      'URL:en får inte innehålla ett avslutande snedstreck';

  @override
  String get username => 'Användarnamn';

  @override
  String get password => 'Lösenord';

  @override
  String get logs => 'Loggar';

  @override
  String get next => 'Nästa';

  @override
  String get selectMusicLibraries => 'Välj Musikbibliotek';

  @override
  String get couldNotFindLibraries => 'Kunde inte hitta några bibliotek.';

  @override
  String get unknownName => 'Okänt Namn';

  @override
  String get songs => 'Låtar';

  @override
  String get albums => 'Album';

  @override
  String get artists => 'Artister';

  @override
  String get genres => 'Genrer';

  @override
  String get playlists => 'Spellistor';

  @override
  String get startMix => 'Starta Mix';

  @override
  String get startMixNoSongsArtist =>
      'Tryck länge på en artist för att lägga till eller ta bort den från mix-byggaren innan du startar en mix';

  @override
  String get startMixNoSongsAlbum =>
      'Tryck länge på ett album för att lägga till eller ta bort det från mix-byggaren innan du startar en mix';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Rensa';

  @override
  String get favourites => 'Favoriter';

  @override
  String get shuffleAll => 'Shuffle (alla)';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Nedladdningar';

  @override
  String get settings => 'Inställningar';

  @override
  String get offlineMode => 'Offlineläge';

  @override
  String get sortOrder => 'Sorteringsordning';

  @override
  String get sortBy => 'Sortera efter';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumartist';

  @override
  String get artist => 'Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Allmänhetens Betyg';

  @override
  String get criticRating => 'Kritikerbetyg';

  @override
  String get dateAdded => 'Datum Tillagd';

  @override
  String get datePlayed => 'Datum Uppspelad';

  @override
  String get playCount => 'Antal Uppspelningar';

  @override
  String get premiereDate => 'Premiärdatum';

  @override
  String get productionYear => 'Produktionsår';

  @override
  String get name => 'Namn';

  @override
  String get random => 'Slumpmässig';

  @override
  String get revenue => 'Intäkter';

  @override
  String get runtime => 'Längd';

  @override
  String get syncDownloadedPlaylists => 'Synkronisera nedladdade spellistor';

  @override
  String get downloadMissingImages => 'Hämta saknade bilder';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Laddade ner $count saknade bilder',
      one: 'Laddade ner $count saknad bild',
      zero: 'Inga saknade bilder hittades',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Nedladdningsfel';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedladdningar',
      one: '$count nedladdning',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objekt',
      one: '$count objekt',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilder',
      one: '$count bild',
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
    return '$count färdiga';
  }

  @override
  String dlFailed(int count) {
    return '$count misslyckade';
  }

  @override
  String dlEnqueued(int count) {
    return '$count i kö';
  }

  @override
  String dlRunning(int count) {
    return '$count pågående';
  }

  @override
  String get downloadErrorsTitle => 'Nedladdningsfel';

  @override
  String get noErrors => 'Inga fel!';

  @override
  String get errorScreenError =>
      'Ett fel uppstod när listan över fel skulle hämtas! Vid det här laget bör du förmodligen bara skapa ett problem på GitHub och ta bort appdata';

  @override
  String get failedToGetSongFromDownloadId =>
      'Kunde inte hämta låt med hjälp av nedladdnings-ID';

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
    return 'Är du säker på att du vill ta bort $_temp0 \'$itemName\' från den här enheten?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Ta bort';

  @override
  String get deleteDownloadsAbortButtonText => 'Avbryt';

  @override
  String get error => 'Fel';

  @override
  String discNumber(int number) {
    return 'Skiva $number';
  }

  @override
  String get playButtonLabel => 'SPELA UPP';

  @override
  String get shuffleButtonLabel => 'SHUFFLE';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Låtar',
      one: '$count Låt',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Ändra namn på spellista';

  @override
  String get editPlaylistNameTitle => 'Ändra Namn På Spellista';

  @override
  String get required => 'Obligatoriskt';

  @override
  String get updateButtonLabel => 'UPPDATERA';

  @override
  String get playlistNameUpdated => 'Spellistans namn är ändrat.';

  @override
  String get favourite => 'Lägg till som favorit';

  @override
  String get downloadsDeleted => 'Nedladdningar raderade.';

  @override
  String get addDownloads => 'Lägg Till Nedladdningar';

  @override
  String get location => 'Plats';

  @override
  String get downloadsAdded => 'Nedladdningar tillagda.';

  @override
  String get addButtonLabel => 'LÄGG TILL';

  @override
  String get shareLogs => 'Dela loggar';

  @override
  String get logsCopied => 'Loggar kopierade.';

  @override
  String get message => 'Meddelande';

  @override
  String get stackTrace => 'Stackspår';

  @override
  String get applicationLegalese =>
      'Licensierad med Mozilla Public License 2.0. Källkoden finns att se på:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Omkodning';

  @override
  String get downloadLocations => 'Platser För Nedladdningar';

  @override
  String get audioService => 'Ljudtjänst';

  @override
  String get interactions => 'Interaktioner';

  @override
  String get layoutAndTheme => 'Layout & Tema';

  @override
  String get notAvailableInOfflineMode => 'Inte tillgänglig i offlineläge';

  @override
  String get logOut => 'Logga Ut';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Nedladdade låtar kommer inte att raderas';

  @override
  String get areYouSure => 'Är du säker?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin använder AAC för omkodning';

  @override
  String get enableTranscoding => 'Aktivera Omkodning';

  @override
  String get enableTranscodingSubtitle => 'Koda om musikströmmar på servern.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Högre bitrate (överföringshastighet) resulterar i högre kvalitet men förbrukar också mer data.';

  @override
  String get customLocation => 'Anpassad Plats';

  @override
  String get appDirectory => 'Filmapp för Appen';

  @override
  String get addDownloadLocation => 'Lägg Till Nedladdningsplats';

  @override
  String get selectDirectory => 'Välj Filmapp';

  @override
  String get unknownError => 'Okänt Fel';

  @override
  String get pathReturnSlashErrorMessage =>
      'Sökvägar som returnerar ett \"/\" kan inte användas';

  @override
  String get directoryMustBeEmpty => 'Filmappen måste vara tom';

  @override
  String get customLocationsBuggy =>
      'Det finns en hel del buggar relaterade till anpassade platser just nu på grund av krångel med användarbehörigheter. Jag försöker lista ut hur det bäst ska lösas, men i nuläget rekommenderar jag att inte använda dem.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Gå in i lågprioritetstillstånd vid paus';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Låter aviseringen svepas bort när den är pausad. Tillåter även Android att döda tjänsten när den är pausad.';

  @override
  String get shuffleAllSongCount => 'Blanda alla låtar';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Antal låtar att ladda vid användning av shuffle-knappen.';

  @override
  String get viewType => 'Visningstyp';

  @override
  String get viewTypeSubtitle => 'Visningstyp för musikskärmen';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Rutnät';

  @override
  String get portrait => 'Stående läge';

  @override
  String get landscape => 'Liggande läge';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Antal rutnätskorsaxel';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Antal rutnäts-rutor per rad i $value.';
  }

  @override
  String get showTextOnGridView => 'Visa text i rutnätsvy';

  @override
  String get showTextOnGridViewSubtitle =>
      'Huruvida text (titel, artist etc.) ska visas på rutnäts-musikskärmen.';

  @override
  String get showCoverAsPlayerBackground =>
      'Visa suddigt omslag som spelarbakgrund';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Om du vill använda suddig omslagsbild som bakgrund på spelarskärmen.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Dölj låtartister om samma som albumartister';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Om låtartister ska visas på albumskärmen om de inte skiljer sig från albumartister.';

  @override
  String get disableGesture => 'Inaktivera gester';

  @override
  String get disableGestureSubtitle => 'Huruvida man ska inaktivera gester.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'System';

  @override
  String get light => 'Ljust';

  @override
  String get dark => 'Mörkt';

  @override
  String get tabs => 'Flikar';

  @override
  String get cancelSleepTimer => 'Avbryt Sovtimer?';

  @override
  String get yesButtonLabel => 'JA';

  @override
  String get noButtonLabel => 'NEJ';

  @override
  String get setSleepTimer => 'Ställ In Sovtimer';

  @override
  String get minutes => 'Minuter';

  @override
  String get invalidNumber => 'Ogiltigt Nummer';

  @override
  String get sleepTimerTooltip => 'Sovtimer';

  @override
  String get addToPlaylistTooltip => 'Lägg till i spellista';

  @override
  String get addToPlaylistTitle => 'Lägg till i Spellista';

  @override
  String get removeFromPlaylistTooltip => 'Ta bort från spellista';

  @override
  String get removeFromPlaylistTitle => 'Ta bort från spellista';

  @override
  String get newPlaylist => 'Ny Spellista';

  @override
  String get createButtonLabel => 'SKAPA';

  @override
  String get playlistCreated => 'Spellista skapad.';

  @override
  String get noAlbum => 'Inget Album';

  @override
  String get noItem => 'Inget objekt';

  @override
  String get noArtist => 'Ingen Artist';

  @override
  String get unknownArtist => 'Okänd Artist';

  @override
  String get streaming => 'STRÖMNING';

  @override
  String get downloaded => 'NEDLADDAD';

  @override
  String get transcode => 'OMKODA';

  @override
  String get direct => 'DIREKT';

  @override
  String get statusError => 'STATUSFEL';

  @override
  String get queue => 'Kö';

  @override
  String get addToQueue => 'Lägg till i Uppspelningskö';

  @override
  String get playNext => 'Spela Nästa';

  @override
  String get replaceQueue => 'Ersätt Uppspelningskö';

  @override
  String get instantMix => 'Snabbmix';

  @override
  String get goToAlbum => 'Gå till Album';

  @override
  String get removeFavourite => 'Ta Bort Favorit';

  @override
  String get addFavourite => 'Lägg Till Favorit';

  @override
  String get addedToQueue => 'Tillagd i uppspelningskön.';

  @override
  String get insertedIntoQueue => 'Insatt i kön.';

  @override
  String get queueReplaced => 'Uppspelningskö ändrad.';

  @override
  String get removedFromPlaylist => 'Borttagen från spellista.';

  @override
  String get startingInstantMix => 'Startar snabbmix.';

  @override
  String get anErrorHasOccured => 'Ett fel har inträffat.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Statuskod $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Statuskod $statusCode. Detta betyder troligtvis att du använt fel användarnamn/lösenord, eller att din klientapplikation inte längre är autentiserad.';
  }

  @override
  String get removeFromMix => 'Ta bort från blandning';

  @override
  String get addToMix => 'Lägg till i mixen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nedladdat igen$count items',
      one: 'Nedladdat igen $count item',
      zero: 'Inga omnedladdningar behövs..',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Buffertlängd';

  @override
  String get bufferDurationSubtitle =>
      'Hur mycket spelaren ska buffra, i sekunder. Kräver omstart.';

  @override
  String get language => 'Språk';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get showUncensoredLogMessage =>
      'Denna logg innehåller din inloggningsinformation. Visa?';

  @override
  String get resetTabs => 'Återställ flikar';

  @override
  String get noMusicLibrariesTitle => 'Inga musikbibliotek';

  @override
  String get noMusicLibrariesBody =>
      'Finamp kunde inte hitta några musikbibliotek. Se till att din Jellyfin-server innehåller minst ett bibliotek med innehållstypen inställd på \"Musik\".';

  @override
  String get refresh => 'UPPDATERA';

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
