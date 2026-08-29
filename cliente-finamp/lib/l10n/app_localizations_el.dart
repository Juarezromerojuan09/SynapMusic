// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String startupError(String error) {
    return 'Ωχ, κάτι δεν πήγε καλά κατά την έναρξη της εφαρμογής. Ο αριθμός σφάλματος είναι:$error\nΔημιούργησε ένα issue στο\ngithub.com/UnicornsOnLSD/finamp μαζί με ένα στιγμιότυπο οθόνης από αυτήν την σελίδα. Εάν το πρόβλημα παραμένει μπορείς να διαγράψεις τα δεδομένα της εφαρμογής με σκοπό την επαναφορά της.';
  }

  @override
  String get serverUrl => 'Διεύθυνση διακομιστή';

  @override
  String get internalExternalIpExplanation =>
      'Αν θέλεις να έχεις πρόσβαση στον jellyfin διακομιστή σου εξ-αποστασεως, πρέπει να χρησιμοποιήσεις την εξωτερική Διεύθυνση IP.\n\nΑν ο διακομιστής βρίσκεται σε πύλη HTTP(80/443), δεν είναι απαραίτητος ο ορισμός πύλης. Αυτό είναι πιθανόν εφόσον ο διακομιστής σου βρίσκεται πίσω από reverse proxy.';

  @override
  String get emptyServerUrl =>
      'Η διεύθυνση διακομιστή δεν μπορεί να είναι κενή';

  @override
  String get urlStartWithHttps =>
      'Η διεύθυνση πρέπει να ξεκινά με http:// ή https://';

  @override
  String get urlTrailingSlash =>
      'Η διεύθυνση δεν πρέπει να περιέχει ακολουθούμενη κάθετο';

  @override
  String get username => 'Όνομα χρήστη';

  @override
  String get password => 'Συνθηματικό χρήστη';

  @override
  String get logs => 'Αρχείο καταγραφών';

  @override
  String get next => 'Επόμενο';

  @override
  String get selectMusicLibraries => 'Επέλεξε τις βιβλιοθήκες μουσικής σου';

  @override
  String get couldNotFindLibraries => 'Δεν βρέθηκαν συλλογές.';

  @override
  String get unknownName => 'Άγνωστη όνομα';

  @override
  String get songs => 'Τραγούδια';

  @override
  String get albums => 'Άλμπουμ';

  @override
  String get artists => 'Καλλιτέχνες';

  @override
  String get genres => 'Είδη';

  @override
  String get playlists => 'Λίστες αναπαραγωγής';

  @override
  String get startMix => 'Έναρξη μίξης';

  @override
  String get startMixNoSongsArtist =>
      'Κράτησε πατημένο έναν καλλιτέχνη, προκειμένου να προστεθεί ή να αφαιρεθεί από τον κατασκευαστή μίξεων, προ-εκκινήσεως μίξης';

  @override
  String get startMixNoSongsAlbum =>
      'Κράτησε πατημένο ένα άλμπουμ, προκειμένου να προστεθεί ή να αφαιρεθεί από τον κατασκευαστή μίξεων, προ-εκκινήσεως μίξης';

  @override
  String get music => 'Μουσική';

  @override
  String get clear => 'Εκκαθάριση';

  @override
  String get favourites => 'Αγαπημένα';

  @override
  String get shuffleAll => 'Τυχαία αναπαραγωγή';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Λήψεις';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get offlineMode => 'Λειτουργία εκτός σύνδεσης';

  @override
  String get sortOrder => 'Σειρά ταξινόμησης';

  @override
  String get sortBy => 'Ταξινόμηση κατά';

  @override
  String get album => 'Άλμπουμ';

  @override
  String get albumArtist => 'Καλλιτέχνης άλμπουμ';

  @override
  String get artist => 'Καλλιτέχνης';

  @override
  String get budget => 'Προϋπολογισμός';

  @override
  String get communityRating => 'Βαθμολογία κοινότητας';

  @override
  String get criticRating => 'Βαθμολογία κριτών';

  @override
  String get dateAdded => 'Ημερομηνία προσθήκης';

  @override
  String get datePlayed => 'Ημερομηνία αναπαραγωγής';

  @override
  String get playCount => 'Πλήθος αναπαραγωγών';

  @override
  String get premiereDate => 'Ημερομηνία πρεμιέρας';

  @override
  String get productionYear => 'Χρονολογία παραγωγής';

  @override
  String get name => 'Όνομα';

  @override
  String get random => 'Τυχαίο';

  @override
  String get revenue => 'Έσοδα';

  @override
  String get runtime => 'Διάρκεια';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Λήψη ελλείποντων εικόνων';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ελήφθησαν $count ελλειπής εικόνες',
      one: 'ελήφθησαν $count ελλειπής εικόνες',
      zero: 'δεν βρέθηκαν ελλειπείς εικόνες',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Σφάλμα στην λήψη';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λήψεις',
      one: '$count λήψη',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αντικείμενα',
      one: '$count αντικείμενο',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count εικόνες',
      one: '$count εικόνα',
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
    return '$count ολοκληρώθηκαν';
  }

  @override
  String dlFailed(int count) {
    return '$count απέτυχαν';
  }

  @override
  String dlEnqueued(int count) {
    return '$count στην σειρά';
  }

  @override
  String dlRunning(int count) {
    return '$count τρέχοντα';
  }

  @override
  String get downloadErrorsTitle => 'Σφάλματα λήψης';

  @override
  String get noErrors => 'Κανένα σφάλμα!';

  @override
  String get errorScreenError =>
      'Προέκυψε σφάλμα κατά την λήψη λίστας σφαλμάτων! Σε αυτό το σημείο, καλό είναι να δημιουργήσεις issue στο GitHub και να διαγράψεις τα δεδομένα της εφαρμογής';

  @override
  String get failedToGetSongFromDownloadId =>
      'Απέτυχε η λήψη τραγουδιού από το download ID';

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
  String get error => 'Σφάλμα';

  @override
  String discNumber(int number) {
    return 'Δίσκος $number';
  }

  @override
  String get playButtonLabel => 'Αναπαραγωγή';

  @override
  String get shuffleButtonLabel => 'Τυχαία αναπαραγωγή';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τίτλοι',
      one: '$count τίτλος',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Τροποποίηση λίστας αναπαραγωγής';

  @override
  String get editPlaylistNameTitle => 'Τροποποίηση ονόματος λίστας';

  @override
  String get required => 'Απαραίτητο';

  @override
  String get updateButtonLabel => 'Ανανέωση';

  @override
  String get playlistNameUpdated => 'Ανανεώθηκε το όνομα λίστας αναπαραγωγής.';

  @override
  String get favourite => 'Αγαπημένο';

  @override
  String get downloadsDeleted => 'Διαγράφτηκαν οι λήψεις.';

  @override
  String get addDownloads => 'Προσθήκη λήψεων';

  @override
  String get location => 'Τοποθεσία';

  @override
  String get downloadsAdded => 'Προστέθηκαν λήψεις.';

  @override
  String get addButtonLabel => 'Προσθήκη';

  @override
  String get shareLogs => 'Μοιραστείτε τις καταγραφές';

  @override
  String get logsCopied => 'Αντιγράφηκαν οι καταγραφές.';

  @override
  String get message => 'Μύνημα';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String get applicationLegalese =>
      'Αδειοδοτηθηκε με την Άδεια Δημόσιας Χρήσης της Mozilla Public License2.0. Ο κώδικας πηγής διαθέσιμος στο:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Μετακωδικοποίηση';

  @override
  String get downloadLocations => 'Τοποθεσίες λήψεων';

  @override
  String get audioService => 'Audio Service';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Διάταξη καί εμφάνιση';

  @override
  String get notAvailableInOfflineMode =>
      'Μη διαθέσιμο σε λειτουργία εκτός σύνδεσης';

  @override
  String get logOut => 'Έξοδος';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Κατεβασμένα τραγούδια δεν θα διαγραφούν';

  @override
  String get areYouSure => 'Είσαι σίγουρος?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Το Jellyfin χρησιμοποιεί AAC για την μετακωδικοποίηση';

  @override
  String get enableTranscoding => 'Ενεργοποίηση μετακωδικοποίησης';

  @override
  String get enableTranscodingSubtitle =>
      'μετακωδικοποιει την ροή μουσικής από την πλευρά του διακομιστή.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Ο ψηλότερος bitrate προσφέρει υψηλότερης ποιότητας ήχο σε βάρος εύρους ζώνης.';

  @override
  String get customLocation => 'Εξατομικευμένη τοποθεσία';

  @override
  String get appDirectory => 'Κατάλογος εφαρμογής';

  @override
  String get addDownloadLocation => 'Προσθήκη τοποθεσίας λήψεως';

  @override
  String get selectDirectory => 'Επέλεξε κατάλογο';

  @override
  String get unknownError => 'Άγνωστο σφάλμα';

  @override
  String get pathReturnSlashErrorMessage =>
      'Μονοπάτια που επιστρέφουν \"/\" δεν μπορούν να χρησιμοποιηθούν';

  @override
  String get directoryMustBeEmpty => 'Ο κατάλογος πρέπει να είναι άδειος';

  @override
  String get customLocationsBuggy =>
      'Οι εξατομικευμένες τοποθεσίες έχουν αρκετά bugs λόγω θεμάτων αδειών.\nΣκέφτομαι τρόπους να φτιάξω τα προβλήμματα, όμως για τώρα δεν προτείνω την χρήση τους.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Ενεργοποίηση χαμηλής-προτεραιοτητας κατάσταση κατά την παύση';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Επιτρέπει την απόσβεση της ειδοποίησης κατά την παύση. Επίσης επιτρέπει στο σύστημα να \"σκοτώνει\" την υπηρεσία κατά την παύση.';

  @override
  String get shuffleAllSongCount =>
      'Τυχαία αναπαραγωγή όλων των Πλήθων τραγουδιών';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Πλήθος τραγουδιών να φορτώσουν όταν χρησιμοποιείται το κουμπί τυχαίας αναπαραγωγής όλων.';

  @override
  String get viewType => 'Τύπος προβολής';

  @override
  String get viewTypeSubtitle => 'Τρόπος προβολής για την οθόνη μουσικής';

  @override
  String get list => 'Λίστα';

  @override
  String get grid => 'Πλέγμα';

  @override
  String get portrait => 'Κάθετο';

  @override
  String get landscape => 'Οριζόντιο';

  @override
  String gridCrossAxisCount(String value) {
    return '$value πλήθος τεμνοντων αξόνων πλέγματος';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Πλήθος τετραγώνων πλέγματος ανά Πλειάδες$value.';
  }

  @override
  String get showTextOnGridView => 'Εμφάνιση αναγραφων στην προβολή πλέγματος';

  @override
  String get showTextOnGridViewSubtitle =>
      'Whether or not to show the text (title, artist etc) on the grid music screen.';

  @override
  String get showCoverAsPlayerBackground =>
      'Show blurred cover as player background';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Whether or not to use blurred cover art as background on player screen.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Hide song artists if same as album artists';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Whether to show song artists on the album screen if not differing from album artists.';

  @override
  String get disableGesture => 'Disable gestures';

  @override
  String get disableGestureSubtitle => 'Whether to disables gestures.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Θέμα';

  @override
  String get system => 'Σύστημα';

  @override
  String get light => 'Φωτεινό';

  @override
  String get dark => 'Σκοτεινό';

  @override
  String get tabs => 'Καρτέλες';

  @override
  String get cancelSleepTimer => 'Ακύρωση χρονοδιακόπτη ύπνου;';

  @override
  String get yesButtonLabel => 'ΝΑΙ';

  @override
  String get noButtonLabel => 'ΟΧΙ';

  @override
  String get setSleepTimer => 'Ρύθμιση Χρονοδιακόπτη Ύπνου';

  @override
  String get minutes => 'Λεπτά';

  @override
  String get invalidNumber => 'Μη Έγκυρος Αριθμός';

  @override
  String get sleepTimerTooltip => 'Χρονοδιακόπτης Ύπνου';

  @override
  String get addToPlaylistTooltip => 'Προσθήκη στην λίστα αναπαραγωγής';

  @override
  String get addToPlaylistTitle => 'Προσθήκη στην Λίστα Αναπαραγωγής';

  @override
  String get removeFromPlaylistTooltip => 'Αφαίρεση από την λίστα αναπαραγωγής';

  @override
  String get removeFromPlaylistTitle => 'Αφαίρεση από την Λίστα Αναπαραγωγής';

  @override
  String get newPlaylist => 'Νέα Λίστα Αναπαραγωγής';

  @override
  String get createButtonLabel => 'ΔΗΜΙΟΥΡΓΙΑ';

  @override
  String get playlistCreated => 'Η Λίστα Αναπαραγωγής δημιουργήθηκε.';

  @override
  String get noAlbum => 'No Album';

  @override
  String get noItem => 'No Item';

  @override
  String get noArtist => 'No Artist';

  @override
  String get unknownArtist => 'Unknown Artist';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'DOWNLOADED';

  @override
  String get transcode => 'TRANSCODE';

  @override
  String get direct => 'DIRECT';

  @override
  String get statusError => 'STATUS ERROR';

  @override
  String get queue => 'Queue';

  @override
  String get addToQueue => 'Add to Queue';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Replace Queue';

  @override
  String get instantMix => 'Instant Mix';

  @override
  String get goToAlbum => 'Go to Album';

  @override
  String get removeFavourite => 'Remove Favourite';

  @override
  String get addFavourite => 'Add Favourite';

  @override
  String get addedToQueue => 'Added to queue.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Queue replaced.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Starting instant mix.';

  @override
  String get anErrorHasOccured => 'An error has occured.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. This probably means you used the wrong username/password, or your client is no longer logged in.';
  }

  @override
  String get removeFromMix => 'Remove From Mix';

  @override
  String get addToMix => 'Add To Mix';

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
