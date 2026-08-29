// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String startupError(String error) {
    return '앱 시작중에 문제가 발생했습니다. 오류 내용:$error\n\n\"github.com/UnicornsOnLSD/finamp\"에 이 페이지의 캡처 화면을 첨부하여 \'이슈\'를 등록 해주세요. 이 문제가 지속되면 당신은 앱 데이터를 삭제하여 앱을 초기화 할 수 있습니다.';
  }

  @override
  String get serverUrl => '서버 URL';

  @override
  String get internalExternalIpExplanation =>
      '귀하의 Jellyfin 서버에 원격으로 접속하려면, 외부 IP 주소를 사용해야 합니다.\n\n귀하의 서버가 HTTP 포트(80/443)에 있거나 역방향 프록시(Reverse Proxy) 뒤에 있는 경우, 포트를 지정할 필요는 없습니다.';

  @override
  String get emptyServerUrl => '서버 URL은 필수값 입니다';

  @override
  String get urlStartWithHttps => 'URL은 \"http://\" 또는 \"https://\"로 시작해야 합니다';

  @override
  String get urlTrailingSlash => 'URL 끝부분에 슬래시(/, 후행 슬래시)를 붙이지 마세요';

  @override
  String get username => '사용자 이름(아이디)';

  @override
  String get password => '암호';

  @override
  String get logs => '로그(사용기록)';

  @override
  String get next => '다음';

  @override
  String get selectMusicLibraries => '음악 라이브러리 선택';

  @override
  String get couldNotFindLibraries => '라이브러리를 찾을 수 없습니다.';

  @override
  String get unknownName => '알 수 없는 이름';

  @override
  String get songs => '노래';

  @override
  String get albums => '앨범';

  @override
  String get artists => '아티스트';

  @override
  String get genres => '장르';

  @override
  String get playlists => '플레이리스트';

  @override
  String get startMix => '믹스 시작하기';

  @override
  String get startMixNoSongsArtist =>
      '믹스를 시작하기 전에 \'아티스트\'를 길게 탭하여 믹스 빌더에서 추가하거나 제거하세요';

  @override
  String get startMixNoSongsAlbum =>
      '믹스를 시작하기 전에 \'앨범\'을 길게 탭하여 믹스 빌더에서 추가하거나 제거하세요';

  @override
  String get music => '음악';

  @override
  String get clear => '삭제(비우기)';

  @override
  String get favourites => '즐겨찾기';

  @override
  String get shuffleAll => '임의 재생(모두)';

  @override
  String get finamp => '핀앰프(Finamp)';

  @override
  String get downloads => '다운로드';

  @override
  String get settings => '설정';

  @override
  String get offlineMode => '오프라인 모드';

  @override
  String get sortOrder => '정렬 순서';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get album => '앨범';

  @override
  String get albumArtist => '앨범 아티스트';

  @override
  String get artist => '아티스트';

  @override
  String get budget => '예산';

  @override
  String get communityRating => '커뮤니티 평점';

  @override
  String get criticRating => '비평가 평점';

  @override
  String get dateAdded => '추가된 날짜';

  @override
  String get datePlayed => '재생한 날짜';

  @override
  String get playCount => '재생 횟수';

  @override
  String get premiereDate => '초연(프리미어) 날짜';

  @override
  String get productionYear => '제작년도';

  @override
  String get name => '이름';

  @override
  String get random => '랜덤';

  @override
  String get revenue => '수익';

  @override
  String get runtime => '런타임(상영 시간)';

  @override
  String get syncDownloadedPlaylists => '다운로드한 플레이리스트 동기화';

  @override
  String get downloadMissingImages => '누락된 이미지 다운로드';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '누락된 이미지 $count건 다운로드',
      one: '누락된 이미지 $count건 다운로드',
      zero: '누락된 이미지 없음',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => '다운로드 에러';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count건 다운로드',
      one: '$count건 다운로드',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 아이템',
      one: '$count 아이템',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이미지 $count건',
      one: '이미지 $count건',
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
    return '$count건 완료';
  }

  @override
  String dlFailed(int count) {
    return '$count건 실패';
  }

  @override
  String dlEnqueued(int count) {
    return '$count건 대기열에 추가됨';
  }

  @override
  String dlRunning(int count) {
    return '$count건 진행중';
  }

  @override
  String get downloadErrorsTitle => '다운로드 오류';

  @override
  String get noErrors => '오류가 없습니다!';

  @override
  String get errorScreenError =>
      '오류 목록을 가져오지 못했습니다! 이 시점에서는 GitHub에 문제를 등록하고 앱 데이터를 삭제해야 합니다';

  @override
  String get failedToGetSongFromDownloadId => '다운로드 ID에서 노래를 가져오지 못했습니다';

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
    return '이 기기에서 $_temp0 \'$itemName\'를 삭제하시겠습니까?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '삭제';

  @override
  String get deleteDownloadsAbortButtonText => '취소';

  @override
  String get error => '오류';

  @override
  String discNumber(int number) {
    return '디스크 $number';
  }

  @override
  String get playButtonLabel => '재생';

  @override
  String get shuffleButtonLabel => '임의 재생';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 곡',
      one: '$count 곡',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => '플레이리스트 이름 수정';

  @override
  String get editPlaylistNameTitle => '플레이리스트 이름 수정';

  @override
  String get required => '필수 항목';

  @override
  String get updateButtonLabel => '업데이트';

  @override
  String get playlistNameUpdated => '플레이리스트 이름을 갱신했습니다.';

  @override
  String get favourite => '즐겨찾기';

  @override
  String get downloadsDeleted => '다운로드 항목을 삭제했습니다.';

  @override
  String get addDownloads => '다운로드 추가';

  @override
  String get location => '위치';

  @override
  String get downloadsAdded => '다운로드를 추가했습니다.';

  @override
  String get addButtonLabel => '추가';

  @override
  String get shareLogs => '로그(사용기록) 공유';

  @override
  String get logsCopied => '로그(사용기록) 복사함.';

  @override
  String get message => '메시지';

  @override
  String get stackTrace => '스택 추적';

  @override
  String get applicationLegalese =>
      'Mozilla Public License 2.0에 따라 라이선스가 부여됐습니다. 소스 코드는 다음에서 확인할 수 있습니다:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => '트랜스코딩';

  @override
  String get downloadLocations => '다운로드 위치';

  @override
  String get audioService => '오디오 서비스';

  @override
  String get interactions => '상호작용';

  @override
  String get layoutAndTheme => '레이아웃 & 테마';

  @override
  String get notAvailableInOfflineMode => '오프라인 모드에서는 사용할 수 없습니다';

  @override
  String get logOut => '로그아웃';

  @override
  String get downloadedSongsWillNotBeDeleted => '다운로드한 노래는 삭제되지 않습니다';

  @override
  String get areYouSure => '확실한가요?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin은 트랜스코딩에 AAC를 사용합니다';

  @override
  String get enableTranscoding => '트랜스코딩 활성화';

  @override
  String get enableTranscodingSubtitle => '서버 측에서 음악 스트리밍을 트랜스코딩 합니다.';

  @override
  String get bitrate => '비트레이트';

  @override
  String get bitrateSubtitle =>
      '비트레이트가 높으면 고품질의 음악을 들을 수 있습니다. 데이터 사용량도 증가합니다.';

  @override
  String get customLocation => '사용자 지정 위치';

  @override
  String get appDirectory => '앱 디렉토리';

  @override
  String get addDownloadLocation => '다운로드 위치 추가';

  @override
  String get selectDirectory => '디렉토리 선택';

  @override
  String get unknownError => '알수 없는 오류';

  @override
  String get pathReturnSlashErrorMessage => '\"/(슬래시)\"로 끝나는 경로는 사용할 수 없습니다';

  @override
  String get directoryMustBeEmpty => '디렉토리는 비어 있어야 합니다';

  @override
  String get customLocationsBuggy =>
      '사용자 지정 위치는 권한 문제 때문에 버그가 매우 많습니다. 이 문제를 해결할 방법을 찾을 때 까지는 사용을 권장하지 않습니다.';

  @override
  String get enterLowPriorityStateOnPause => '일시 중지시 낮은 우선순위 상태로 전환합니다';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      '일시 중지시 알림창을 밀어서 사라지게 합니다. 안드로이드(OS)에서는 일시 중지시 서비스를 강제 종료할 수 있게 합니다.';

  @override
  String get shuffleAllSongCount => '전곡 임의 재생시 곡 수';

  @override
  String get shuffleAllSongCountSubtitle =>
      '\'전곡 임의 재생\' 버튼을 사용할 때 불러올 곡의 개수입니다.';

  @override
  String get viewType => '보기 유형';

  @override
  String get viewTypeSubtitle => '음악 화면 보기 유형';

  @override
  String get list => '목록';

  @override
  String get grid => '그리드(격자)';

  @override
  String get portrait => '세로 보기';

  @override
  String get landscape => '가로 보기';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 그리드 열 갯수';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '$value 일때 한 행당 그리드 타일의 개수.';
  }

  @override
  String get showTextOnGridView => '그리드 보기에서 텍스트를 보여줌';

  @override
  String get showTextOnGridViewSubtitle =>
      '그리드 음악 화면에서 \'텍스트(곡목, 아티스트 등)\' 표시 여부를 설정합니다.';

  @override
  String get showCoverAsPlayerBackground => '흐릿한 커버를 재생 화면 배경으로 보여줌';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      '재생 화면에서 \'흐릿한 앨범 커버 배경\' 사용 여부를 설정합니다.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      '앨범 아티스트와 동일한 경우, 곡 아티스트를 숨김';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      '앨범 화면에서 앨범 아티스트와 동일한 \'곡 아티스트\' 표시 여부를 설정합니다.';

  @override
  String get disableGesture => '제스처 비활성화';

  @override
  String get disableGestureSubtitle => '제스처 비활성화 여부를 설정합니다.';

  @override
  String get showFastScroller => '빠른 스크롤 표시';

  @override
  String get theme => '테마';

  @override
  String get system => '시스템';

  @override
  String get light => '밝은 테마';

  @override
  String get dark => '어두운 테마';

  @override
  String get tabs => '탭';

  @override
  String get cancelSleepTimer => '취침 타이머를 취소할까요?';

  @override
  String get yesButtonLabel => '네';

  @override
  String get noButtonLabel => '아니오';

  @override
  String get setSleepTimer => '취침 타이머 설정';

  @override
  String get minutes => '분';

  @override
  String get invalidNumber => '잘못된 숫자';

  @override
  String get sleepTimerTooltip => '취침 타이머';

  @override
  String get addToPlaylistTooltip => '플레이리스트에 추가';

  @override
  String get addToPlaylistTitle => '플레이리스트에 추가';

  @override
  String get removeFromPlaylistTooltip => '플레이리스트에서 삭제';

  @override
  String get removeFromPlaylistTitle => '플레이리스트에서 삭제';

  @override
  String get newPlaylist => '새 플레이리스트';

  @override
  String get createButtonLabel => '만들기';

  @override
  String get playlistCreated => '플레이리스트 생성됨.';

  @override
  String get noAlbum => '앨범 없음';

  @override
  String get noItem => '곡 없음';

  @override
  String get noArtist => '아티스트 없음';

  @override
  String get unknownArtist => '알 수 없는 아티스트';

  @override
  String get streaming => '스트리밍';

  @override
  String get downloaded => '다운로드됨';

  @override
  String get transcode => '트랜스코딩';

  @override
  String get direct => '다이렉트';

  @override
  String get statusError => '상태 오류';

  @override
  String get queue => '대기열';

  @override
  String get addToQueue => '대기열에 추가';

  @override
  String get playNext => '다음 곡 재생';

  @override
  String get replaceQueue => '대기열 교체';

  @override
  String get instantMix => '인스턴트 믹스';

  @override
  String get goToAlbum => '앨범으로 이동';

  @override
  String get removeFavourite => '즐겨찾기 삭제';

  @override
  String get addFavourite => '즐겨찾기 추가';

  @override
  String get addedToQueue => '대기열 끝에 추가.';

  @override
  String get insertedIntoQueue => '대기열 중간에 추가.';

  @override
  String get queueReplaced => '대기열이 교체됨.';

  @override
  String get removedFromPlaylist => '플레이리스트에서 삭제됨.';

  @override
  String get startingInstantMix => '인스턴트 믹스 시작.';

  @override
  String get anErrorHasOccured => '오류가 발생했습니다.';

  @override
  String responseError(String error, int statusCode) {
    return '$error 상태 코드 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 상태 코드 $statusCode. 이것은 아마도 잘못된 로그인 정보를 사용했거나, 더 이상 로그인되어 있지 않음을 의미합니다.';
  }

  @override
  String get removeFromMix => '믹스에서 삭제';

  @override
  String get addToMix => '믹스에 추가';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 아이템 다시 다운로드함',
      one: '$count 아이템 다시 다운로드함',
      zero: '다시 다운로드할 필요가 없습니다.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '버퍼 시간';

  @override
  String get bufferDurationSubtitle => '플레이어가 버퍼링해야 하는 시간(초) 입니다. 다시 시작해야 합니다.';

  @override
  String get language => '언어';

  @override
  String get confirm => '확인';

  @override
  String get showUncensoredLogMessage =>
      '이 로그(사용기록)는 귀하의 로그인 정보를 포함합니다. 표시할까요?';

  @override
  String get resetTabs => '탭 초기화';

  @override
  String get noMusicLibrariesTitle => '음악 라이브러리 없음';

  @override
  String get noMusicLibrariesBody =>
      'Finamp가 음악 라이브러리를 찾을 수 없습니다. 귀하의 Jellyfin 서버에 콘텐츠 유형이 \"음악\"으로 설정된 라이브러리가 하나 이상 있는지 확인하세요.';

  @override
  String get refresh => '새로고침';

  @override
  String get swipeInsertQueueNext => '스와이프한 노래 재생';

  @override
  String get swipeInsertQueueNextSubtitle =>
      '노래 목록에서 스와이프 했을 때, 노래를 대기열 끝에 추가하는 대신 바로 다음 곡으로 삽입할 수 있습니다.';

  @override
  String get redesignBeta => '베타 버전 사용해보기';

  @override
  String get playbackOrderShuffledTooltip => '임의 재생. 전환하려면 탭하세요.';

  @override
  String get playbackOrderLinearTooltip => '순차 재생. 전환하려면 탭하세요.';

  @override
  String get loopModeAllTooltip => '모두 반복. 전환하려면 탭하세요.';

  @override
  String get loopModeOneTooltip => '한곡 반복. 전환하려면 탭하세요.';

  @override
  String get loopModeNoneTooltip => '반복 안 함. 전환하려면 탭하세요.';

  @override
  String get skipToPrevious => '이전 곡으로 넘기기';

  @override
  String get skipToNext => '다음 곡으로 넘기기';

  @override
  String get togglePlayback => '재생 전환하기';

  @override
  String playArtist(String artist) {
    return '$artist의 모든 앨범 재생';
  }

  @override
  String shuffleArtist(String artist) {
    return '$artist의 모든 앨범 임의 재생';
  }

  @override
  String downloadArtist(String artist) {
    return '$artist의 모든 앨범 다운로드';
  }

  @override
  String get deleteFromDevice => '기기에서 삭제하기';

  @override
  String get download => '다운로드';

  @override
  String get sync => '서버와 동기화하기';

  @override
  String get about => 'Finamp(핀앰프) 소개';
}
