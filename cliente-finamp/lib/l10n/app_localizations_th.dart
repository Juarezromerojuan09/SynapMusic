// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String startupError(String error) {
    return 'พบข้อผิดพลาดขณะเริ่มต้นแอป ข้อผิดพลาด: $error\n\nโปรดสร้าง Issue บน github.com/UnicornsOnLSD/finamp พร้อมแนบภาพหน้าจอของหน้านี้ หากปัญหานี้ยังคงเป็นอยู่ให้ลองเคลียร์ข้อมูลของแอปเพื่อรีเซ็ต';
  }

  @override
  String get serverUrl => 'URL ของเซิร์ฟเวอร์';

  @override
  String get internalExternalIpExplanation =>
      'หากคุณต้องการเข้าถึงเซิร์ฟเวอร์ Jellyfin จากภายนอก คุณจำเป็นต้องมี IP ภายนอก\n\nหากเซิร์ฟเวอร์ของคุณรันบนพอร์ต HTTP (80/443) คุณไม่จำเป็นต้องระบุพอร์ต ในเคสนี้เซิร์ฟเวอร์ของคุณอาจจะอยู่หลัง Reverse Proxy';

  @override
  String get emptyServerUrl => 'จำเป็นต้องระบุ URL ของเซิร์ฟเวอร์';

  @override
  String get urlStartWithHttps => 'URL ต้องขึ้นต้นด้วย http:// หรือ https://';

  @override
  String get urlTrailingSlash => 'URL ต้องไม่มีเครื่องหมาย / ต่อหลัง';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get logs => 'ล็อก';

  @override
  String get next => 'ถัดไป';

  @override
  String get selectMusicLibraries => 'เลือกคลังเพลง';

  @override
  String get couldNotFindLibraries => 'ไม่พบคลังใดๆ';

  @override
  String get unknownName => 'ไม่รู้จักชื่อ';

  @override
  String get songs => 'เพลง';

  @override
  String get albums => 'อัลบั้ม';

  @override
  String get artists => 'ศิลปิน';

  @override
  String get genres => 'แนวเพลง';

  @override
  String get playlists => 'เพลย์ลิสต์';

  @override
  String get startMix => 'เริ่มมิกซ์';

  @override
  String get startMixNoSongsArtist =>
      'แตะค้างที่ศิลปินเพื่อเพิ่มหรือนำออกจากตัวสร้างมิกซ์ก่อนที่จะเริ่มมิกซ์';

  @override
  String get startMixNoSongsAlbum =>
      'แตะค้างที่อัลบั้มเพื่อเพิ่มหรือนำออกจากตัวสร้างมิกซ์ก่อนที่จะเริ่มมิกซ์';

  @override
  String get music => 'เพลง';

  @override
  String get clear => 'เคลียร์';

  @override
  String get favourites => 'รายการโปรด';

  @override
  String get shuffleAll => 'สุ่มทั้งหมด';

  @override
  String get finamp => 'ฟินแอมป์';

  @override
  String get downloads => 'ดาวน์โหลด';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get offlineMode => 'โหมดออฟไลน์';

  @override
  String get sortOrder => 'เรียงลำดับ';

  @override
  String get sortBy => 'เรียงด้วย';

  @override
  String get album => 'อัลบั้ม';

  @override
  String get albumArtist => 'ศิลปินของอัลบั้ม';

  @override
  String get artist => 'ศิลปิน';

  @override
  String get budget => 'งบ';

  @override
  String get communityRating => 'เรตติ้งจากชุมชน';

  @override
  String get criticRating => 'เรตติ้งจาก Critic';

  @override
  String get dateAdded => 'วันที่เพิ่ม';

  @override
  String get datePlayed => 'วันที่เล่น';

  @override
  String get playCount => 'จำนวนครั้งที่เล่น';

  @override
  String get premiereDate => 'วันที่เปิดตัว';

  @override
  String get productionYear => 'ปีที่สร้าง';

  @override
  String get name => 'ชื่อ';

  @override
  String get random => 'สุ่ม';

  @override
  String get revenue => 'รายได้';

  @override
  String get runtime => 'เวลา';

  @override
  String get syncDownloadedPlaylists => 'ซิงก์เพลลิสต์ที่ดาวน์โหลดแล้ว';

  @override
  String get downloadMissingImages => 'ดาวน์โหลดไฟล์ภาพที่ขาด';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ดาวน์โหลดภาพที่ขาดแล้ว $count รูป',
      one: 'ดาวน์โหลดภาพที่ขาดแล้ว $count รูป',
      zero: 'ไม่มีภาพที่ขาด',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'ข้อผิดพลาดการดาวน์โหลด';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ดาวน์โหลดแล้ว $count',
      one: 'ดาวน์โหลดแล้ว $count',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count รายการ',
      one: '$count รายการ',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count รูป',
      one: '$count รูป',
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
    return 'เสร็จแล้ว $count';
  }

  @override
  String dlFailed(int count) {
    return 'ล้มเหลว $count';
  }

  @override
  String dlEnqueued(int count) {
    return 'เข้าคิว $count';
  }

  @override
  String dlRunning(int count) {
    return 'กำลังทำงาน $count';
  }

  @override
  String get downloadErrorsTitle => 'ข้อผิดพลาดในการดาวน์โหลด';

  @override
  String get noErrors => 'ไม่มีข้อผิดพลาด!';

  @override
  String get errorScreenError =>
      'พบข้อผิดพลาดในการดึงรายการข้อผิดพลาด! ถ้าถึงขั้นนี้แล้ว คุณน่าจะต้องไปสร้าง Issue บน Github แล้วลบข้อมูลแอปทิ้งซะ';

  @override
  String get failedToGetSongFromDownloadId =>
      'ล้มเหลวในการเรียกข้อมูลเพลงจากไอดีสำหรับดาวน์โหลด';

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
    return 'แน่ใจหรือไม่ว่าต้องการลบ $_temp0 \'$itemName\' จากเครื่องนี้?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'ลบ';

  @override
  String get deleteDownloadsAbortButtonText => 'ยกเลิก';

  @override
  String get error => 'ผิดพลาด';

  @override
  String discNumber(int number) {
    return 'แผ่นที่ $number';
  }

  @override
  String get playButtonLabel => 'เล่น';

  @override
  String get shuffleButtonLabel => 'สุ่ม';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เพลง',
      one: '$count เพลง',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'แก้ไขชื่อเพลย์ลิสต์';

  @override
  String get editPlaylistNameTitle => 'แก้ไขชื่อเพลย์ลิสต์';

  @override
  String get required => 'จำเป็น';

  @override
  String get updateButtonLabel => 'อัปเดต';

  @override
  String get playlistNameUpdated => 'อัปเดตชื่อเพลย์ลิสต์แล้ว';

  @override
  String get favourite => 'รายการโปรด';

  @override
  String get downloadsDeleted => 'ลบการดาวน์โหลดแล้ว';

  @override
  String get addDownloads => 'เพิ่มการดาวน์โหลด';

  @override
  String get location => 'สถานที่';

  @override
  String get downloadsAdded => 'เพิ่มการดาวน์โหลดแล้ว';

  @override
  String get addButtonLabel => 'เพิ่ม';

  @override
  String get shareLogs => 'แชร์ล็อก';

  @override
  String get logsCopied => 'คัดลอกล็อกแล้ว';

  @override
  String get message => 'ข้อความ';

  @override
  String get stackTrace => 'ตามรอย';

  @override
  String get applicationLegalese =>
      'สงวนลิขสิทธิ์โดย Mozilla Public License 2.0 สามารถดาวน์โหลด Source Code ได้ที่:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'การแปลงไฟล์';

  @override
  String get downloadLocations => 'ตำแหน่งที่ดาวน์โหลด';

  @override
  String get audioService => 'บริการเสียง';

  @override
  String get interactions => 'การกระทำ';

  @override
  String get layoutAndTheme => 'หน้าตา และ ธีม';

  @override
  String get notAvailableInOfflineMode => 'ไม่พร้อมใช้งานในโหมดออฟไลน์';

  @override
  String get logOut => 'ออกจากระบบ';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'เพลงที่ดาวน์โหลดแล้วจะไม่ถูกลบ';

  @override
  String get areYouSure => 'แน่ใจหรือไม่?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin ใช้รหัส AAC สำหรับการแปลงไฟล์';

  @override
  String get enableTranscoding => 'เปิดใช้งานการแปลงไฟล์';

  @override
  String get enableTranscodingSubtitle =>
      'การแปลงไฟล์เพลงจะถูกดำเนินการจากฝั่งเซิร์ฟเวอร์';

  @override
  String get bitrate => 'บิทเรต';

  @override
  String get bitrateSubtitle =>
      'บิตเรตที่สูงขึ้นจะช่วยให้เสียงดีขึ้นแต่ก็แลกมาด้วยการใช้งานเน็ตเวิร์กที่มากขึ้น';

  @override
  String get customLocation => 'ตำแหน่งแบบเลือกเอง';

  @override
  String get appDirectory => 'โฟลเดอร์ของแอป';

  @override
  String get addDownloadLocation => 'เพิ่มตำแหน่งสำหรับดาวน์โหลด';

  @override
  String get selectDirectory => 'เลือกโฟลเดอร์';

  @override
  String get unknownError => 'ข้อผิดพลาดที่ไม่รู้จัก';

  @override
  String get pathReturnSlashErrorMessage =>
      'ตำแหน่งที่ได้ \"/\" ไม่สามารถใช้ได้';

  @override
  String get directoryMustBeEmpty => 'โฟลเดอร์นั้นต้องว่าง';

  @override
  String get customLocationsBuggy =>
      'ตำแหน่งแบบเลือกเองนั้นค่อนข้างไม่สเถียรเนื่องจากปัญหาด้านสิทธิ์ ตอนนี้ยังหาวิธีแก้เรื่องนี้อยู่ ทางที่ดีตอนนี้ไม่ค่อยแนะนำให้ใช้ฟีเจอร์นี้';

  @override
  String get enterLowPriorityStateOnPause =>
      'เมื่อหยุดพักจะเข้าสู่โหมดความสำคัญต่ำ';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'ให้แถบแจ้งเตือนสามารถปัดทิ้งไปได้เมื่อหยุดชั่วคราว รวมถึงให้แอนดรอยสามารถปิดเซอร์วิสนี้ได้เมื่อหยุดชั่วคราว';

  @override
  String get shuffleAllSongCount => 'จำนวนครั้งที่สุ่มเพลงทั้งหมด';

  @override
  String get shuffleAllSongCountSubtitle =>
      'จำนวนเพลงที่โหลดขึ้นมาเมื่อใช้ปุ่ม สุ่มทั้งหมด';

  @override
  String get viewType => 'ประเภทการแสดงผล';

  @override
  String get viewTypeSubtitle => 'ประเภทการแสดงผลของหน้าจอเพลง';

  @override
  String get list => 'รายการ';

  @override
  String get grid => 'ตาราง';

  @override
  String get portrait => 'แนวตั้ง';

  @override
  String get landscape => 'แนวนอน';

  @override
  String gridCrossAxisCount(String value) {
    return 'จำนวนรายการใน $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'จำนวนของไอเท็มในตารางต่อแถวของ $value';
  }

  @override
  String get showTextOnGridView => 'แสดงตัวอักษรในโหมดตาราง';

  @override
  String get showTextOnGridViewSubtitle =>
      'แสดงหรือไม่แสดงข้อความ (ชื่อเพลง, ศิลปิน, อื่น ๆ) บนตารางแสดงเพลง';

  @override
  String get showCoverAsPlayerBackground =>
      'แสดงภาพเบลอของปกเพลงเป็นภาพพื้นหลังของตัวเล่นเพลง';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'แสดงหรือไม่แสดงภาพเบลอของปกเพลงเป็นพื้นหลังของตัวเล่นเพลง';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'ซ่อนศิลปินของเพลงหากเป็นชื่อเดียวกับศิลปินของอัลบั้ม';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'แสดงหรือไม่แสดงชื่อศิลปินเพลงบนหน้าจออัลบั้มหากทั้งสองชื่อไม่ต่างกัน';

  @override
  String get disableGesture => 'ปิดการใช้งาน gestures';

  @override
  String get disableGestureSubtitle => 'ใช้หรือไม่ใช้งาน gestures';

  @override
  String get showFastScroller => 'แสดงตัวเลื่อนแบบเร็ว';

  @override
  String get theme => 'ธีม';

  @override
  String get system => 'ตามระบบ';

  @override
  String get light => 'สว่าง';

  @override
  String get dark => 'มืด';

  @override
  String get tabs => 'แท็บ';

  @override
  String get cancelSleepTimer => 'ยกเลิกการตั้งเวลาปิด?';

  @override
  String get yesButtonLabel => 'ใช่';

  @override
  String get noButtonLabel => 'ไม่ใช่';

  @override
  String get setSleepTimer => 'ตั้งเวลาปิด';

  @override
  String get minutes => 'นาที';

  @override
  String get invalidNumber => 'ตัวเลขไม่ถูกต้อง';

  @override
  String get sleepTimerTooltip => 'ตั้งเวลาปิด';

  @override
  String get addToPlaylistTooltip => 'เพิ่มไปยังเพลย์ลิสต์';

  @override
  String get addToPlaylistTitle => 'เพิ่มไปยังเพลย์ลิสต์';

  @override
  String get removeFromPlaylistTooltip => 'นำออกจากเพลย์ลิสต์';

  @override
  String get removeFromPlaylistTitle => 'นำออกจากเพลย์ลิสต์';

  @override
  String get newPlaylist => 'สร้างเพลย์ลิสต์ใหม่';

  @override
  String get createButtonLabel => 'สร้าง';

  @override
  String get playlistCreated => 'สร้างเพลย์ลิสต์แล้ว';

  @override
  String get noAlbum => 'ไม่มีอัลบั้ม';

  @override
  String get noItem => 'ไม่มีรายการ';

  @override
  String get noArtist => 'ไม่มีศิลปิน';

  @override
  String get unknownArtist => 'ศิลปินที่ไม่รู้จัก';

  @override
  String get streaming => 'กำลังสตรีม';

  @override
  String get downloaded => 'ดาวน์โหลดแล้ว';

  @override
  String get transcode => 'แปลงไฟล์';

  @override
  String get direct => 'โดยตรง';

  @override
  String get statusError => 'สถานะผิดพลาด';

  @override
  String get queue => 'คิว';

  @override
  String get addToQueue => 'เพิ่มไปยังคิว';

  @override
  String get playNext => 'เล่นถัดไป';

  @override
  String get replaceQueue => 'แทนที่คิว';

  @override
  String get instantMix => 'มิกซ์ทันที';

  @override
  String get goToAlbum => 'ไปยังอัลบั้ม';

  @override
  String get removeFavourite => 'นำออกจากรายการโปรด';

  @override
  String get addFavourite => 'เพิ่มไปยังรายการโปรด';

  @override
  String get addedToQueue => 'เพิ่มลงคิวแล้ว';

  @override
  String get insertedIntoQueue => 'แทรกไปยังคิว';

  @override
  String get queueReplaced => 'คิวถูกแทนที่แล้ว';

  @override
  String get removedFromPlaylist => 'นำออกจากเพลย์ลิสต์แล้ว';

  @override
  String get startingInstantMix => 'กำลังเริ่มมิกซ์ทันที';

  @override
  String get anErrorHasOccured => 'พบข้อผิดพลาด';

  @override
  String responseError(String error, int statusCode) {
    return '$error รหัสข้อผิดพลาด $statusCode';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error รหัสข้อผิดพลาด $statusCode เป็นไปได้ว่าคุณอาจจะใช้ ชื่อผู้ใช้หรือรหัสผ่านที่ไม่ถูกต้อง หรือตัวโปรแกรมไม่ได้อยู่ในสถานะล็อกอินแล้ว';
  }

  @override
  String get removeFromMix => 'นำออกจากมิกซ์';

  @override
  String get addToMix => 'เพิ่มไปยังมิกซ์';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ดาวน์โหลดอีกครั้ง$count รายการ',
      one: 'ดาวน์โหลดอีกครั้ง $count รายการ',
      zero: 'ไม่จำเป็นต้องดาวน์โหลดใหม่',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'ระยะเวลาที่บัฟเฟอร์';

  @override
  String get bufferDurationSubtitle =>
      'ตัวเล่นเพลงควรจะอ่านไฟล์ล่วงหน้าเท่าไร ระบุเป็นวินาที หากเปลี่ยนต้องรีสตาร์ท';

  @override
  String get language => 'ภาษา';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get showUncensoredLogMessage =>
      'ล็อกนี้มีข้อมูลการล็อกอินของคุณอยู่ ต้องการให้แสดงใช่ไหม?';

  @override
  String get resetTabs => 'รีเซ็ตการตั้งค่าแท็ป';

  @override
  String get noMusicLibrariesTitle => 'ไม่มีคลังเพลง';

  @override
  String get noMusicLibrariesBody =>
      'ฟินแอมป์ไม่พบคลังเพลงใดเลย โปรดตรวจสอบว่าเซิร์ฟเวอร์ของ Jellyfin นั้นมีอย่างน้อยหนึ่งคลังที่ตั้งประเภทของคอนเทนต์ไว้เป็น \"Music\"';

  @override
  String get refresh => 'รีเฟชร';

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
