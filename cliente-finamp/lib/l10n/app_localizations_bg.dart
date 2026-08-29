// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String startupError(String error) {
    return 'Нещо се обърка по време на стартиране на приложението. Грешката беше:$error\n\nДокладвайте проблема, с екранна снимка, на github.com/UnicornsOnLSD/finamp, Ако проблемът продължава, изчистете кеша или преинсталирайте приложението.';
  }

  @override
  String get serverUrl => 'URL на сървъра';

  @override
  String get internalExternalIpExplanation =>
      'В случай, че искате да имате достъп до вашия Jellyfin сървър дистанционно, трябва да използвате външния си IP адрес.\n\nВ случай, че сървърът ви работи на HTTP порт (80/443), не е нужно да посочвате такъв. Например ако използвате обратно прокси.';

  @override
  String get emptyServerUrl => 'URL адресът на сървъра не може да бъде празен';

  @override
  String get urlStartWithHttps =>
      'URL адресът трябва да започва с http:// или https://';

  @override
  String get urlTrailingSlash =>
      'URL адресът не трябва да включва наклонена черта';

  @override
  String get username => 'Потребителско име';

  @override
  String get password => 'Парола';

  @override
  String get logs => 'Логове';

  @override
  String get next => 'Следващ';

  @override
  String get selectMusicLibraries => 'Изберете музикални библиотеки';

  @override
  String get couldNotFindLibraries => 'Не могат да бъдат открити библиотеки.';

  @override
  String get unknownName => 'Неизвестно Име';

  @override
  String get songs => 'Песни';

  @override
  String get albums => 'Албуми';

  @override
  String get artists => 'Изпълнители';

  @override
  String get genres => 'Жанрове';

  @override
  String get playlists => 'Плейлисти';

  @override
  String get startMix => 'Стартирайте разбъркано възпроизвеждане';

  @override
  String get startMixNoSongsArtist =>
      'Натиснете и задръжте върху изпълнител, за да го добавите или премахнете, от разбъркано възпроизвеждане';

  @override
  String get startMixNoSongsAlbum =>
      'Натиснете и задръжте върху албум, за да го добавите или премахнете от разбъркано възпроизвеждане';

  @override
  String get music => 'Музика';

  @override
  String get clear => 'Изчисти';

  @override
  String get favourites => 'Любими';

  @override
  String get shuffleAll => 'Възпроизвеждане в случаен ред';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Изтегляния';

  @override
  String get settings => 'Настройки';

  @override
  String get offlineMode => 'Офлайн режим';

  @override
  String get sortOrder => 'Подредба';

  @override
  String get sortBy => 'Подредба по';

  @override
  String get album => 'Албум';

  @override
  String get albumArtist => 'Изпълнител на албума';

  @override
  String get artist => 'Изпълнител';

  @override
  String get budget => 'Бюджет';

  @override
  String get communityRating => 'Обществен рейтинг';

  @override
  String get criticRating => 'Рейтинг на професионалната общност';

  @override
  String get dateAdded => 'Дата на добавяне';

  @override
  String get datePlayed => 'Дата на последно изпълнение';

  @override
  String get playCount => 'Брой изпълнения';

  @override
  String get premiereDate => 'Премиерна дата';

  @override
  String get productionYear => 'Година на издаване';

  @override
  String get name => 'Име';

  @override
  String get random => 'Произволно';

  @override
  String get revenue => 'Приходи';

  @override
  String get runtime => 'Продължителност';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Изтегляне на липсващите изображения';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изтегляне $count липсващи изображения',
      one: 'Изтегляне $count липсващи изображения',
      zero: 'Не са открити липсващи изображения',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Грешки при изтеглянето';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изтегляне',
      one: '$count изтегляне',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count елементи',
      one: '$count елемент',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изображения',
      one: '$count изображение',
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
    return '$count завършено';
  }

  @override
  String dlFailed(int count) {
    return '$count грешка';
  }

  @override
  String dlEnqueued(int count) {
    return '$count опашка';
  }

  @override
  String dlRunning(int count) {
    return '$count изпълнява се';
  }

  @override
  String get downloadErrorsTitle => 'Грешки при изтегляне';

  @override
  String get noErrors => 'Без грешки!';

  @override
  String get errorScreenError =>
      'Възникна грешка при получаване на списъка с грешки! Преинсталирайте приложението и съобщете за проблема на GitHub';

  @override
  String get failedToGetSongFromDownloadId =>
      'Неуспех при получаване на песен, посредством ID на изтегляне';

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
  String get error => 'Грешка';

  @override
  String discNumber(int number) {
    return 'Диск $number';
  }

  @override
  String get playButtonLabel => 'ПУСНИ';

  @override
  String get shuffleButtonLabel => 'РАЗБЪРКАНО';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Песни',
      one: '$count Песен',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip =>
      'Редактирай името на списъка за изпълнение';

  @override
  String get editPlaylistNameTitle =>
      'Редактирай името на списъка за изпълнение';

  @override
  String get required => 'Задължително';

  @override
  String get updateButtonLabel => 'АКТУАЛИЗАЦИЯ';

  @override
  String get playlistNameUpdated =>
      'Името на списъка за изпълнение е обновено.';

  @override
  String get favourite => 'Любими';

  @override
  String get downloadsDeleted => 'Изтеглянията са изтрити.';

  @override
  String get addDownloads => 'Добави за изтегляне';

  @override
  String get location => 'Местоположение';

  @override
  String get downloadsAdded => 'Добавено в изтегляния.';

  @override
  String get addButtonLabel => 'ДОБАВИ';

  @override
  String get shareLogs => 'Споделете логовете';

  @override
  String get logsCopied => 'Логове копирани.';

  @override
  String get message => 'Съобщение';

  @override
  String get stackTrace => 'Проследяване на стека';

  @override
  String get applicationLegalese =>
      'Лиценз Mozilla Public License 2.0. Програмният код е достъпен на:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Транскодиране';

  @override
  String get downloadLocations => 'Местоположение на изтеглянията';

  @override
  String get audioService => 'Аудио услуга';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Оформление и тема';

  @override
  String get notAvailableInOfflineMode => 'Недостъпно в офлайн режим';

  @override
  String get logOut => 'Излезте от профила си';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Изтеглените песни няма да бъдат изтрити';

  @override
  String get areYouSure => 'Сигурни ли сте?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin използва AAC за транскодиране';

  @override
  String get enableTranscoding => 'Активиране на транскодирането';

  @override
  String get enableTranscodingSubtitle =>
      'Транскодирането на музикалните потоци се осъществява от страна на сървъра.';

  @override
  String get bitrate => 'Битрейт';

  @override
  String get bitrateSubtitle =>
      'По-високият битрейт гарантира висококачествено аудио за сметка на завишен мрежови трафик.';

  @override
  String get customLocation => 'Персонализирано местоположение';

  @override
  String get appDirectory => 'Директория на приложението';

  @override
  String get addDownloadLocation => 'Добавете местоположение за изтегляне';

  @override
  String get selectDirectory => 'Изберете директория';

  @override
  String get unknownError => 'Неизвестна грешка';

  @override
  String get pathReturnSlashErrorMessage =>
      'Невъзможно е указването на път, използващ \"/\"';

  @override
  String get directoryMustBeEmpty => 'Директорията трябва да е празна';

  @override
  String get customLocationsBuggy =>
      'Персонализираните местоположения са изключително нестабилни, поради проблеми с правата. Обмислям варианти са справяне с проблема, но за сега непрепоръчвам тяхното използване.';

  @override
  String get enterLowPriorityStateOnPause =>
      'При пауза, използвай режим на нисък приоритет';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Известията да бъдат отхвърлени при пауза. Също така позволи на Android да прекрати услугата при пауза.';

  @override
  String get shuffleAllSongCount => 'Разбъркайте всички песни';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Брой песни за зареждане при използване на бутона за разбъркване на всички песни.';

  @override
  String get viewType => 'Вид преглед';

  @override
  String get viewTypeSubtitle => 'Вид преглед на плейъра';

  @override
  String get list => 'Списък';

  @override
  String get grid => 'Решетка';

  @override
  String get portrait => 'Портретен';

  @override
  String get landscape => 'Пейзажен';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Брой елементи в решетката';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Броят на показваните елементи на ред, когато $value.';
  }

  @override
  String get showTextOnGridView => 'Показване на текст в решетъчен изглед';

  @override
  String get showTextOnGridViewSubtitle =>
      'Дали да се показва или не текст (името на песента, изпълнителя и т.н.), в решетъчен режим.';

  @override
  String get showCoverAsPlayerBackground =>
      'Показване на замъглена обложка като фон на плейъра';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Дали да се показва или не, замъглена обложка на албума като фон на плейъра.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Скриване изпълнителя на песента, ако е същият като изпълнителя на албума';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Дали да се покаже изпълнителят на песента на екрана, ако не се различава от изпълнителя на албума.';

  @override
  String get disableGesture => 'Disable gestures';

  @override
  String get disableGestureSubtitle => 'Whether to disables gestures.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Тема';

  @override
  String get system => 'Система';

  @override
  String get light => 'Светла';

  @override
  String get dark => 'Тъмна';

  @override
  String get tabs => 'Раздели';

  @override
  String get cancelSleepTimer => 'Отмяна на таймера?';

  @override
  String get yesButtonLabel => 'Да';

  @override
  String get noButtonLabel => 'Не';

  @override
  String get setSleepTimer => 'Задаване на таймер';

  @override
  String get minutes => 'Минути';

  @override
  String get invalidNumber => 'Невалидно число';

  @override
  String get sleepTimerTooltip => 'Таймер';

  @override
  String get addToPlaylistTooltip => 'Добавяне към списъка за изпълнение';

  @override
  String get addToPlaylistTitle => 'Добавяне към списъка за изпълнение';

  @override
  String get removeFromPlaylistTooltip => 'Remove from playlist';

  @override
  String get removeFromPlaylistTitle => 'Remove from Playlist';

  @override
  String get newPlaylist => 'Нов списък за изпълнение';

  @override
  String get createButtonLabel => 'Създаване';

  @override
  String get playlistCreated => 'Списъкът за изпълнение е създаден.';

  @override
  String get noAlbum => 'Липсващ албум';

  @override
  String get noItem => 'Липсващ файл';

  @override
  String get noArtist => 'Липсващ изпълнител';

  @override
  String get unknownArtist => 'Неизвестен изпълнител';

  @override
  String get streaming => 'Стрийминг';

  @override
  String get downloaded => 'Изтегляне';

  @override
  String get transcode => 'Транскодиране';

  @override
  String get direct => 'Непосредствен';

  @override
  String get statusError => 'Грешка в състоянието';

  @override
  String get queue => 'Опашка';

  @override
  String get addToQueue => 'Добавяне към опашката';

  @override
  String get playNext => 'Play Next';

  @override
  String get replaceQueue => 'Заменете опашката';

  @override
  String get instantMix => 'Незабавен микс';

  @override
  String get goToAlbum => 'Отидете в албума';

  @override
  String get removeFavourite => 'Премахнете любими';

  @override
  String get addFavourite => 'Добавете в любими';

  @override
  String get addedToQueue => 'Добавено към опашката.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Опашката е заменена.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Стартиране на незабавен микс.';

  @override
  String get anErrorHasOccured => 'Появи се грешка.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Код на грешката $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Код на грешката $statusCode. Това вероятно означава, че сте използвали грешно потребителско име/парола, или вашият клиент вече не е удостоверен.';
  }

  @override
  String get removeFromMix => 'Премахни от микса';

  @override
  String get addToMix => 'Добави към микса';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Повторно изтегляне $count елементи',
      one: 'Повторно изтегляне $count елемент',
      zero: 'Не е необходимо повторно изтегляне.',
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
