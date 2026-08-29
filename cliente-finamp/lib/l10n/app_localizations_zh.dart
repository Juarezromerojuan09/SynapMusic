// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String startupError(String error) {
    return '应用程序启动期间出现问题！ 错误是：$error\n\n请在 github.com/UnicornsOnLSD/finamp 上创建一个 Github 问题，并附上此页面的屏幕截图。 如果问题一直显示，请清除您的应用数据以重置应用。';
  }

  @override
  String get serverUrl => '服务器 URL';

  @override
  String get internalExternalIpExplanation =>
      '如果您希望能够远程访问您的 Jellyfin 服务器，则需要使用您的外部 IP。\n\n如果您的服务器位于 HTTP 端口 (80/443) 上，则不必指定端口。 如果您的服务器位于反向代理后面，则可能会出现这种情况。';

  @override
  String get emptyServerUrl => '服务器 URL 不能为空';

  @override
  String get urlStartWithHttps => 'URL 必须以 http:// 或 https:// 开头';

  @override
  String get urlTrailingSlash => 'URL 不得包含尾部斜杠';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get logs => '日志';

  @override
  String get next => '下一个';

  @override
  String get selectMusicLibraries => '选择音乐库';

  @override
  String get couldNotFindLibraries => '找不到任何库。';

  @override
  String get unknownName => '未知名称';

  @override
  String get songs => '歌曲';

  @override
  String get albums => '专辑';

  @override
  String get artists => '艺术家';

  @override
  String get genres => '流派';

  @override
  String get playlists => '播放列表';

  @override
  String get startMix => '开始混音';

  @override
  String get startMixNoSongsArtist => '在开始混音之前，长按艺术家以在混音生成器中添加或删除它们';

  @override
  String get startMixNoSongsAlbum => '在开始混音之前，长按专辑以在混音生成器中添加或删除它们';

  @override
  String get music => '音乐';

  @override
  String get clear => '清除';

  @override
  String get favourites => '收藏夹';

  @override
  String get shuffleAll => '全部随机播放';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => '下载';

  @override
  String get settings => '设置';

  @override
  String get offlineMode => '离线模式';

  @override
  String get sortOrder => '排序';

  @override
  String get sortBy => '排序方式';

  @override
  String get album => '专辑';

  @override
  String get albumArtist => '专辑艺术家';

  @override
  String get artist => '艺术家';

  @override
  String get budget => '预算';

  @override
  String get communityRating => '社区评级';

  @override
  String get criticRating => '评论家评级';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放计数';

  @override
  String get premiereDate => '首映日期';

  @override
  String get productionYear => '制作年份';

  @override
  String get name => '名称';

  @override
  String get random => '随机';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '运行时';

  @override
  String get syncDownloadedPlaylists => '同步下载的播放列表';

  @override
  String get downloadMissingImages => '下载缺少的图像';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下载 $count 张缺少的图像',
      one: '已下载 $count 张缺少的图形',
      zero: '未找到缺少的图像',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => '下载错误';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个下载',
      one: '$count 个下载',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个项目',
      one: '$count 个项目',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张图像',
      one: '$count 张图像',
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
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失败';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 已入队';
  }

  @override
  String dlRunning(int count) {
    return '$count 运行中';
  }

  @override
  String get downloadErrorsTitle => '下载错误';

  @override
  String get noErrors => '没有错误！';

  @override
  String get errorScreenError => '获取错误列表时出错！ 现在您可能应该在 GitHub 上创建一个问题并清除应用数据';

  @override
  String get failedToGetSongFromDownloadId => '从下载 ID 获取歌曲失败';

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
    return '您确定要从此设备中删除 $_temp0 \'$itemName\'吗?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '删除';

  @override
  String get deleteDownloadsAbortButtonText => '取消';

  @override
  String get error => '错误';

  @override
  String discNumber(int number) {
    return '唱片 $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '随机播放';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => '编辑播放列表名称';

  @override
  String get editPlaylistNameTitle => '编辑播放列表名称';

  @override
  String get required => '必需的';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '播放列表名称已更新。';

  @override
  String get favourite => '收藏夹';

  @override
  String get downloadsDeleted => '已删除下载。';

  @override
  String get addDownloads => '添加下载';

  @override
  String get location => '位置';

  @override
  String get downloadsAdded => '已添加下载。';

  @override
  String get addButtonLabel => '添加';

  @override
  String get shareLogs => '分享日志';

  @override
  String get logsCopied => '已复制日志。';

  @override
  String get message => '消息';

  @override
  String get stackTrace => '堆栈跟踪';

  @override
  String get applicationLegalese =>
      '获得 Mozilla 公共许可证 2.0 的许可。 源代码位于：\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => '转码';

  @override
  String get downloadLocations => '下载位置';

  @override
  String get audioService => '音频服务';

  @override
  String get interactions => '交互';

  @override
  String get layoutAndTheme => '布局和主题';

  @override
  String get notAvailableInOfflineMode => '在离线模式下不可用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedSongsWillNotBeDeleted => '下载的歌曲不会被删除';

  @override
  String get areYouSure => '你确定吗？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 AAC 进行转码';

  @override
  String get enableTranscoding => '启用转码';

  @override
  String get enableTranscodingSubtitle => '音乐流将由服务器转码。';

  @override
  String get bitrate => '比特率';

  @override
  String get bitrateSubtitle => '更高的比特率以更高的带宽为代价提供更高质量的音频。';

  @override
  String get customLocation => '自定义位置';

  @override
  String get appDirectory => '应用目录';

  @override
  String get addDownloadLocation => '添加下载路径';

  @override
  String get selectDirectory => '选择目录';

  @override
  String get unknownError => '未知错误';

  @override
  String get pathReturnSlashErrorMessage => '不能使用返回“/”的路径';

  @override
  String get directoryMustBeEmpty => '目录必须为空';

  @override
  String get customLocationsBuggy =>
      '由于权限问题，自定义位置存在很多问题。 我正在考虑解决此问题的方法，但目前我不建议使用它们。';

  @override
  String get enterLowPriorityStateOnPause => '暂停时进入低优先级状态';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      '通知可以在暂停时滑动。 启用此功能还允许 Android 在暂停时终止服务。';

  @override
  String get shuffleAllSongCount => '随机播放所有歌曲计数';

  @override
  String get shuffleAllSongCountSubtitle => '使用随机播放所有歌曲按钮时要加载的歌曲数量。';

  @override
  String get viewType => '视图类型';

  @override
  String get viewTypeSubtitle => '音乐屏幕的视图类型';

  @override
  String get list => '列表';

  @override
  String get grid => '网格';

  @override
  String get portrait => '纵向';

  @override
  String get landscape => '横向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 网格横轴数量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '每行使用的网格图块数量 $value.';
  }

  @override
  String get showTextOnGridView => '在网格视图中显示文本';

  @override
  String get showTextOnGridViewSubtitle => '是否在网格音乐屏幕上显示文本（标题、艺术家等）。';

  @override
  String get showCoverAsPlayerBackground => '将模糊的封面应用为播放器背景';

  @override
  String get showCoverAsPlayerBackgroundSubtitle => '是否在播放器屏幕上使用模糊的封面作为背景。';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists => '如果与专辑艺术家相同，则隐藏歌曲艺术家';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      '是否在专辑屏幕上隐藏歌曲艺术家（如果他们与专辑艺术家没有区别）。';

  @override
  String get disableGesture => '禁用手势';

  @override
  String get disableGestureSubtitle => '是否禁用手势。';

  @override
  String get showFastScroller => '显示快速滚动条';

  @override
  String get theme => '主题';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '选项卡';

  @override
  String get cancelSleepTimer => '取消睡眠定时器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '设置睡眠定时器';

  @override
  String get minutes => '分钟';

  @override
  String get invalidNumber => '无效数字';

  @override
  String get sleepTimerTooltip => '睡眠定时器';

  @override
  String get addToPlaylistTooltip => '添加至播放列表';

  @override
  String get addToPlaylistTitle => '添加至播放列表';

  @override
  String get removeFromPlaylistTooltip => '从播放列表删除';

  @override
  String get removeFromPlaylistTitle => '从播放列表删除';

  @override
  String get newPlaylist => '新建播放列表';

  @override
  String get createButtonLabel => '创建';

  @override
  String get playlistCreated => '播放列表已创建。';

  @override
  String get noAlbum => '没有专辑';

  @override
  String get noItem => '没有项目';

  @override
  String get noArtist => '没有艺术家';

  @override
  String get unknownArtist => '未知艺术家';

  @override
  String get streaming => '串流';

  @override
  String get downloaded => '下载';

  @override
  String get transcode => '转码';

  @override
  String get direct => '直接播放';

  @override
  String get statusError => '状态错误';

  @override
  String get queue => '队列';

  @override
  String get addToQueue => '添加至队列';

  @override
  String get playNext => '播放下一个';

  @override
  String get replaceQueue => '替换队列';

  @override
  String get instantMix => '即时混音';

  @override
  String get goToAlbum => '前往专辑';

  @override
  String get removeFavourite => '删除收藏夹';

  @override
  String get addFavourite => '添加至收藏夹';

  @override
  String get addedToQueue => '添加至队列。';

  @override
  String get insertedIntoQueue => '已插入队列。';

  @override
  String get queueReplaced => '队列已被替换。';

  @override
  String get removedFromPlaylist => '已从播放列表删除。';

  @override
  String get startingInstantMix => '开始即时混音。';

  @override
  String get anErrorHasOccured => '发生了一个错误。';

  @override
  String responseError(String error, int statusCode) {
    return '$error 状态码 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 状态码 $statusCode。 这可能意味着您使用了错误的用户名/密码，或者您客户端的身份验证已失效。';
  }

  @override
  String get removeFromMix => '从混音中删除';

  @override
  String get addToMix => '添加到混音';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项重新下载的项目',
      one: '$count 项重新下载的项目',
      zero: '无需重新下载项目',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '媒体时长';

  @override
  String get bufferDurationSubtitle => '播放器需要提前缓冲多长时间的音乐，以秒为单位。需要重启才能生效。';

  @override
  String get language => '语言';

  @override
  String get confirm => '确认';

  @override
  String get showUncensoredLogMessage => '该日志包含您的登录信息。显示？';

  @override
  String get resetTabs => '重置选项卡';

  @override
  String get noMusicLibrariesTitle => '没有音乐库';

  @override
  String get noMusicLibrariesBody =>
      'Finamp 找不到任何音乐库。请确保您的 Jellyfin 服务器至少包含一个内容类型设置为“音乐”的媒体库。';

  @override
  String get refresh => '刷新';

  @override
  String get swipeInsertQueueNext => '播放滑动的下一首歌曲';

  @override
  String get swipeInsertQueueNextSubtitle =>
      '在歌曲列表中滑动时，可以将歌曲作为队列中的下一个项目插入，而不是将其附加到末尾。';

  @override
  String get redesignBeta => '试用 Beta 版';

  @override
  String get playbackOrderShuffledTooltip => '随机播放。点击即可切换。';

  @override
  String get playbackOrderLinearTooltip => '按顺序播放。点击即可切换。';

  @override
  String get loopModeAllTooltip => '全部循环播放。点击即可切换。';

  @override
  String get loopModeOneTooltip => '循环播放一首。点击即可切换。';

  @override
  String get loopModeNoneTooltip => '不循环。点击即可切换。';

  @override
  String get skipToPrevious => '跳至上一首歌曲';

  @override
  String get skipToNext => '跳至下一首歌曲';

  @override
  String get togglePlayback => '切换播放';

  @override
  String playArtist(String artist) {
    return '播放 $artist 的所有专辑';
  }

  @override
  String shuffleArtist(String artist) {
    return '随机播放 $artist 的所有专辑';
  }

  @override
  String downloadArtist(String artist) {
    return '下载 $artist 的所有专辑';
  }

  @override
  String get deleteFromDevice => '从设备中删除';

  @override
  String get download => '下载';

  @override
  String get sync => '与服务器同步';

  @override
  String get about => '关于 Finamp';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String startupError(String error) {
    return '應用程序啓動期間出現問題！ 錯誤是：$error\n\n請在 github.com/UnicornsOnLSD/finamp 上提出一個 Github 問題，並附上此頁面的螢幕截圖。 如果此頁面一直顯示，請清除您的應用數據以重置應用。';
  }

  @override
  String get serverUrl => '伺服器 URL';

  @override
  String get internalExternalIpExplanation =>
      '如果您希望能夠遠程訪問您的 Jellyfin 伺服器，則需要使用您的外部 IP。\n\n如果您的伺服器位於 HTTP 端口 (80/443) 上，則不必指定端口。 如果您的伺服器位於反向代理後面，則可能會出現這種情況。';

  @override
  String get emptyServerUrl => '伺服器 URL 不能為空';

  @override
  String get urlStartWithHttps => 'URL 必須以 http:// 或 https:// 開頭';

  @override
  String get urlTrailingSlash => 'URL 不得包含斜線號';

  @override
  String get username => '用戶名';

  @override
  String get password => '密碼';

  @override
  String get logs => '紀錄檔';

  @override
  String get next => '下一個';

  @override
  String get selectMusicLibraries => '選擇音樂庫';

  @override
  String get couldNotFindLibraries => '找不到任何庫。';

  @override
  String get unknownName => '未知名稱';

  @override
  String get songs => '歌曲';

  @override
  String get albums => '專輯';

  @override
  String get artists => '藝術家';

  @override
  String get genres => '曲風';

  @override
  String get playlists => '播放列表';

  @override
  String get startMix => '開始混音';

  @override
  String get startMixNoSongsArtist => '在開始混音之前，長按藝術家以在混音生成器中添加或刪除它們';

  @override
  String get startMixNoSongsAlbum => '在開始混音之前，長按專輯以在混音生成器中添加或刪除它們';

  @override
  String get music => '音樂';

  @override
  String get clear => '清除';

  @override
  String get favourites => '最愛';

  @override
  String get shuffleAll => '全部隨機播放';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => '下載';

  @override
  String get settings => '設置';

  @override
  String get offlineMode => '離線模式';

  @override
  String get sortOrder => '排序';

  @override
  String get sortBy => '排序方式';

  @override
  String get album => '專輯';

  @override
  String get albumArtist => '專輯歌手';

  @override
  String get artist => '歌手';

  @override
  String get budget => '預算';

  @override
  String get communityRating => '聽眾評級';

  @override
  String get criticRating => '評論家評級';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放計數';

  @override
  String get premiereDate => '首播日期';

  @override
  String get productionYear => '製作年份';

  @override
  String get name => '名稱';

  @override
  String get random => '隨機';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '運行時';

  @override
  String get syncDownloadedPlaylists => '同步已下載的播放清';

  @override
  String get downloadMissingImages => '下載缺少的圖片';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下載 $count 張缺少的圖片',
      one: '已下載 $count 張缺少的圖片',
      zero: '未找到缺少的圖片',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => '下載錯誤';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個下載',
      one: '$count 個下載',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個項目',
      one: '$count 個項目',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 張圖片',
      one: '$count 張圖片',
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
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 已入隊';
  }

  @override
  String dlRunning(int count) {
    return '$count 運行中';
  }

  @override
  String get downloadErrorsTitle => '下載錯誤';

  @override
  String get noErrors => '沒有錯誤！';

  @override
  String get errorScreenError => '獲取錯誤列表時出錯！您可以在 GitHub 上提出問題並清除應用數據';

  @override
  String get failedToGetSongFromDownloadId => '從下載 ID 獲取歌曲失敗';

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
    return '您確定要將 $_temp0 \'$itemName\'從設備中刪除嗎?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '刪除';

  @override
  String get deleteDownloadsAbortButtonText => '取消';

  @override
  String get error => '錯誤';

  @override
  String discNumber(int number) {
    return '唱片 $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '隨機播放';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => '編輯播放列表名稱';

  @override
  String get editPlaylistNameTitle => '編輯播放列表名稱';

  @override
  String get required => '必需的';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '播放列表名稱已更新。';

  @override
  String get favourite => '最愛';

  @override
  String get downloadsDeleted => '已刪除下載。';

  @override
  String get addDownloads => '添加下載';

  @override
  String get location => '位置';

  @override
  String get downloadsAdded => '已添加下載。';

  @override
  String get addButtonLabel => '添加';

  @override
  String get shareLogs => '分享紀錄檔';

  @override
  String get logsCopied => '已複制紀錄檔。';

  @override
  String get message => '消息';

  @override
  String get stackTrace => '堆棧跟蹤';

  @override
  String get applicationLegalese =>
      '獲得 Mozilla 公共授權條款 2.0 的許可。 源代碼位於：\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => '轉碼';

  @override
  String get downloadLocations => '下載位置';

  @override
  String get audioService => '音頻服務';

  @override
  String get interactions => '互動';

  @override
  String get layoutAndTheme => '佈局和主題';

  @override
  String get notAvailableInOfflineMode => '在離線模式下不可用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedSongsWillNotBeDeleted => '下載的歌曲不會被刪除';

  @override
  String get areYouSure => '你確定嗎？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 AAC 進行轉碼';

  @override
  String get enableTranscoding => '啓用轉碼';

  @override
  String get enableTranscodingSubtitle => '如果啓用，音樂流將由伺服器轉碼。';

  @override
  String get bitrate => '位元速率';

  @override
  String get bitrateSubtitle => '更高的位元速率以更高的帶寬為代價提供更高質量的音頻。';

  @override
  String get customLocation => '自定義位置';

  @override
  String get appDirectory => '應用目錄';

  @override
  String get addDownloadLocation => '添加下載路徑';

  @override
  String get selectDirectory => '選擇目錄';

  @override
  String get unknownError => '未知錯誤';

  @override
  String get pathReturnSlashErrorMessage => '不能使用返回“/”的路徑';

  @override
  String get directoryMustBeEmpty => '目錄必須為空';

  @override
  String get customLocationsBuggy =>
      '由於權限問題，自定義位置存在很多問題。 我正在考慮解決此問題的方法，但目前我不建議使用它們。';

  @override
  String get enterLowPriorityStateOnPause => '暫停時進入低優先級狀態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      '啓用後，通知可以在暫停時滑動。 啓用此功能還允許 Android 在暫停時終止服務。';

  @override
  String get shuffleAllSongCount => '隨機播放所有歌曲計數';

  @override
  String get shuffleAllSongCountSubtitle => '使用隨機播放所有歌曲按鈕時要加載的歌曲數量。';

  @override
  String get viewType => '顯示類型';

  @override
  String get viewTypeSubtitle => '音樂螢幕的顯示類型';

  @override
  String get list => '列表';

  @override
  String get grid => '網格';

  @override
  String get portrait => '縱向';

  @override
  String get landscape => '橫向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 網格橫軸數量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '每行使用的網格圖塊數量 $value.';
  }

  @override
  String get showTextOnGridView => '在網格顯示上顯示文字';

  @override
  String get showTextOnGridViewSubtitle => '是否在網格音樂螢幕上顯示文字（標題、歌手等）。';

  @override
  String get showCoverAsPlayerBackground => '將模糊的封面應用為播放器背景';

  @override
  String get showCoverAsPlayerBackgroundSubtitle => '是否在播放器螢幕上使用模糊的封面作為背景。';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists => '如果與專輯藝術家相同，則隱藏歌曲藝術家';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      '是否在專輯螢幕上隱藏歌曲歌手（如果他們與專輯歌手沒有區別）。';

  @override
  String get disableGesture => '禁用手勢';

  @override
  String get disableGestureSubtitle => '是否禁用「手勢」功能。';

  @override
  String get showFastScroller => '顯示快速滾動條';

  @override
  String get theme => '主題';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '選項卡';

  @override
  String get cancelSleepTimer => '取消睡眠定時器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '設置睡眠定時器';

  @override
  String get minutes => '分鍾';

  @override
  String get invalidNumber => '無效數字';

  @override
  String get sleepTimerTooltip => '睡眠定時器';

  @override
  String get addToPlaylistTooltip => '添加至播放列表';

  @override
  String get addToPlaylistTitle => '添加至播放列表';

  @override
  String get removeFromPlaylistTooltip => '從播放列表中移除歌曲';

  @override
  String get removeFromPlaylistTitle => '從播放列表中移除';

  @override
  String get newPlaylist => '新建播放列表';

  @override
  String get createButtonLabel => '創建';

  @override
  String get playlistCreated => '播放列表已創建。';

  @override
  String get noAlbum => '沒有專輯';

  @override
  String get noItem => '沒有項目';

  @override
  String get noArtist => '沒有歌手';

  @override
  String get unknownArtist => '未知歌手';

  @override
  String get streaming => '串流';

  @override
  String get downloaded => '下載';

  @override
  String get transcode => '轉碼';

  @override
  String get direct => '直接播放';

  @override
  String get statusError => '狀態錯誤';

  @override
  String get queue => '隊列';

  @override
  String get addToQueue => '添加至隊列';

  @override
  String get playNext => '插播為下一首';

  @override
  String get replaceQueue => '替換隊列';

  @override
  String get instantMix => '即時混音';

  @override
  String get goToAlbum => '前往專輯';

  @override
  String get removeFavourite => '刪除最愛';

  @override
  String get addFavourite => '添加至最愛';

  @override
  String get addedToQueue => '添加至隊列。';

  @override
  String get insertedIntoQueue => '完成加入至待播清單。';

  @override
  String get queueReplaced => '隊列已被替換。';

  @override
  String get removedFromPlaylist => '已從播放列表中移除。';

  @override
  String get startingInstantMix => '開始即時混音。';

  @override
  String get anErrorHasOccured => '發生了一個錯誤。';

  @override
  String responseError(String error, int statusCode) {
    return '$error 狀態碼 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 狀態碼 $statusCode。 這可能意味著您使用了錯誤的用戶名/密碼，或者您客戶端的身份驗證已失效。';
  }

  @override
  String get removeFromMix => '從混音中刪除';

  @override
  String get addToMix => '添加到混音';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已重新下載$count個項目',
      one: '已重新下載$count個項目',
      zero: '沒有需要重新下載的項目。',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '緩衝時長';

  @override
  String get bufferDurationSubtitle => '播放器可以預先載入多少的音樂（秒）。需重啟以套用設定。';

  @override
  String get language => '語言';

  @override
  String get confirm => '確認';

  @override
  String get showUncensoredLogMessage => '此記錄包含你的登入資訊。是否顯示？';

  @override
  String get resetTabs => '重設分頁';

  @override
  String get noMusicLibrariesTitle => '尚無音樂庫';

  @override
  String get noMusicLibrariesBody =>
      '找不到音樂庫。請確保 Jellyfin 中至少有一個資料庫的類別需設置成\"音樂\"。';

  @override
  String get refresh => '重新整理';

  @override
  String get swipeInsertQueueNext => '滑動歌曲接著播放';

  @override
  String get swipeInsertQueueNextSubtitle =>
      '開啟後滑動清單中的歌曲，可以將歌曲接著播放，而不是加到播放清單的最後一首。';

  @override
  String get redesignBeta => '重新設計的Beta測試版';
}

/// The translations for Chinese, as used in Hong Kong, using the Han script (`zh_Hant_HK`).
class AppLocalizationsZhHantHk extends AppLocalizationsZh {
  AppLocalizationsZhHantHk() : super('zh_Hant_HK');

  @override
  String startupError(String error) {
    return '應用程式啟動時出錯（$error）\n\n您可以在 github.com/UnicornsOnLSD/finamp 回報有關問題並附上截圖。如果問題持續，您可以嘗試重設應用程式。';
  }

  @override
  String get serverUrl => '伺服器 URL';

  @override
  String get internalExternalIpExplanation =>
      '如果您需要在局部區域網絡（LAN）以外的地方連接 Jellyfin，請使用伺服器的區域網絡（WAN）IP。\n\n如果目標伺服器使用的連接埠（port）是 HTTP 的預設連接埠（80／433），則毋須填寫連接埠。';

  @override
  String get emptyServerUrl => '伺服器 URL 並不能漏空';

  @override
  String get urlStartWithHttps => 'URL 必須以 http:// 或 https:// 開頭';

  @override
  String get urlTrailingSlash => 'URL 不能以「/」作結';

  @override
  String get username => '用戶名稱';

  @override
  String get password => '密碼';

  @override
  String get logs => '紀錄檔';

  @override
  String get next => '下一個';

  @override
  String get selectMusicLibraries => '選擇音樂媒體庫';

  @override
  String get couldNotFindLibraries => '沒有可用的媒體庫。';

  @override
  String get unknownName => '未知的名稱';

  @override
  String get songs => '歌曲';

  @override
  String get albums => '專輯';

  @override
  String get artists => '歌手';

  @override
  String get genres => '曲風';

  @override
  String get playlists => '播放清單';

  @override
  String get startMix => '開始混音';

  @override
  String get startMixNoSongsArtist => '在開始混音之前，長按歌手以添加至混音器或從混音器移除';

  @override
  String get startMixNoSongsAlbum => '在開始混音之前，長按專輯以添加至混音器或從混音器移除';

  @override
  String get music => '音樂';

  @override
  String get clear => '清除';

  @override
  String get favourites => '我的最愛';

  @override
  String get shuffleAll => '隨機播放全部';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => '下載';

  @override
  String get settings => '設定';

  @override
  String get offlineMode => '離線模式';

  @override
  String get sortOrder => '順序';

  @override
  String get sortBy => '排序方式';

  @override
  String get album => '專輯';

  @override
  String get albumArtist => '專輯歌手';

  @override
  String get artist => '歌手';

  @override
  String get budget => '預算';

  @override
  String get communityRating => '聽眾評分';

  @override
  String get criticRating => '樂評人評分';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放次數';

  @override
  String get premiereDate => '推出日期';

  @override
  String get productionYear => '製作年份';

  @override
  String get name => '名稱';

  @override
  String get random => '隨機';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '執行時';

  @override
  String get syncDownloadedPlaylists => '同步已下載播放清單';

  @override
  String get downloadMissingImages => '下載缺失的圖片';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下載$count張圖片',
      one: '已下載$count張圖片',
      zero: '沒有缺少的圖片',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => '下載錯誤';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個下載',
      one: '$count個下載',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個項目',
      one: '$count個項目',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count張圖片',
      one: '$count張圖片',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsImagesCount(
      String downloadedItems, String downloadedImages) {
    return '$downloadedItems， $downloadedImages';
  }

  @override
  String dlComplete(int count) {
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 等待中';
  }

  @override
  String dlRunning(int count) {
    return '$count 正在下載';
  }

  @override
  String get downloadErrorsTitle => '下載錯誤';

  @override
  String get noErrors => '沒有錯誤！';

  @override
  String get errorScreenError => '讀取錯誤資訊時發生錯誤！建議在 GitHub 上回報此問題及重設應用程式。';

  @override
  String get failedToGetSongFromDownloadId => '無法從下載 ID 中取得歌曲';

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
    return '你是否確定從裝置中刪除 $_temp0 \'$itemName\'？';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '刪除';

  @override
  String get deleteDownloadsAbortButtonText => '取消';

  @override
  String get error => '錯誤';

  @override
  String discNumber(int number) {
    return 'CD $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '隨機播放';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count首歌曲',
      one: '$count首歌曲',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => '編輯播放清單名稱';

  @override
  String get editPlaylistNameTitle => '編輯播放清單名稱';

  @override
  String get required => '必填';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '已更新播放清單名稱。';

  @override
  String get favourite => '我的最愛';

  @override
  String get downloadsDeleted => '已刪除。';

  @override
  String get addDownloads => '添加至下載';

  @override
  String get location => '位置';

  @override
  String get downloadsAdded => '已添加至下載。';

  @override
  String get addButtonLabel => '加入';

  @override
  String get shareLogs => '分享所有紀錄檔';

  @override
  String get logsCopied => '已複製所有紀錄。';

  @override
  String get message => '訊息';

  @override
  String get stackTrace => '除錯資訊（Stack Trace）';

  @override
  String get applicationLegalese =>
      '採用 Mozilla Public License 2.0 特許條款。原始碼：\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => '轉碼（Transcoding）';

  @override
  String get downloadLocations => '下載位置';

  @override
  String get audioService => '播放設定';

  @override
  String get interactions => '互動';

  @override
  String get layoutAndTheme => '顯示及主題';

  @override
  String get notAvailableInOfflineMode => '不能在離線模式下使用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedSongsWillNotBeDeleted => '已下載的歌曲並不會被刪除';

  @override
  String get areYouSure => '您確定嗎？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 ACC 進行轉碼';

  @override
  String get enableTranscoding => '啟用轉碼';

  @override
  String get enableTranscodingSubtitle => '啟用後，音訊會先在伺服器轉碼。';

  @override
  String get bitrate => '位元速率（Bitrate）';

  @override
  String get bitrateSubtitle => '越高的位元速率帶來越好的音質，但亦會使用更多的流量。';

  @override
  String get customLocation => '自訂位置';

  @override
  String get appDirectory => '應用程式資料夾';

  @override
  String get addDownloadLocation => '添加下載位置';

  @override
  String get selectDirectory => '選擇資料夾';

  @override
  String get unknownError => '未知的錯誤';

  @override
  String get pathReturnSlashErrorMessage => '不能使用「／」路徑';

  @override
  String get directoryMustBeEmpty => '所選的資料夾必須為空的';

  @override
  String get customLocationsBuggy => '現時，自訂位置功能因權限問題而未能完全正常運作。如非必要，建議不要使用。';

  @override
  String get enterLowPriorityStateOnPause => '暫停播放時會進入「低優先」狀態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      '在停止播放時，允許本程式的「通知」能被掃走及關閉應用程式（適用於 Android 裝置）。';

  @override
  String get shuffleAllSongCount => '隨機播放上限';

  @override
  String get shuffleAllSongCountSubtitle => '使用「隨機播放全部」時，播放歌曲的數量上限。';

  @override
  String get viewType => '顯示模式';

  @override
  String get viewTypeSubtitle => '顯示資訊的方式';

  @override
  String get list => '清單';

  @override
  String get grid => '格狀';

  @override
  String get portrait => '直向';

  @override
  String get landscape => '橫向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value顯示網格數量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '屏幕在$value顯示時，每行顯示的資訊數量（例如歌曲、歌手等）。';
  }

  @override
  String get showTextOnGridView => '在網絡內顯示文字';

  @override
  String get showTextOnGridViewSubtitle => '使用格狀顯示時，在網格內顯示歌曲資訊（名稱、歌手等）。';

  @override
  String get showCoverAsPlayerBackground => '模糊化封面作為播放器的背景';

  @override
  String get showCoverAsPlayerBackgroundSubtitle => '以模糊化的專輯封面作為應用程式內的播放頁面的背景。';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists => '隱藏與專輯歌手同名的歌手名稱';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      '當專輯的歌手與歌曲的歌手相同時，隱藏歌曲的歌手名稱。';

  @override
  String get disableGesture => '禁用「手勢」功能';

  @override
  String get disableGestureSubtitle => '是否禁用「手勢」功能。';

  @override
  String get showFastScroller => '顯示快速卷軸';

  @override
  String get theme => '色彩主題';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '分頁';

  @override
  String get cancelSleepTimer => '取消睡眠定時器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '設定睡眠定時器';

  @override
  String get minutes => '分鐘';

  @override
  String get invalidNumber => '無效的數字';

  @override
  String get sleepTimerTooltip => '睡眠定時器';

  @override
  String get addToPlaylistTooltip => '將歌曲加入至播放清單';

  @override
  String get addToPlaylistTitle => '加入至播放清單';

  @override
  String get removeFromPlaylistTooltip => '從播放清單中移除歌曲';

  @override
  String get removeFromPlaylistTitle => '從播放清單中移除';

  @override
  String get newPlaylist => '建立播放清單';

  @override
  String get createButtonLabel => '建立';

  @override
  String get playlistCreated => '已建立播放清單。';

  @override
  String get noAlbum => '沒有任何專輯';

  @override
  String get noItem => '沒有任何項目';

  @override
  String get noArtist => '沒有任何歌手';

  @override
  String get unknownArtist => '未知的歌手';

  @override
  String get streaming => '串流中';

  @override
  String get downloaded => '已下載';

  @override
  String get transcode => '轉碼';

  @override
  String get direct => '直接播放';

  @override
  String get statusError => '錯誤';

  @override
  String get queue => '播放佇列';

  @override
  String get addToQueue => '加入至播放佇列';

  @override
  String get playNext => '下一首';

  @override
  String get replaceQueue => '取代現時的播放佇列';

  @override
  String get instantMix => '即時混音';

  @override
  String get goToAlbum => '檢視專輯';

  @override
  String get removeFavourite => '從我的最愛中移除';

  @override
  String get addFavourite => '加入至我的最愛';

  @override
  String get addedToQueue => '已加入至播放佇列。';

  @override
  String get insertedIntoQueue => '已加入至播放佇列中。';

  @override
  String get queueReplaced => '已取代現有的播放佇列。';

  @override
  String get removedFromPlaylist => '已從播放清單中移除。';

  @override
  String get startingInstantMix => '開始即時混音中。';

  @override
  String get anErrorHasOccured => '出現錯誤。';

  @override
  String responseError(String error, int statusCode) {
    return '$error（代碼：$statusCode）。';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error（代碼：$statusCode）。此錯誤有可能因為用戶名稱／密碼輸入錯誤或您已被登出而導致。';
  }

  @override
  String get removeFromMix => '從混音中移除';

  @override
  String get addToMix => '加入至混音';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已重新下載$count個項目',
      one: '已重新下載$count個項目',
      zero: '沒有需要重新下載的項目。',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '緩衝時長';

  @override
  String get bufferDurationSubtitle => '播放器可以預先載入多少的音訊數據（秒）。重啟以套用設定。';

  @override
  String get language => '語言';

  @override
  String get confirm => '確定';

  @override
  String get showUncensoredLogMessage => '紀錄檔內包含你的登入資訊。你是否確認要顯示？';

  @override
  String get resetTabs => '重設分頁';

  @override
  String get noMusicLibrariesTitle => '沒有音樂類媒體庫';

  @override
  String get noMusicLibrariesBody =>
      'Finamp 未有發現任何音樂媒體庫。請檢查 Jellyfin 伺服器上最少有一個屬於「音樂」類別的媒體庫。';

  @override
  String get refresh => '重新載入';

  @override
  String get swipeInsertQueueNext => '滑動插播';

  @override
  String get swipeInsertQueueNextSubtitle => '在歌曲列表中輕掃歌曲時，將其插入至播放佇列的最頭而不是最後。';

  @override
  String get redesignBeta => '測試版';

  @override
  String get skipToPrevious => '上一首歌';

  @override
  String get skipToNext => '下一首歌';

  @override
  String playArtist(String artist) {
    return '播放$artist所有的專輯';
  }

  @override
  String shuffleArtist(String artist) {
    return '隨機播放$artist的專輯';
  }

  @override
  String downloadArtist(String artist) {
    return '下載 $artist所有的專輯';
  }

  @override
  String get deleteFromDevice => '從裝置中刪除';

  @override
  String get download => '下載';

  @override
  String get sync => '與伺服器同步';

  @override
  String get about => '關於 Finamp';
}
