// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String startupError(String error) {
    return '起動時に問題が起こりました。エラー内容: $error\n\ngithub.com/UnicornsOnLSD/finamp でイシューを作成し、このページのスクリーンショットを付けてください。問題が継続した場合はアプリデータをクリアしてアプリを初期化して下さい。';
  }

  @override
  String get serverUrl => 'サーバー URL';

  @override
  String get internalExternalIpExplanation =>
      'リモートからJellyfinサーバーにアクセスするには外部IPを指定する必要があります。\n\nサーバーがHTTPポート(80/443)で動いている場合にはポートは不要です。サーバーがリバースプロキシの後ろにある場合はこれが一般的です。';

  @override
  String get emptyServerUrl => 'サーバーURLを入力してください';

  @override
  String get urlStartWithHttps => 'URL は http:// か https:// で始まらなければなりません';

  @override
  String get urlTrailingSlash => 'URL の末尾にスラッシュがあってはなりません';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get logs => 'ログ';

  @override
  String get next => '次';

  @override
  String get selectMusicLibraries => 'ミュージック・ライブラリを選択';

  @override
  String get couldNotFindLibraries => 'ライブラリが見つかりません。';

  @override
  String get unknownName => 'タイトル不明';

  @override
  String get songs => '曲';

  @override
  String get albums => 'アルバム';

  @override
  String get artists => 'アーティスト';

  @override
  String get genres => 'ジャンル';

  @override
  String get playlists => 'プレイリスト';

  @override
  String get startMix => 'ミックス開始';

  @override
  String get startMixNoSongsArtist => 'アーティスト名を長押しすることでミックス対象に追加または削除できます';

  @override
  String get startMixNoSongsAlbum => 'アルバムを長押しすることでミックス対象に追加または削除できます';

  @override
  String get music => 'ミュージック';

  @override
  String get clear => 'クリア';

  @override
  String get favourites => 'お気に入り';

  @override
  String get shuffleAll => '全てシャッフル';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get settings => '設定';

  @override
  String get offlineMode => 'オフライン・モード';

  @override
  String get sortOrder => '並び順';

  @override
  String get sortBy => '並び基準';

  @override
  String get album => 'アルバム';

  @override
  String get albumArtist => 'アルバム・アーティスト';

  @override
  String get artist => 'アーティスト';

  @override
  String get budget => '予算';

  @override
  String get communityRating => 'コミュニティ評価';

  @override
  String get criticRating => '評論家評価';

  @override
  String get dateAdded => '追加日';

  @override
  String get datePlayed => '再生日';

  @override
  String get playCount => '再生回数';

  @override
  String get premiereDate => '公開日';

  @override
  String get productionYear => '作成年';

  @override
  String get name => '曲名';

  @override
  String get random => 'ランダム';

  @override
  String get revenue => '収入';

  @override
  String get runtime => '再生時間';

  @override
  String get syncDownloadedPlaylists => 'ダウンロードしたプレイリストの同期';

  @override
  String get downloadMissingImages => '欠けている画像をダウンロード';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '欠けている画像を $count 枚ダウンロード',
      one: '欠けている画像を $count 枚ダウンロード',
      zero: '欠けている画像が見つかりません',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'ダウンロード・エラー';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個ダウンロード',
      one: '$count 個ダウンロード',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countアイテム',
      one: '$count アイテム',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count枚の画像',
      one: '$count 枚の画像',
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
    return '$count 個完了';
  }

  @override
  String dlFailed(int count) {
    return '$count個失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 個キューに追加';
  }

  @override
  String dlRunning(int count) {
    return '$count 個再生中';
  }

  @override
  String get downloadErrorsTitle => 'ダウンロード・エラー';

  @override
  String get noErrors => 'エラーなし!';

  @override
  String get errorScreenError =>
      'エラーリスト取得時にエラーが発生しました！この時点では、GitHub で issue を作成し、アプリデータを削除することをお勧めします';

  @override
  String get failedToGetSongFromDownloadId => 'ダウンロード ID から曲が取得できません';

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
    return 'このデバイスから$_temp0 \'$itemName\'を削除してもよろしいですか?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '削除';

  @override
  String get deleteDownloadsAbortButtonText => 'キャンセル';

  @override
  String get error => 'エラー';

  @override
  String discNumber(int number) {
    return 'ディスク $number';
  }

  @override
  String get playButtonLabel => '再生';

  @override
  String get shuffleButtonLabel => 'シャッフル';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '$count曲',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'プレイリスト名を編集';

  @override
  String get editPlaylistNameTitle => 'プレイリスト名を編集';

  @override
  String get required => '必須';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => 'プレイリスト名を更新しました。';

  @override
  String get favourite => 'お気に入り';

  @override
  String get downloadsDeleted => 'ダウンロードを削除しました。';

  @override
  String get addDownloads => 'ダウンロードを追加';

  @override
  String get location => '場所';

  @override
  String get downloadsAdded => 'ダウンロードを追加しました。';

  @override
  String get addButtonLabel => '追加';

  @override
  String get shareLogs => 'ログ共有';

  @override
  String get logsCopied => 'ログをコピーしました。';

  @override
  String get message => 'メッセージ';

  @override
  String get stackTrace => 'スタックトレース';

  @override
  String get applicationLegalese =>
      'Mozilla Public License 2.0 でライセンスされています。ソース コードは以下から入手できます:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'トランスコード';

  @override
  String get downloadLocations => 'ダウンロード場所';

  @override
  String get audioService => 'オーディオ・サービス';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'レイアウト&テーマ';

  @override
  String get notAvailableInOfflineMode => 'オフライン・モードでは無効';

  @override
  String get logOut => 'ログアウト';

  @override
  String get downloadedSongsWillNotBeDeleted => 'ダウロード済みの曲は削除されません';

  @override
  String get areYouSure => 'よろしいですか？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin はトランスコードに AAC を利用します';

  @override
  String get enableTranscoding => 'トランスコード有効';

  @override
  String get enableTranscodingSubtitle => 'サーバー側の音楽ストリームをトランスコードします。';

  @override
  String get bitrate => 'ビットレート';

  @override
  String get bitrateSubtitle => '高いビットレートではオーディオの質が高くなりますが、転送容量も高くなります。';

  @override
  String get customLocation => '指定の場所';

  @override
  String get appDirectory => 'Appのディレクトリ';

  @override
  String get addDownloadLocation => 'ダウンロード場所を追加';

  @override
  String get selectDirectory => 'ディレクトリを選択';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get pathReturnSlashErrorMessage => '\"/\" を返すパスは利用できません';

  @override
  String get directoryMustBeEmpty => 'ディレクトリは空でなければなりません';

  @override
  String get customLocationsBuggy =>
      'カスタムの場所は、権限の問題により、非常にバグが多くなります。これを修正する方法を考えていますが、今のところは使用しないことをお勧めします。';

  @override
  String get enterLowPriorityStateOnPause => '一時停止時は低優先度状態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      '一時停止時に通知をスワイプで除去できます。また Android では一時停止時にサービスを停止できます。';

  @override
  String get shuffleAllSongCount => '曲がシャッフル化される回数';

  @override
  String get shuffleAllSongCountSubtitle => 'すべての曲をシャッフルする時、ここで指定した曲数をロードします。';

  @override
  String get viewType => 'ビューの形式';

  @override
  String get viewTypeSubtitle => 'ミュージック画面の表示形式';

  @override
  String get list => 'リスト';

  @override
  String get grid => 'グリッド';

  @override
  String get portrait => '縦表示';

  @override
  String get landscape => '横表示';

  @override
  String gridCrossAxisCount(String value) {
    return '$value のアイテム数';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '$valueの場合一行当たりのグリッドタイル数。';
  }

  @override
  String get showTextOnGridView => 'グリッド・ビューでテキストを表示する';

  @override
  String get showTextOnGridViewSubtitle =>
      'グリッド音楽画面でテキスト（タイトル、アーティスト等）を表示させるか。';

  @override
  String get showCoverAsPlayerBackground => 'プレイヤー背景にジャケット画像をぼかして表示する';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'プレイヤー画面で背景にジャケット画像をぼかして表示させるか。';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      '曲のアーティストがアルバム・アーティストと同じの場合、表示しない';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      '曲のアーティストがアルバムのアーティストと一致した場合、アルバム画面に表示させるか。';

  @override
  String get disableGesture => 'ジェスチャーを無効';

  @override
  String get disableGestureSubtitle => 'ジェスチャーを無効にするか。';

  @override
  String get showFastScroller => '高速スクロールを表示';

  @override
  String get theme => 'テーマ';

  @override
  String get system => 'システム';

  @override
  String get light => '明るい';

  @override
  String get dark => '暗い';

  @override
  String get tabs => 'タブ';

  @override
  String get cancelSleepTimer => 'スリープ・タイマーをキャンセルしますか?';

  @override
  String get yesButtonLabel => 'はい';

  @override
  String get noButtonLabel => 'いいえ';

  @override
  String get setSleepTimer => 'スリープ・タイマーを設定';

  @override
  String get minutes => '分';

  @override
  String get invalidNumber => '無効な数値';

  @override
  String get sleepTimerTooltip => 'スリープ・タイマー';

  @override
  String get addToPlaylistTooltip => 'プレイリストに追加';

  @override
  String get addToPlaylistTitle => 'プレイリストに追加';

  @override
  String get removeFromPlaylistTooltip => 'プレイリストから外す';

  @override
  String get removeFromPlaylistTitle => 'プレイリストから外す';

  @override
  String get newPlaylist => '新規プレイリスト';

  @override
  String get createButtonLabel => '作成';

  @override
  String get playlistCreated => 'プレイリストを作成しました。';

  @override
  String get noAlbum => 'アルバム無し';

  @override
  String get noItem => 'アイテム無し';

  @override
  String get noArtist => 'アーティスト無し';

  @override
  String get unknownArtist => 'アーティスト不明';

  @override
  String get streaming => 'ストリーミング';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get transcode => 'トランスコード';

  @override
  String get direct => '直接';

  @override
  String get statusError => 'ステータス・エラー';

  @override
  String get queue => 'キュー';

  @override
  String get addToQueue => 'キューに追加';

  @override
  String get playNext => '再生次';

  @override
  String get replaceQueue => 'キューを置き換え';

  @override
  String get instantMix => 'インスタント・ミックス';

  @override
  String get goToAlbum => 'アルバムに行く';

  @override
  String get removeFavourite => 'お気に入りを削除';

  @override
  String get addFavourite => 'お気に入りを追加';

  @override
  String get addedToQueue => 'キューに追加。';

  @override
  String get insertedIntoQueue => 'キューに挿入されました。';

  @override
  String get queueReplaced => 'キューを置き換えました。';

  @override
  String get removedFromPlaylist => 'プレイリストから外しました。';

  @override
  String get startingInstantMix => 'インスタント・ミックス開始。';

  @override
  String get anErrorHasOccured => 'エラーが発生しました。';

  @override
  String responseError(String error, int statusCode) {
    return '$error ステータスコード $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. ユーザー名/パスワードが間違っているか、クライアントがログインしていません。';
  }

  @override
  String get removeFromMix => 'ミックスから外す';

  @override
  String get addToMix => 'ミックスに追加';

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
  String get bufferDuration => 'バッファ容量';

  @override
  String get bufferDurationSubtitle => 'プレイヤーがバッファする容量（秒単位）。リスタートが必要です。';

  @override
  String get language => '言語';

  @override
  String get confirm => '確認する';

  @override
  String get showUncensoredLogMessage => 'このログはあなたのログイン情報を含みます。表示しますか？';

  @override
  String get resetTabs => 'タブリセット';

  @override
  String get noMusicLibrariesTitle => '音楽ライブラリなし';

  @override
  String get noMusicLibrariesBody =>
      'Finamp は音楽ライブラリを見つけることができませんでした。Jellyfin サーバーに、コンテンツ タイプが「音楽」に設定されているライブラリが少なくとも 1 つ含まれていることを確認してください。';

  @override
  String get refresh => 'リフレッシュ';

  @override
  String get swipeInsertQueueNext => 'スワイプした曲を再生する';

  @override
  String get swipeInsertQueueNextSubtitle =>
      '曲リストでスワイプしたときに、曲を最後に追加するのではなく、キューの次の項目として挿入できるようにします。';

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
