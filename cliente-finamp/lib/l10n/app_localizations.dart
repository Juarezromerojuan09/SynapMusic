import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_szl.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('sv'),
    Locale('sw'),
    Locale('szl'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale.fromSubtags(
        languageCode: 'zh', countryCode: 'HK', scriptCode: 'Hant')
  ];

  /// The error message that shows when startup fails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during app startup. The error was: {error}\n\nPlease create an issue on github.com/UnicornsOnLSD/finamp with a screenshot of this page. If this problem persists you can clear your app data to reset the app.'**
  String startupError(String error);

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// Extra info for which IP to use for remote access, and info on whether or not the user needs to specify a port.
  ///
  /// In en, this message translates to:
  /// **'If you want to be able to access your Jellyfin server remotely, you need to use your external IP.\n\nIf your server is on a HTTP port (80/443), you don\'t have to specify a port. This will likely be the case if your server is behind a reverse proxy.'**
  String get internalExternalIpExplanation;

  /// Error message that shows when the user submits a login without a server URL
  ///
  /// In en, this message translates to:
  /// **'Server URL cannot be empty'**
  String get emptyServerUrl;

  /// Error message that shows when the user submits a server URL that doesn't start with http:// or https:// (for example, ftp://0.0.0.0
  ///
  /// In en, this message translates to:
  /// **'URL must start with http:// or https://'**
  String get urlStartWithHttps;

  /// Error message that shows when the user submits a server URL that ends with a trailing slash (for example, http://0.0.0.0/)
  ///
  /// In en, this message translates to:
  /// **'URL must not include a trailing slash'**
  String get urlTrailingSlash;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// App bar title for library select screen
  ///
  /// In en, this message translates to:
  /// **'Select Music Libraries'**
  String get selectMusicLibraries;

  /// Error message when the user does not have any libraries
  ///
  /// In en, this message translates to:
  /// **'Could not find any libraries.'**
  String get couldNotFindLibraries;

  /// No description provided for @unknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown Name'**
  String get unknownName;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @startMix.
  ///
  /// In en, this message translates to:
  /// **'Start Mix'**
  String get startMix;

  /// Snackbar message that shows when the user presses the instant mix button with no artists selected
  ///
  /// In en, this message translates to:
  /// **'Long-press an artist to add or remove it from the mix builder before starting a mix'**
  String get startMixNoSongsArtist;

  /// Snackbar message that shows when the user presses the instant mix button with no albums selected
  ///
  /// In en, this message translates to:
  /// **'Long-press an album to add or remove it from the mix builder before starting a mix'**
  String get startMixNoSongsAlbum;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @shuffleAll.
  ///
  /// In en, this message translates to:
  /// **'Shuffle all'**
  String get shuffleAll;

  /// No description provided for @finamp.
  ///
  /// In en, this message translates to:
  /// **'Finamp'**
  String get finamp;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order'**
  String get sortOrder;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @albumArtist.
  ///
  /// In en, this message translates to:
  /// **'Album Artist'**
  String get albumArtist;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @communityRating.
  ///
  /// In en, this message translates to:
  /// **'Community Rating'**
  String get communityRating;

  /// No description provided for @criticRating.
  ///
  /// In en, this message translates to:
  /// **'Critic Rating'**
  String get criticRating;

  /// No description provided for @dateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get dateAdded;

  /// No description provided for @datePlayed.
  ///
  /// In en, this message translates to:
  /// **'Date Played'**
  String get datePlayed;

  /// No description provided for @playCount.
  ///
  /// In en, this message translates to:
  /// **'Play Count'**
  String get playCount;

  /// No description provided for @premiereDate.
  ///
  /// In en, this message translates to:
  /// **'Premiere Date'**
  String get premiereDate;

  /// No description provided for @productionYear.
  ///
  /// In en, this message translates to:
  /// **'Production Year'**
  String get productionYear;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @runtime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// No description provided for @syncDownloadedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Sync downloaded playlists'**
  String get syncDownloadedPlaylists;

  /// No description provided for @downloadMissingImages.
  ///
  /// In en, this message translates to:
  /// **'Download missing images'**
  String get downloadMissingImages;

  /// Message that shows when the user downloads missing images
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{No missing images found} =1{Downloaded {count} missing image} other{Downloaded {count} missing images}}'**
  String downloadedMissingImages(int count);

  /// No description provided for @downloadErrors.
  ///
  /// In en, this message translates to:
  /// **'Download errors'**
  String get downloadErrors;

  /// No description provided for @downloadCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} download} other{{count} downloads}}'**
  String downloadCount(int count);

  /// No description provided for @downloadedItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} item} other{{count} items}}'**
  String downloadedItemsCount(int count);

  /// No description provided for @downloadedImagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} image} other{{count} images}}'**
  String downloadedImagesCount(int count);

  /// This is for merging downloadedItemsCount and downloadedImagesCount as Flutter's intl stuff doesn't support multiple plurals in one string. https://github.com/flutter/flutter/issues/86906
  ///
  /// In en, this message translates to:
  /// **'{downloadedItems}, {downloadedImages}'**
  String downloadedItemsImagesCount(
      String downloadedItems, String downloadedImages);

  /// No description provided for @dlComplete.
  ///
  /// In en, this message translates to:
  /// **'{count} complete'**
  String dlComplete(int count);

  /// No description provided for @dlFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String dlFailed(int count);

  /// No description provided for @dlEnqueued.
  ///
  /// In en, this message translates to:
  /// **'{count} enqueued'**
  String dlEnqueued(int count);

  /// No description provided for @dlRunning.
  ///
  /// In en, this message translates to:
  /// **'{count} running'**
  String dlRunning(int count);

  /// No description provided for @downloadErrorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Download Errors'**
  String get downloadErrorsTitle;

  /// No description provided for @noErrors.
  ///
  /// In en, this message translates to:
  /// **'No errors!'**
  String get noErrors;

  /// No description provided for @errorScreenError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while getting the list of errors! At this point, you should probably just create an issue on GitHub and delete app data'**
  String get errorScreenError;

  /// No description provided for @failedToGetSongFromDownloadId.
  ///
  /// In en, this message translates to:
  /// **'Failed to get song from download ID'**
  String get failedToGetSongFromDownloadId;

  /// Confirmation prompt shown before deleting downloaded media from the local device, destructive action, doesn't affect the media on the server.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {itemType, select, album{album} playlist{playlist} artist{artist} genre{genre} track{song} other{}} \'{itemName}\' from this device?'**
  String deleteDownloadsPrompt(String itemName, String itemType);

  /// Shown in the confirmation dialog for deleting downloaded media from the local device.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteDownloadsConfirmButtonText;

  /// No description provided for @deleteDownloadsAbortButtonText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteDownloadsAbortButtonText;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @discNumber.
  ///
  /// In en, this message translates to:
  /// **'Disc {number}'**
  String discNumber(int number);

  /// No description provided for @playButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get playButtonLabel;

  /// No description provided for @shuffleButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'SHUFFLE'**
  String get shuffleButtonLabel;

  /// No description provided for @songCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} Song} other{{count} Songs}}'**
  String songCount(int count);

  /// No description provided for @editPlaylistNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit playlist name'**
  String get editPlaylistNameTooltip;

  /// No description provided for @editPlaylistNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Playlist Name'**
  String get editPlaylistNameTitle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @updateButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get updateButtonLabel;

  /// No description provided for @playlistNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playlist name updated.'**
  String get playlistNameUpdated;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get favourite;

  /// No description provided for @downloadsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Downloads deleted.'**
  String get downloadsDeleted;

  /// No description provided for @addDownloads.
  ///
  /// In en, this message translates to:
  /// **'Add Downloads'**
  String get addDownloads;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @downloadsAdded.
  ///
  /// In en, this message translates to:
  /// **'Downloads added.'**
  String get downloadsAdded;

  /// No description provided for @addButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get addButtonLabel;

  /// No description provided for @shareLogs.
  ///
  /// In en, this message translates to:
  /// **'Share logs'**
  String get shareLogs;

  /// No description provided for @logsCopied.
  ///
  /// In en, this message translates to:
  /// **'Logs copied.'**
  String get logsCopied;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @stackTrace.
  ///
  /// In en, this message translates to:
  /// **'Stack Trace'**
  String get stackTrace;

  /// No description provided for @applicationLegalese.
  ///
  /// In en, this message translates to:
  /// **'Licensed with the Mozilla Public License 2.0. Source code available at:\n\ngithub.com/jmshrv/finamp'**
  String get applicationLegalese;

  /// No description provided for @transcoding.
  ///
  /// In en, this message translates to:
  /// **'Transcoding'**
  String get transcoding;

  /// No description provided for @downloadLocations.
  ///
  /// In en, this message translates to:
  /// **'Download Locations'**
  String get downloadLocations;

  /// No description provided for @audioService.
  ///
  /// In en, this message translates to:
  /// **'Audio Service'**
  String get audioService;

  /// No description provided for @interactions.
  ///
  /// In en, this message translates to:
  /// **'Interactions'**
  String get interactions;

  /// No description provided for @layoutAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Layout & Theme'**
  String get layoutAndTheme;

  /// No description provided for @notAvailableInOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Not available in offline mode'**
  String get notAvailableInOfflineMode;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @downloadedSongsWillNotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Downloaded songs will not be deleted'**
  String get downloadedSongsWillNotBeDeleted;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @jellyfinUsesAACForTranscoding.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin uses AAC for transcoding'**
  String get jellyfinUsesAACForTranscoding;

  /// No description provided for @enableTranscoding.
  ///
  /// In en, this message translates to:
  /// **'Enable Transcoding'**
  String get enableTranscoding;

  /// No description provided for @enableTranscodingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transcodes music streams on the server side.'**
  String get enableTranscodingSubtitle;

  /// No description provided for @bitrate.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get bitrate;

  /// No description provided for @bitrateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A higher bitrate gives higher quality audio at the cost of higher bandwidth.'**
  String get bitrateSubtitle;

  /// No description provided for @customLocation.
  ///
  /// In en, this message translates to:
  /// **'Custom Location'**
  String get customLocation;

  /// No description provided for @appDirectory.
  ///
  /// In en, this message translates to:
  /// **'App Directory'**
  String get appDirectory;

  /// No description provided for @addDownloadLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Download Location'**
  String get addDownloadLocation;

  /// No description provided for @selectDirectory.
  ///
  /// In en, this message translates to:
  /// **'Select Directory'**
  String get selectDirectory;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// No description provided for @pathReturnSlashErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Paths that return \"/\" can\'t be used'**
  String get pathReturnSlashErrorMessage;

  /// No description provided for @directoryMustBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Directory must be empty'**
  String get directoryMustBeEmpty;

  /// No description provided for @customLocationsBuggy.
  ///
  /// In en, this message translates to:
  /// **'Custom locations are extremely buggy due to issues with permissions. I\'m thinking of ways to fix this, but for now I wouldn\'t recommend using them.'**
  String get customLocationsBuggy;

  /// No description provided for @enterLowPriorityStateOnPause.
  ///
  /// In en, this message translates to:
  /// **'Enter Low-Priority State on Pause'**
  String get enterLowPriorityStateOnPause;

  /// No description provided for @enterLowPriorityStateOnPauseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lets the notification be swiped away when paused. Also allows Android to kill the service when paused.'**
  String get enterLowPriorityStateOnPauseSubtitle;

  /// No description provided for @shuffleAllSongCount.
  ///
  /// In en, this message translates to:
  /// **'Shuffle All Song Count'**
  String get shuffleAllSongCount;

  /// No description provided for @shuffleAllSongCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amount of songs to load when using the shuffle all songs button.'**
  String get shuffleAllSongCountSubtitle;

  /// No description provided for @viewType.
  ///
  /// In en, this message translates to:
  /// **'View Type'**
  String get viewType;

  /// No description provided for @viewTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View type for the music screen'**
  String get viewTypeSubtitle;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get grid;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// List tile title for grid cross axis count. Value will either be the portrait or landscape key.
  ///
  /// In en, this message translates to:
  /// **'{value} Grid Cross-Axis Count'**
  String gridCrossAxisCount(String value);

  /// List tile subtitle for grid cross axis count. Value will either be the portrait or landscape key.
  ///
  /// In en, this message translates to:
  /// **'Amount of grid tiles to use per-row when {value}.'**
  String gridCrossAxisCountSubtitle(String value);

  /// No description provided for @showTextOnGridView.
  ///
  /// In en, this message translates to:
  /// **'Show text in grid view'**
  String get showTextOnGridView;

  /// No description provided for @showTextOnGridViewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether or not to show the text (title, artist etc) on the grid music screen.'**
  String get showTextOnGridViewSubtitle;

  /// No description provided for @showCoverAsPlayerBackground.
  ///
  /// In en, this message translates to:
  /// **'Show blurred cover as player background'**
  String get showCoverAsPlayerBackground;

  /// No description provided for @showCoverAsPlayerBackgroundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether or not to use blurred cover art as background on player screen.'**
  String get showCoverAsPlayerBackgroundSubtitle;

  /// No description provided for @hideSongArtistsIfSameAsAlbumArtists.
  ///
  /// In en, this message translates to:
  /// **'Hide song artists if same as album artists'**
  String get hideSongArtistsIfSameAsAlbumArtists;

  /// No description provided for @hideSongArtistsIfSameAsAlbumArtistsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to show song artists on the album screen if not differing from album artists.'**
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle;

  /// No description provided for @disableGesture.
  ///
  /// In en, this message translates to:
  /// **'Disable gestures'**
  String get disableGesture;

  /// No description provided for @disableGestureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to disables gestures.'**
  String get disableGestureSubtitle;

  /// No description provided for @showFastScroller.
  ///
  /// In en, this message translates to:
  /// **'Show fast scroller'**
  String get showFastScroller;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @tabs.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// No description provided for @cancelSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Sleep Timer?'**
  String get cancelSleepTimer;

  /// No description provided for @yesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yesButtonLabel;

  /// No description provided for @noButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get noButtonLabel;

  /// No description provided for @setSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Set Sleep Timer'**
  String get setSleepTimer;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Number'**
  String get invalidNumber;

  /// No description provided for @sleepTimerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get sleepTimerTooltip;

  /// No description provided for @addToPlaylistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylistTooltip;

  /// No description provided for @addToPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylistTitle;

  /// No description provided for @removeFromPlaylistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylistTooltip;

  /// No description provided for @removeFromPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get removeFromPlaylistTitle;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get newPlaylist;

  /// No description provided for @createButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get createButtonLabel;

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created.'**
  String get playlistCreated;

  /// No description provided for @noAlbum.
  ///
  /// In en, this message translates to:
  /// **'No Album'**
  String get noAlbum;

  /// No description provided for @noItem.
  ///
  /// In en, this message translates to:
  /// **'No Item'**
  String get noItem;

  /// No description provided for @noArtist.
  ///
  /// In en, this message translates to:
  /// **'No Artist'**
  String get noArtist;

  /// No description provided for @unknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get unknownArtist;

  /// No description provided for @streaming.
  ///
  /// In en, this message translates to:
  /// **'STREAMING'**
  String get streaming;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOADED'**
  String get downloaded;

  /// No description provided for @transcode.
  ///
  /// In en, this message translates to:
  /// **'TRANSCODE'**
  String get transcode;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'DIRECT'**
  String get direct;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'STATUS ERROR'**
  String get statusError;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// Popup menu item title for adding an item to the end of the play queue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get addToQueue;

  /// Popup menu item title for inserting an item into the play queue after the currently-playing item.
  ///
  /// In en, this message translates to:
  /// **'Play Next'**
  String get playNext;

  /// No description provided for @replaceQueue.
  ///
  /// In en, this message translates to:
  /// **'Replace Queue'**
  String get replaceQueue;

  /// No description provided for @instantMix.
  ///
  /// In en, this message translates to:
  /// **'Instant Mix'**
  String get instantMix;

  /// No description provided for @goToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Go to Album'**
  String get goToAlbum;

  /// No description provided for @removeFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove Favourite'**
  String get removeFavourite;

  /// No description provided for @addFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add Favourite'**
  String get addFavourite;

  /// Snackbar message that shows when the user successfully adds items to the end of the play queue.
  ///
  /// In en, this message translates to:
  /// **'Added to queue.'**
  String get addedToQueue;

  /// Snackbar message that shows when the user successfully inserts items into the play queue at a location that is not necessarily the end.
  ///
  /// In en, this message translates to:
  /// **'Inserted into queue.'**
  String get insertedIntoQueue;

  /// No description provided for @queueReplaced.
  ///
  /// In en, this message translates to:
  /// **'Queue replaced.'**
  String get queueReplaced;

  /// No description provided for @removedFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Removed from playlist.'**
  String get removedFromPlaylist;

  /// No description provided for @startingInstantMix.
  ///
  /// In en, this message translates to:
  /// **'Starting instant mix.'**
  String get startingInstantMix;

  /// No description provided for @anErrorHasOccured.
  ///
  /// In en, this message translates to:
  /// **'An error has occured.'**
  String get anErrorHasOccured;

  /// No description provided for @responseError.
  ///
  /// In en, this message translates to:
  /// **'{error} Status code {statusCode}.'**
  String responseError(String error, int statusCode);

  /// No description provided for @responseError401.
  ///
  /// In en, this message translates to:
  /// **'{error} Status code {statusCode}. This probably means you used the wrong username/password, or your client is no longer logged in.'**
  String responseError401(String error, int statusCode);

  /// No description provided for @removeFromMix.
  ///
  /// In en, this message translates to:
  /// **'Remove From Mix'**
  String get removeFromMix;

  /// No description provided for @addToMix.
  ///
  /// In en, this message translates to:
  /// **'Add To Mix'**
  String get addToMix;

  /// No description provided for @redownloadedItems.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{No redownloads needed.} =1{Redownloaded {count} item} other{Redownloaded {count} items}}'**
  String redownloadedItems(int count);

  /// No description provided for @bufferDuration.
  ///
  /// In en, this message translates to:
  /// **'Buffer Duration'**
  String get bufferDuration;

  /// No description provided for @bufferDurationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How much the player should buffer, in seconds. Requires a restart.'**
  String get bufferDurationSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @showUncensoredLogMessage.
  ///
  /// In en, this message translates to:
  /// **'This log contains your login information. Show?'**
  String get showUncensoredLogMessage;

  /// No description provided for @resetTabs.
  ///
  /// In en, this message translates to:
  /// **'Reset tabs'**
  String get resetTabs;

  /// Title for message that shows on the views screen when no music libraries could be found.
  ///
  /// In en, this message translates to:
  /// **'No Music Libraries'**
  String get noMusicLibrariesTitle;

  /// No description provided for @noMusicLibrariesBody.
  ///
  /// In en, this message translates to:
  /// **'Finamp could not find any music libraries. Please ensure that your Jellyfin server contains at least one library with the content type set to \"Music\".'**
  String get noMusicLibrariesBody;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'REFRESH'**
  String get refresh;

  /// No description provided for @swipeInsertQueueNext.
  ///
  /// In en, this message translates to:
  /// **'Play Swiped Song Next'**
  String get swipeInsertQueueNext;

  /// No description provided for @swipeInsertQueueNextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to insert a song as next item in queue when swiped in song list instead of appending it to the end.'**
  String get swipeInsertQueueNextSubtitle;

  /// No description provided for @redesignBeta.
  ///
  /// In en, this message translates to:
  /// **'Try the Beta'**
  String get redesignBeta;

  /// No description provided for @playbackOrderShuffledTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shuffling. Tap to toggle.'**
  String get playbackOrderShuffledTooltip;

  /// No description provided for @playbackOrderLinearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Playing in order. Tap to toggle.'**
  String get playbackOrderLinearTooltip;

  /// No description provided for @loopModeAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'Looping all. Tap to toggle.'**
  String get loopModeAllTooltip;

  /// No description provided for @loopModeOneTooltip.
  ///
  /// In en, this message translates to:
  /// **'Looping one. Tap to toggle.'**
  String get loopModeOneTooltip;

  /// No description provided for @loopModeNoneTooltip.
  ///
  /// In en, this message translates to:
  /// **'Not looping. Tap to toggle.'**
  String get loopModeNoneTooltip;

  /// No description provided for @skipToPrevious.
  ///
  /// In en, this message translates to:
  /// **'Skip to Previous Song'**
  String get skipToPrevious;

  /// No description provided for @skipToNext.
  ///
  /// In en, this message translates to:
  /// **'Skip to Next Song'**
  String get skipToNext;

  /// No description provided for @togglePlayback.
  ///
  /// In en, this message translates to:
  /// **'Toggle Playback'**
  String get togglePlayback;

  /// No description provided for @playArtist.
  ///
  /// In en, this message translates to:
  /// **'Play all albums by {artist}'**
  String playArtist(String artist);

  /// No description provided for @shuffleArtist.
  ///
  /// In en, this message translates to:
  /// **'Shuffle all albums by {artist}'**
  String shuffleArtist(String artist);

  /// No description provided for @downloadArtist.
  ///
  /// In en, this message translates to:
  /// **'Download all albums by {artist}'**
  String downloadArtist(String artist);

  /// No description provided for @deleteFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete from Device'**
  String get deleteFromDevice;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Synchronize with Server'**
  String get sync;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Finamp'**
  String get about;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bg',
        'ca',
        'cs',
        'da',
        'de',
        'el',
        'en',
        'es',
        'et',
        'fi',
        'fr',
        'hr',
        'hu',
        'it',
        'ja',
        'ko',
        'nb',
        'nl',
        'pl',
        'pt',
        'ru',
        'sv',
        'sw',
        'szl',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script+country codes are specified.
  switch (locale.toString()) {
    case 'zh_Hant_HK':
      return AppLocalizationsZhHantHk();
  }

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'szl':
      return AppLocalizationsSzl();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
