// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String startupError(String error) {
    return 'Something went wrong during app startup. The error was: $error\n\nPlease create an issue on github.com/UnicornsOnLSD/finamp with a screenshot of this page. If this problem persists you can clear your app data to reset the app.';
  }

  @override
  String get serverUrl => 'Server URL';

  @override
  String get internalExternalIpExplanation =>
      'If you want to be able to access your Jellyfin server remotely, you need to use your external IP.\n\nIf your server is on a HTTP port (80/443), you don\'t have to specify a port. This will likely be the case if your server is behind a reverse proxy.';

  @override
  String get emptyServerUrl => 'Server URL cannot be empty';

  @override
  String get urlStartWithHttps => 'URL must start with http:// or https://';

  @override
  String get urlTrailingSlash => 'URL must not include a trailing slash';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get logs => 'Logs';

  @override
  String get next => 'Next';

  @override
  String get selectMusicLibraries => 'Select Music Libraries';

  @override
  String get couldNotFindLibraries => 'Could not find any libraries.';

  @override
  String get unknownName => 'Unknown Name';

  @override
  String get songs => 'Songs';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artists';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Playlists';

  @override
  String get startMix => 'Start Mix';

  @override
  String get startMixNoSongsArtist =>
      'Long-press an artist to add or remove it from the mix builder before starting a mix';

  @override
  String get startMixNoSongsAlbum =>
      'Long-press an album to add or remove it from the mix builder before starting a mix';

  @override
  String get music => 'Music';

  @override
  String get clear => 'Clear';

  @override
  String get favourites => 'Favourites';

  @override
  String get shuffleAll => 'Shuffle all';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Settings';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get sortOrder => 'Sort order';

  @override
  String get sortBy => 'Sort by';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album Artist';

  @override
  String get artist => 'Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Community Rating';

  @override
  String get criticRating => 'Critic Rating';

  @override
  String get dateAdded => 'Date Added';

  @override
  String get datePlayed => 'Date Played';

  @override
  String get playCount => 'Play Count';

  @override
  String get premiereDate => 'Premiere Date';

  @override
  String get productionYear => 'Production Year';

  @override
  String get name => 'Name';

  @override
  String get random => 'Random';

  @override
  String get revenue => 'Revenue';

  @override
  String get runtime => 'Runtime';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Download missing images';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Downloaded $count missing images',
      one: 'Downloaded $count missing image',
      zero: 'No missing images found',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Download errors';

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
    return '$count complete';
  }

  @override
  String dlFailed(int count) {
    return '$count failed';
  }

  @override
  String dlEnqueued(int count) {
    return '$count enqueued';
  }

  @override
  String dlRunning(int count) {
    return '$count running';
  }

  @override
  String get downloadErrorsTitle => 'Download Errors';

  @override
  String get noErrors => 'No errors!';

  @override
  String get errorScreenError =>
      'An error occurred while getting the list of errors! At this point, you should probably just create an issue on GitHub and delete app data';

  @override
  String get failedToGetSongFromDownloadId =>
      'Failed to get song from download ID';

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
  String get error => 'Error';

  @override
  String discNumber(int number) {
    return 'Disc $number';
  }

  @override
  String get playButtonLabel => 'PLAY';

  @override
  String get shuffleButtonLabel => 'SHUFFLE';

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
  String get editPlaylistNameTooltip => 'Edit playlist name';

  @override
  String get editPlaylistNameTitle => 'Edit Playlist Name';

  @override
  String get required => 'Required';

  @override
  String get updateButtonLabel => 'UPDATE';

  @override
  String get playlistNameUpdated => 'Playlist name updated.';

  @override
  String get favourite => 'Favourite';

  @override
  String get downloadsDeleted => 'Downloads deleted.';

  @override
  String get addDownloads => 'Add Downloads';

  @override
  String get location => 'Location';

  @override
  String get downloadsAdded => 'Downloads added.';

  @override
  String get addButtonLabel => 'ADD';

  @override
  String get shareLogs => 'Share logs';

  @override
  String get logsCopied => 'Logs copied.';

  @override
  String get message => 'Message';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String get applicationLegalese =>
      'Licensed with the Mozilla Public License 2.0. Source code available at:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcoding';

  @override
  String get downloadLocations => 'Download Locations';

  @override
  String get audioService => 'Audio Service';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Layout & Theme';

  @override
  String get notAvailableInOfflineMode => 'Not available in offline mode';

  @override
  String get logOut => 'Log Out';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Downloaded songs will not be deleted';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin uses AAC for transcoding';

  @override
  String get enableTranscoding => 'Enable Transcoding';

  @override
  String get enableTranscodingSubtitle =>
      'Transcodes music streams on the server side.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'A higher bitrate gives higher quality audio at the cost of higher bandwidth.';

  @override
  String get customLocation => 'Custom Location';

  @override
  String get appDirectory => 'App Directory';

  @override
  String get addDownloadLocation => 'Add Download Location';

  @override
  String get selectDirectory => 'Select Directory';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get pathReturnSlashErrorMessage =>
      'Paths that return \"/\" can\'t be used';

  @override
  String get directoryMustBeEmpty => 'Directory must be empty';

  @override
  String get customLocationsBuggy =>
      'Custom locations are extremely buggy due to issues with permissions. I\'m thinking of ways to fix this, but for now I wouldn\'t recommend using them.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Enter Low-Priority State on Pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Lets the notification be swiped away when paused. Also allows Android to kill the service when paused.';

  @override
  String get shuffleAllSongCount => 'Shuffle All Song Count';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Amount of songs to load when using the shuffle all songs button.';

  @override
  String get viewType => 'View Type';

  @override
  String get viewTypeSubtitle => 'View type for the music screen';

  @override
  String get list => 'List';

  @override
  String get grid => 'Grid';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Landscape';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Grid Cross-Axis Count';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Amount of grid tiles to use per-row when $value.';
  }

  @override
  String get showTextOnGridView => 'Show text in grid view';

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
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get tabs => 'Tabs';

  @override
  String get cancelSleepTimer => 'Cancel Sleep Timer?';

  @override
  String get yesButtonLabel => 'YES';

  @override
  String get noButtonLabel => 'NO';

  @override
  String get setSleepTimer => 'Set Sleep Timer';

  @override
  String get minutes => 'Minutes';

  @override
  String get invalidNumber => 'Invalid Number';

  @override
  String get sleepTimerTooltip => 'Sleep timer';

  @override
  String get addToPlaylistTooltip => 'Add to playlist';

  @override
  String get addToPlaylistTitle => 'Add to Playlist';

  @override
  String get removeFromPlaylistTooltip => 'Remove from playlist';

  @override
  String get removeFromPlaylistTitle => 'Remove from Playlist';

  @override
  String get newPlaylist => 'New Playlist';

  @override
  String get createButtonLabel => 'CREATE';

  @override
  String get playlistCreated => 'Playlist created.';

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
