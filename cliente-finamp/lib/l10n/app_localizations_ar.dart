// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String startupError(String error) {
    return '‐شيء خطأ حصل اثناء تفتيح التطبيك! الخطأ هو:$error\n\nاقتح تعليقةعلى <GitHub> في الموقع <github.com/UnicornsOnLSD/finamp> مع لقتة شاشة من هذا الصفحة. إذا هذا الخطأ يستمر, إمسح تخزين التطبيق.';
  }

  @override
  String get serverUrl => 'عنوان الخادم';

  @override
  String get internalExternalIpExplanation =>
      'إذا تريد ان توصل خدامة \"جلي فين\" من بعيد, يجيب ان تستعمل آي بي(IP) الخارجي.\n\nإذا خادمك يستعمل منافذ الويب(80 أو 443), لا يجب ان تحدد منفذ. هذه محتمل جدا إذا خادمك بستعمل\"Reverse proxy\".';

  @override
  String get emptyServerUrl => 'لا يمكن عنوان الخادم يكون فارغ';

  @override
  String get urlStartWithHttps =>
      'العنوان يجب ان يبدأ مع \"//:http\" أو \"//:https\"';

  @override
  String get urlTrailingSlash => 'العنوان لا يمكن ان ينهي مع \"/\"';

  @override
  String get username => 'اسم المستعمل';

  @override
  String get password => 'كلمة السرية';

  @override
  String get logs => 'السجلات';

  @override
  String get next => 'التالي';

  @override
  String get selectMusicLibraries => 'إختار مكاتب الأغاني';

  @override
  String get couldNotFindLibraries => 'لا يوجد أي مكتب.';

  @override
  String get unknownName => 'إسم غير معروف';

  @override
  String get songs => 'الأغاني';

  @override
  String get albums => 'ألبومات';

  @override
  String get artists => 'الفنانين';

  @override
  String get genres => 'التصنيفات';

  @override
  String get playlists => 'قوائم الأغاني';

  @override
  String get startMix => 'خلط فوري';

  @override
  String get startMixNoSongsArtist =>
      'إكبس طويل على البوم لتضيف أو تزيل هم من بناء الخلطة قبل ان تبدأ الخلطة';

  @override
  String get startMixNoSongsAlbum =>
      'إكبس طويل على البوم لتضيف أو تزيل ها من بناء الخلطة قبل ان تبدأ الخلطة';

  @override
  String get music => 'موسيقى';

  @override
  String get clear => 'إمسح';

  @override
  String get favourites => 'مفضلات';

  @override
  String get shuffleAll => 'استماع عشوائي للكل';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'التنزيلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get offlineMode => 'موضع غير الإتصال';

  @override
  String get sortOrder => 'ترتيب الفرز';

  @override
  String get sortBy => 'فرز';

  @override
  String get album => 'ألبوم';

  @override
  String get albumArtist => 'فنان الألبوم';

  @override
  String get artist => 'الفنان';

  @override
  String get budget => 'ميزنية';

  @override
  String get communityRating => 'تقييم الجمهور';

  @override
  String get criticRating => 'تقييم النقاد';

  @override
  String get dateAdded => 'تاريخ الإضافة';

  @override
  String get datePlayed => 'تاريخ استماع';

  @override
  String get playCount => 'عدد الاستمعات';

  @override
  String get premiereDate => 'تاريخ عرض الأول';

  @override
  String get productionYear => 'سنة الإنتاج';

  @override
  String get name => 'إسم';

  @override
  String get random => 'عشوائي';

  @override
  String get revenue => 'إيرادات';

  @override
  String get runtime => 'وقت تشغيل';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'نزل صور المفقودة';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' تم تنزيل $count صور المفقودة',
      one: 'تم تنزيل $count صورة مفقودة',
      zero: 'لا يوجد صور مفقودة',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'اخطأ التنزيل';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنزيلات',
      one: '$count تنزيل',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بنود',
      one: '$count بند',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صور',
      one: '$count صورة',
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
    return '$count متكمل';
  }

  @override
  String dlFailed(int count) {
    return '$count فشل';
  }

  @override
  String dlEnqueued(int count) {
    return '$count ينتضر النزيل';
  }

  @override
  String dlRunning(int count) {
    return '$count يتم تنزيل الآن';
  }

  @override
  String get downloadErrorsTitle => 'اخطأ التنزيل';

  @override
  String get noErrors => 'لا يوجد اخطأ!';

  @override
  String get errorScreenError =>
      'حدث خطأ اثناء حصول على قائمة الأخطأ! في هذه المرحلة ربما يجب عليك ان تفتح تعليقة على <‎GitHub> و تمسح تخزين التطبيق';

  @override
  String get failedToGetSongFromDownloadId =>
      'فشل ان يجد الاغنية من رقم التنزيل';

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
  String get error => 'خطأ';

  @override
  String discNumber(int number) {
    return 'القرس $number';
  }

  @override
  String get playButtonLabel => 'استمع';

  @override
  String get shuffleButtonLabel => 'استمع عشوائياً';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أغاني',
      one: '$count أغتية',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'غير اسم قائمة الأغاني';

  @override
  String get editPlaylistNameTitle => 'غير اسم قائمة الأغاني';

  @override
  String get required => 'ملزوم';

  @override
  String get updateButtonLabel => 'تحديث';

  @override
  String get playlistNameUpdated => 'تم تحديث إسم قائمة الأغاني.';

  @override
  String get favourite => 'المفضل';

  @override
  String get downloadsDeleted => 'تم إزالة التنزيلات';

  @override
  String get addDownloads => 'إضافة تنزيلات';

  @override
  String get location => 'موقع';

  @override
  String get downloadsAdded => 'تم اضافة التنزيلات';

  @override
  String get addButtonLabel => 'إضافة';

  @override
  String get shareLogs => 'شارك السجلات';

  @override
  String get logsCopied => 'تم نسخ السجلات.';

  @override
  String get message => 'رسالة';

  @override
  String get stackTrace => 'إشارة تراكمية';

  @override
  String get applicationLegalese =>
      'مرخص مع رخصة موزيلا العمومية <Mozilla Public License 2.0>. الشريفة توجد على:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'تحويل';

  @override
  String get downloadLocations => 'مواقع التنزيل';

  @override
  String get audioService => 'خدمة الصوت';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'تخطيط و ظاهرة';

  @override
  String get notAvailableInOfflineMode => 'عير متوفر في وضع غير الإتصال';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get downloadedSongsWillNotBeDeleted => 'لن تزيل لأغني التي تم تنزيله';

  @override
  String get areYouSure => 'هل انت متأكد؟';

  @override
  String get jellyfinUsesAACForTranscoding =>
      '\"جلي فين\" يستعمل مشفر <AAC> للتحويل';

  @override
  String get enableTranscoding => 'تمكين التحويل';

  @override
  String get enableTranscodingSubtitle =>
      'إذا ممكن, بث الموسيقى سايتحول من الخادم';

  @override
  String get bitrate => 'معدل البتات';

  @override
  String get bitrateSubtitle =>
      'معدل بتات اعلى يعطي جودة صوت أحسن واكن يستعمل اكثر بيانات.';

  @override
  String get customLocation => 'موقع مخصص';

  @override
  String get appDirectory => 'مجلّد التطبيق';

  @override
  String get addDownloadLocation => 'إضافة مكان التنزيل';

  @override
  String get selectDirectory => 'إختار المجلد';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get pathReturnSlashErrorMessage =>
      'مسارات التي ترجع \"/\" لا يمكن ان تستعمل';

  @override
  String get directoryMustBeEmpty => 'المجلد يجب ان يكون فارغ';

  @override
  String get customLocationsBuggy =>
      'المواقع المخصصة عرضة للأخطأ لأن يوجد مشاكل مع الأذونات. أنا أحوال إصلاحه, و لكن لا أنصح ان تستغدمه.';

  @override
  String get enterLowPriorityStateOnPause =>
      'تشغيل وضع <low-priority state> عندما توقف استماع مؤقتاً';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'إذا ممكن، يمكن ان تمسح الإعلام عنمدا توقف مؤقتاً للاستماع. و يمكن \"اندرويد\" ان يقتل الخدمة.';

  @override
  String get shuffleAllSongCount => 'استماع عشوائي لعدد الأغاني';

  @override
  String get shuffleAllSongCountSubtitle =>
      'عدد الأغاني التي تحمل عندما تستعمل كبسة \"استماع عشوائ لكل الأغاني\".';

  @override
  String get viewType => 'نوع العرض';

  @override
  String get viewTypeSubtitle => 'نوع عرض لصفة الموسيقى';

  @override
  String get list => 'قائمة';

  @override
  String get grid => 'شبكة';

  @override
  String get portrait => 'عمودي';

  @override
  String get landscape => 'اقفي';

  @override
  String gridCrossAxisCount(String value) {
    return 'عدد محور معامد في عرض $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'كم مربعات تستعمل لكل صف عندما الشاشة تكون $value.';
  }

  @override
  String get showTextOnGridView => 'أظهر كلمات على عرض الشبك';

  @override
  String get showTextOnGridViewSubtitle =>
      'سواء ان تظهر كلمات  [الإسم، الفنان، أو الباقي] على صفحة الموسيقى التي تستعمل عرض الشبكي.';

  @override
  String get showCoverAsPlayerBackground =>
      'أظهر مخلاف البوم غائم على مشغل الموسيقى';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'سواء ان تستعمل مخلاف البوم غائم على مشغل الموسيقى.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'إخفاء أسماء فنانين اﻷغنية إذا هن نفس أسماء فنانين الأابوم';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'سواء ان تخفي فنانين الأغنية من صفحة الألبوم إذا يختلف من فنانين الألبوم.';

  @override
  String get disableGesture => 'Disable gestures';

  @override
  String get disableGestureSubtitle => 'Whether to disables gestures.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'الألوان التطبيق';

  @override
  String get system => 'نظام';

  @override
  String get light => 'ابيض';

  @override
  String get dark => 'غامق';

  @override
  String get tabs => 'التبويبات';

  @override
  String get cancelSleepTimer => 'هل تريد ان تلغي مؤقت النوم؟';

  @override
  String get yesButtonLabel => 'نعم';

  @override
  String get noButtonLabel => 'ﻷ';

  @override
  String get setSleepTimer => 'حدد مؤقت النوم';

  @override
  String get minutes => 'دقائق';

  @override
  String get invalidNumber => 'رقم خاطىء';

  @override
  String get sleepTimerTooltip => 'مؤقت النوم';

  @override
  String get addToPlaylistTooltip => 'إضافة إلى قائمة اغاني';

  @override
  String get addToPlaylistTitle => 'إضافة إلى قائمة اغاني';

  @override
  String get removeFromPlaylistTooltip => 'إزالة من قائمة الأغاني';

  @override
  String get removeFromPlaylistTitle => 'إزالة من قائمة الأغاني';

  @override
  String get newPlaylist => 'قائمة اغاني جديد';

  @override
  String get createButtonLabel => 'إنشاء';

  @override
  String get playlistCreated => 'تم إنشاء قائمة الأغاني.';

  @override
  String get noAlbum => 'بدون البوم';

  @override
  String get noItem => 'لا يوجد بند';

  @override
  String get noArtist => 'بدون فنان';

  @override
  String get unknownArtist => 'فنان غير معروف';

  @override
  String get streaming => 'بث';

  @override
  String get downloaded => 'نزلت';

  @override
  String get transcode => 'تحويل';

  @override
  String get direct => 'مباشر';

  @override
  String get statusError => 'خطأ حالة';

  @override
  String get queue => 'قائمة الإنتظار';

  @override
  String get addToQueue => 'إضافة إلى قائمة الانتظار';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'تبديل قائمة الإنتظار';

  @override
  String get instantMix => 'خلط فوري';

  @override
  String get goToAlbum => 'إذهب إلى الألبوم';

  @override
  String get removeFavourite => 'إزالة من المفضلات';

  @override
  String get addFavourite => 'إضافة إلى المفضلات';

  @override
  String get addedToQueue => 'تم إضافة إالى قائمة الانتظار';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'تم تبديل قائمة الإنتظار.';

  @override
  String get removedFromPlaylist => 'تمت الإزالة من قائمة الأغاني.';

  @override
  String get startingInstantMix => 'ابتداء خلط فوري.';

  @override
  String get anErrorHasOccured => 'حدث خطأ.';

  @override
  String responseError(String error, int statusCode) {
    return '$error رمز الخطأ $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error رمز الخطأ $statusCode. ربما يعني ان استخدمت الإسم أو الكامة السرية الخاطئة, أو عميلك لا يعد موثوق.';
  }

  @override
  String get removeFromMix => 'إزالة من الخلطة';

  @override
  String get addToMix => 'إضافة إالى الخلطة';

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
  String get language => 'اللغة';

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
