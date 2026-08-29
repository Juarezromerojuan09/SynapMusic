// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String startupError(String error) {
    return 'Đã xảy ra lỗi khi khởi động ứng dụng. Lỗi: $error\n\nXin hãy tạo một Issue trên github.com/UnicornsOnLSD/finamp với ảnh chụp màn hình của trang này. Nếu vấn đề tái diễn bạn có thể dọn dữ liệu ứng dụng để thiết lập lại ứng dụng.';
  }

  @override
  String get serverUrl => 'URL của Máy chủ';

  @override
  String get internalExternalIpExplanation =>
      'Nếu bạn muốn truy cập máy chủ Jellyfin từ xa, bạn cần phải dùng địa chỉ IP bên ngoài.\n\nNếu máy chủ của bạn đang mở cổng HTTP (cổng 80/443), bạn không cần phải chỉ rõ cổng. Đây có thể do máy chủ của bạn được set Proxy ngược.';

  @override
  String get emptyServerUrl => 'URL của máy chủ không thể để trống';

  @override
  String get urlStartWithHttps => 'URL phải bắt đầu bằng http:// hoặc https://';

  @override
  String get urlTrailingSlash => 'URL không được có dấu gạch chéo';

  @override
  String get username => 'Tên người dùng';

  @override
  String get password => 'Mật khẩu';

  @override
  String get logs => 'Nhật kí hoạt động';

  @override
  String get next => 'Tiếp theo';

  @override
  String get selectMusicLibraries => 'Chọn Thư viện Nhạc';

  @override
  String get couldNotFindLibraries => 'Không thể tìm thấy bất kì thư viện nào.';

  @override
  String get unknownName => 'Không có tên';

  @override
  String get songs => 'Bài hát';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Nghệ sĩ';

  @override
  String get genres => 'Thể loại';

  @override
  String get playlists => 'Danh sách phát';

  @override
  String get startMix => 'Bắt đầu Mix';

  @override
  String get startMixNoSongsArtist =>
      'Bấm giữ một nghệ sĩ để thêm hoặc loại bỏ ra khỏi bộ Mix trước khi bắt đầu một tuyển tập Mix';

  @override
  String get startMixNoSongsAlbum =>
      'Bấm giữ một Album để thêm hoặc loại bỏ ra khỏi bộ Mix trước khi bắt đầu một tuyển tập Mix';

  @override
  String get music => 'Nhạc';

  @override
  String get clear => 'Loại bỏ';

  @override
  String get favourites => 'Yêu thích';

  @override
  String get shuffleAll => 'Trộn hết';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Tải xuống';

  @override
  String get settings => 'Cài đặt';

  @override
  String get offlineMode => 'Chế độ ngoại tuyến';

  @override
  String get sortOrder => 'Sắp thứ tự';

  @override
  String get sortBy => 'Sắp theo';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album Nghệ Sĩ';

  @override
  String get artist => 'Nghệ sĩ';

  @override
  String get budget => 'Chi phí';

  @override
  String get communityRating => 'Đánh giá cộng đồng';

  @override
  String get criticRating => 'Đánh giá nhà phê bình';

  @override
  String get dateAdded => 'Ngày được thêm';

  @override
  String get datePlayed => 'Ngày phát';

  @override
  String get playCount => 'Số lần phát';

  @override
  String get premiereDate => 'Ngày phát hành';

  @override
  String get productionYear => 'Năm sản xuất';

  @override
  String get name => 'Tên';

  @override
  String get random => 'Ngẫu nhiên';

  @override
  String get revenue => 'Lợi nhuận';

  @override
  String get runtime => 'Thời gian phát';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Tải ảnh thiếu';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tải $count ảnh thiếu',
      one: 'Đã tải $count ảnh thiếu',
      zero: 'Không ảnh thiếu được tìm',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Lỗi tải';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count đang tải xuống',
      one: '$count đang tải xuống',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vật',
      one: '$count vật',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ảnh',
      one: '$count ảnh',
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
    return '$count đã hoàn thành';
  }

  @override
  String dlFailed(int count) {
    return '$count thất bại';
  }

  @override
  String dlEnqueued(int count) {
    return '$count đang hàng đợi';
  }

  @override
  String dlRunning(int count) {
    return '$count đang chạy';
  }

  @override
  String get downloadErrorsTitle => 'Lỗi tải xuống';

  @override
  String get noErrors => 'Không có lỗi!';

  @override
  String get errorScreenError =>
      'Đã có lỗi xảy ra khi lấy danh sách lỗi! Bạn nên tạo một Issue trên trang Github và xoá dữ liệu ứng dụng';

  @override
  String get failedToGetSongFromDownloadId => 'Lấy bài hát từ ID tải Thất Bại';

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
  String get error => 'Lỗi';

  @override
  String discNumber(int number) {
    return 'Đĩa $number';
  }

  @override
  String get playButtonLabel => 'PHÁT';

  @override
  String get shuffleButtonLabel => 'XÁO TRỘN';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bài hát',
      one: '$count bài hát',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Chỉnh sửa tên danh sách phát';

  @override
  String get editPlaylistNameTitle => 'Chỉnh sửa Tên Danh sách phát';

  @override
  String get required => 'Được yêu cầu';

  @override
  String get updateButtonLabel => 'CẬP NHẬT';

  @override
  String get playlistNameUpdated => 'Tên danh sách phát đã được cập nhật.';

  @override
  String get favourite => 'Yêu thích';

  @override
  String get downloadsDeleted => 'Đã xóa tải xuống.';

  @override
  String get addDownloads => 'Thêm tải xuống';

  @override
  String get location => 'Vị trí';

  @override
  String get downloadsAdded => 'Đã thêm tải xuống.';

  @override
  String get addButtonLabel => 'THÊM';

  @override
  String get shareLogs => 'Chia sẻ bản ghi';

  @override
  String get logsCopied => 'Đã sao chép bản ghi.';

  @override
  String get message => 'Tin nhắn';

  @override
  String get stackTrace => 'Dấu vết Ngăn xếp';

  @override
  String get applicationLegalese =>
      'Được cấp giấy phép Mozilla Public License 2.0. Mã nguồn tại:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Chuyển Mã';

  @override
  String get downloadLocations => 'Vị trí tải xuống';

  @override
  String get audioService => 'Dịch vụ âm thanh';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Bố cục & Chủ đề';

  @override
  String get notAvailableInOfflineMode => 'Không khả dụng ở chế độ ngoại tuyến';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Các bài hát được tải xuống sẽ không bị xoá';

  @override
  String get areYouSure => 'Bạn chắc chứ?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin dùng codec AAC để chuyển đổi';

  @override
  String get enableTranscoding => 'Bật chuyển đổi';

  @override
  String get enableTranscodingSubtitle =>
      'Chuyển đổi các luồng truyền phát nhạc trên phía máy chủ.';

  @override
  String get bitrate => 'Tốc độ bit';

  @override
  String get bitrateSubtitle =>
      'Một tốc độ bit cao hơn mang lại âm thanh tốt hơn trong khi dùng băng thông lớn hơn.';

  @override
  String get customLocation => 'Vị trí tuỳ chỉnh';

  @override
  String get appDirectory => 'Đường dẫn ứng dụng';

  @override
  String get addDownloadLocation => 'Thêm đường dẫn tải xuống';

  @override
  String get selectDirectory => 'Chọn đường dẫn';

  @override
  String get unknownError => 'Lỗi không xác định';

  @override
  String get pathReturnSlashErrorMessage =>
      'Đường dẫn mà trả về \"/\" không dùng được';

  @override
  String get directoryMustBeEmpty => 'Đường dẫn phải trống';

  @override
  String get customLocationsBuggy =>
      'Vị trí tùy chỉnh khá nhiều lỗi do lỗi với việc cấp quyền. Tôi đang tìm biện pháp để sửa, hiện tại tôi không khuyến khích dùng chúng.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Vào trạng thái Ưu Tiên Thấp khi Dừng';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Để thông báo được gạt đi khi dừng. Ngoài ra cho phép Android tắt dịch vụ khi dừng.';

  @override
  String get shuffleAllSongCount => 'Trộn tất cả bài hát';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Số lượng bài hát được tải khi dùng nút trộn tất cả bài hát.';

  @override
  String get viewType => 'Loại Xem';

  @override
  String get viewTypeSubtitle => 'Loại xem cho màn hình nhạc';

  @override
  String get list => 'Danh sách';

  @override
  String get grid => 'Lưới';

  @override
  String get portrait => 'Dọc';

  @override
  String get landscape => 'Ngang';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Số Lưới Trục-Chéo';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Số lượng lưới dùng mỗi hàng khi $value.';
  }

  @override
  String get showTextOnGridView => 'Hiện thông tin trong khung lưới';

  @override
  String get showTextOnGridViewSubtitle =>
      'Cho dù có hay không hiện thông tin (tiêu đề, nghệ sĩ,...) trên lưới nhạc.';

  @override
  String get showCoverAsPlayerBackground =>
      'Dùng ảnh bìa mờ làm nền trình phát';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Có hay không dùng ảnh bìa mờ làm nền trình phát trên phần phát nhạc.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Ẩn tên ca sĩ bài hát nếu giống ca sĩ album';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Có hay không hiện nghệ sĩ bài hát trên phần album nếu không khác ca sĩ album.';

  @override
  String get disableGesture => 'Tắt cử chỉ';

  @override
  String get disableGestureSubtitle => 'Có nên tắt cử chỉ.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Chủ đề';

  @override
  String get system => 'Hệ thống';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get tabs => 'Trang';

  @override
  String get cancelSleepTimer => 'Tắt Đồng hồ Hẹn Giờ Ngủ?';

  @override
  String get yesButtonLabel => 'CÓ';

  @override
  String get noButtonLabel => 'KHÔNG';

  @override
  String get setSleepTimer => 'Đặt đồng hồ hẹn giờ ngủ';

  @override
  String get minutes => 'Phút';

  @override
  String get invalidNumber => 'Số không hợp lệ';

  @override
  String get sleepTimerTooltip => 'Đồng hồ hẹn giờ ngủ';

  @override
  String get addToPlaylistTooltip => 'Thêm vào danh sách phát';

  @override
  String get addToPlaylistTitle => 'Thêm vào Danh sách phát';

  @override
  String get removeFromPlaylistTooltip => 'Loại bỏ khỏi danh sách phát';

  @override
  String get removeFromPlaylistTitle => 'Loại bỏ khỏi Danh sách phát';

  @override
  String get newPlaylist => 'Danh sách phát mới';

  @override
  String get createButtonLabel => 'TẠO';

  @override
  String get playlistCreated => 'Đã tạo danh sách phát.';

  @override
  String get noAlbum => 'Không có Album';

  @override
  String get noItem => 'Không có vật phẩm';

  @override
  String get noArtist => 'Không có Nghệ sĩ';

  @override
  String get unknownArtist => 'Nghệ sĩ không rõ';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'ĐÃ TẢI XUỐNG';

  @override
  String get transcode => 'CHUYỂN MÃ';

  @override
  String get direct => 'TRỰC TIẾP';

  @override
  String get statusError => 'LỖI TRẠNG THÁI';

  @override
  String get queue => 'Hàng chờ';

  @override
  String get addToQueue => 'Thêm vào Hàng chờ';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Thay thế Hàng chờ';

  @override
  String get instantMix => 'Instant Mix';

  @override
  String get goToAlbum => 'Đi tới Album';

  @override
  String get removeFavourite => 'Xóa yêu thích';

  @override
  String get addFavourite => 'Thêm vào Yêu thích';

  @override
  String get addedToQueue => 'Đã thêm vào hàng chờ.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Đã thay thế hàng chờ.';

  @override
  String get removedFromPlaylist => 'Đã loại bỏ khỏi danh sách.';

  @override
  String get startingInstantMix => 'Bắt đầu tuyển tập nhạc tức thời.';

  @override
  String get anErrorHasOccured => 'Đã có lỗi xảy ra.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Mã $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Mã $statusCode. Có thể bạn đã nhập sai tên người dùng/mật khẩu, hoặc client của bạn bị đăng xuất.';
  }

  @override
  String get removeFromMix => 'Loại bỏ khỏi Mix';

  @override
  String get addToMix => 'Thêm vào Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tải lại $count bài',
      one: 'Đã tải lại $count bài',
      zero: 'Không cần tải lại.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Thời gian bộ đệm';

  @override
  String get bufferDurationSubtitle =>
      'Trình phát nên tạo bộ đệm trong bao lâu giây. Cần khởi động lại app.';

  @override
  String get language => 'Ngôn ngữ';

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
