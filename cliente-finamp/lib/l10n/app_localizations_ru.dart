// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String startupError(String error) {
    return 'Что-то пошло не так во время запуска приложения. Возникла ошибка: $error\n\nПожалуйста, создайте \"issue\" на github.com/UnicornsOnLSD/finamp и приложите скриншот этой страницы. Если проблема будет повторяться, вы можете очистить данные приложения, чтобы сбросить его настройки.';
  }

  @override
  String get serverUrl => 'URL сервера';

  @override
  String get internalExternalIpExplanation =>
      'Чтобы получить удалённый доступ к серверу Jellyfin, используйте внешний IP-адрес.\n\nЕсли ваш сервер работает на портах HTTP(S) 80/443, указывать порт не нужно. Это обычно так, если сервер находится за обратным прокси-сервером.';

  @override
  String get emptyServerUrl => 'URL сервера не может быть пустым';

  @override
  String get urlStartWithHttps =>
      'URL сервера должно начинаться с http:// или https://';

  @override
  String get urlTrailingSlash => 'URL сервера не должен иметь / в конце';

  @override
  String get username => 'Логин';

  @override
  String get password => 'Пароль';

  @override
  String get logs => 'Логи';

  @override
  String get next => 'Далее';

  @override
  String get selectMusicLibraries => 'Выбрать музыкальные библиотеки';

  @override
  String get couldNotFindLibraries => 'Библиотеки не найдены.';

  @override
  String get unknownName => 'Неизвестное Имя';

  @override
  String get songs => 'Песни';

  @override
  String get albums => 'Альбомы';

  @override
  String get artists => 'Исполнители';

  @override
  String get genres => 'Жанры';

  @override
  String get playlists => 'Плейлисты';

  @override
  String get startMix => 'Начать Микс';

  @override
  String get startMixNoSongsArtist =>
      'Чтобы добавить или удалить исполнителя из микса, нажмите и удерживайте его имя';

  @override
  String get startMixNoSongsAlbum =>
      'Чтобы добавить или удалить альбом из микса, нажмите и удерживайте его';

  @override
  String get music => 'Музыка';

  @override
  String get clear => 'Очистить';

  @override
  String get favourites => 'Избранное';

  @override
  String get shuffleAll => 'Перемешать всё';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Загрузки';

  @override
  String get settings => 'Настройки';

  @override
  String get offlineMode => 'Автономный режим';

  @override
  String get sortOrder => 'Порядок сортировки';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get album => 'Альбом';

  @override
  String get albumArtist => 'Исполнитель Альбома';

  @override
  String get artist => 'Исполнитель';

  @override
  String get budget => 'Бюджет';

  @override
  String get communityRating => 'Рейтинг Сообщества';

  @override
  String get criticRating => 'Рейтинг Критиков';

  @override
  String get dateAdded => 'Дата Добавления';

  @override
  String get datePlayed => 'Дата Последнего Проигрывания';

  @override
  String get playCount => 'Всего Проигрываний';

  @override
  String get premiereDate => 'Дата Премьеры';

  @override
  String get productionYear => 'Год Создания';

  @override
  String get name => 'Имя';

  @override
  String get random => 'Случайно';

  @override
  String get revenue => 'Доход';

  @override
  String get runtime => 'Время выполнения';

  @override
  String get syncDownloadedPlaylists =>
      'Синхронизировать загруженные плейлисты';

  @override
  String get downloadMissingImages => 'Скачать отсутствующие изображения';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скачано $count отсутствующих изображений',
      few: 'Скачано $count отсутствующих изображения',
      one: 'Скачано $count отсутствующее изображение',
      zero: 'Не найдено отсутствующих изображений',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Ошибки Скачивания';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загрузок',
      few: '$count загрузки',
      one: '$count загрузка',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файлы',
      few: '$count файла',
      one: '$count файл',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изображений',
      few: '$count изображения',
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
    return '$count завершено';
  }

  @override
  String dlFailed(int count) {
    return '$count не удалось';
  }

  @override
  String dlEnqueued(int count) {
    return '$count в очереди';
  }

  @override
  String dlRunning(int count) {
    return '$count скачиваются';
  }

  @override
  String get downloadErrorsTitle => 'Ошибки Загрузки';

  @override
  String get noErrors => 'Ошибок нет!';

  @override
  String get errorScreenError =>
      'Ошибка при получении списка ошибок! Скорее всего, вам нужно очистить данные приложения и сообщить о данной ошибке на Github';

  @override
  String get failedToGetSongFromDownloadId =>
      'Не удалось запросить песню с ID загрузки';

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
    return 'Вы уверены, что хотите удалить $_temp0 \'$itemName\' с этого устройства?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Удалить';

  @override
  String get deleteDownloadsAbortButtonText => 'Отмена';

  @override
  String get error => 'Ошибка';

  @override
  String discNumber(int number) {
    return 'Диск $number';
  }

  @override
  String get playButtonLabel => 'ИГРАТЬ';

  @override
  String get shuffleButtonLabel => 'СЛУЧАЙНО';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Редактировать название плейлиста';

  @override
  String get editPlaylistNameTitle => 'Изменить название плейлиста';

  @override
  String get required => 'Необходимо';

  @override
  String get updateButtonLabel => 'ОБНОВИТЬ';

  @override
  String get playlistNameUpdated => 'Название плейлиста обновлено.';

  @override
  String get favourite => 'В избранное';

  @override
  String get downloadsDeleted => 'Загрузки удалены.';

  @override
  String get addDownloads => 'Добавить в загрузки';

  @override
  String get location => 'Расположение';

  @override
  String get downloadsAdded => 'Добавлено в загрузки.';

  @override
  String get addButtonLabel => 'ДОБАВИТЬ';

  @override
  String get shareLogs => 'Поделиться логами';

  @override
  String get logsCopied => 'Логи скопированы.';

  @override
  String get message => 'Сообщение';

  @override
  String get stackTrace => 'Отслеживание стека';

  @override
  String get applicationLegalese =>
      'Лицензия Mozilla Public License 2.0. Открытый код приложения доступен по ссылке:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Транскодирование';

  @override
  String get downloadLocations => 'Расположение Загрузок';

  @override
  String get audioService => 'Аудиосервис';

  @override
  String get interactions => 'Взаимодействия';

  @override
  String get layoutAndTheme => 'Макет и тема';

  @override
  String get notAvailableInOfflineMode => 'Недоступно без интернета';

  @override
  String get logOut => 'Выйти';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Скачанные песни не будут удалены';

  @override
  String get areYouSure => 'Вы уверены?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin использует AAC для транскодирования';

  @override
  String get enableTranscoding => 'Включить транскодирование';

  @override
  String get enableTranscodingSubtitle =>
      'Треки будут транскодированы сервером.';

  @override
  String get bitrate => 'Битрейт';

  @override
  String get bitrateSubtitle =>
      'Высокий битрейт обеспечивает лучшее качество звука за счет большего потребления трафика.';

  @override
  String get customLocation => 'Пользовательские Папки';

  @override
  String get appDirectory => 'Папка Приложения';

  @override
  String get addDownloadLocation => 'Добавить папку для загрузок';

  @override
  String get selectDirectory => 'Выбрать папку';

  @override
  String get unknownError => 'Неизвестная Ошибка';

  @override
  String get pathReturnSlashErrorMessage =>
      'Невозможно указывать пути, использующие \"/\"';

  @override
  String get directoryMustBeEmpty => 'Папка должна быть пустой';

  @override
  String get customLocationsBuggy =>
      'Пользовательские папки крайне нестабильны в связи с ошибками доступа. Я размышляю над тем, как это исправить, но пока я не рекомендую Вам их использовать.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Использовать режим низкого приоритета на Паузе';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Позволяет смахнуть уведомление на паузе. Также позволяет андроиду остановить сервис на паузе.';

  @override
  String get shuffleAllSongCount => 'Перемешать порядок всех песен';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Количество песен для загрузки в режиме случайного проигрывания.';

  @override
  String get viewType => 'Тип вида';

  @override
  String get viewTypeSubtitle => 'Тип вида плеера';

  @override
  String get list => 'Список';

  @override
  String get grid => 'Решётка';

  @override
  String get portrait => 'Портретный';

  @override
  String get landscape => 'Альбомный';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Количество элементов решётки';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Количество отображаемых элементов решётки построчно, когда $value.';
  }

  @override
  String get showTextOnGridView => 'Отображать текст в режиме решётки';

  @override
  String get showTextOnGridViewSubtitle =>
      'Отображать или нет текст (название песни, исполнителя и т.д.) в режиме решётки.';

  @override
  String get showCoverAsPlayerBackground =>
      'Показывать размытую обложку на фоне';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Отображать или нет размытую обложку альбома как фон в плеере.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Не отображать одинаковых исполнителей для трека и альбома';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Отображать исполнителя трека на странице альбома, если он совпадает с исполнителем альбома.';

  @override
  String get disableGesture => 'Отключить жесты';

  @override
  String get disableGestureSubtitle => 'Стоит ли отключать жесты.';

  @override
  String get showFastScroller => 'Показать быструю прокрутку';

  @override
  String get theme => 'Тема оформления';

  @override
  String get system => 'Системная';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get tabs => 'Вкладки';

  @override
  String get cancelSleepTimer => 'Выключить Таймер?';

  @override
  String get yesButtonLabel => 'ДА';

  @override
  String get noButtonLabel => 'НЕТ';

  @override
  String get setSleepTimer => 'Поставить Таймер';

  @override
  String get minutes => 'Минуты';

  @override
  String get invalidNumber => 'Неправильное Число';

  @override
  String get sleepTimerTooltip => 'Таймер';

  @override
  String get addToPlaylistTooltip => 'Добавить в плейлист';

  @override
  String get addToPlaylistTitle => 'Добавить в Плейлист';

  @override
  String get removeFromPlaylistTooltip => 'Удалить из плейлиста';

  @override
  String get removeFromPlaylistTitle => 'Удалить из Плейлиста';

  @override
  String get newPlaylist => 'Новый Плейлист';

  @override
  String get createButtonLabel => 'СОЗДАТЬ';

  @override
  String get playlistCreated => 'Плейлист создан.';

  @override
  String get noAlbum => 'Нет Альбома';

  @override
  String get noItem => 'Нет Элементов';

  @override
  String get noArtist => 'Нет Исполнителя';

  @override
  String get unknownArtist => 'Неизвестный Исполнитель';

  @override
  String get streaming => 'СТРИМИНГ';

  @override
  String get downloaded => 'ЗАГРУЖЕНО';

  @override
  String get transcode => 'ТРАНСКОДИРОВАНО';

  @override
  String get direct => 'ПРЯМОЙ';

  @override
  String get statusError => 'ОШИБКА СТАТУСА';

  @override
  String get queue => 'Очередь';

  @override
  String get addToQueue => 'Добавить в Очередь';

  @override
  String get playNext => 'Воспроизвести Следующей';

  @override
  String get replaceQueue => 'Заменить Очередь';

  @override
  String get instantMix => 'Мгновенный Микс';

  @override
  String get goToAlbum => 'Перейти к Альбому';

  @override
  String get removeFavourite => 'Удалить из Избранного';

  @override
  String get addFavourite => 'Добавить в Избранное';

  @override
  String get addedToQueue => 'Добавлено в очередь.';

  @override
  String get insertedIntoQueue => 'Вставлено в очередь.';

  @override
  String get queueReplaced => 'Очередь заменена.';

  @override
  String get removedFromPlaylist => 'Удалено из плейлиста.';

  @override
  String get startingInstantMix => 'Запуск мгновенного микса.';

  @override
  String get anErrorHasOccured => 'Произошла ошибка.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Код состояния $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Код состояния $statusCode. Возможно, вы использовали неверное имя пользователя/пароль или ваш клиент больше не авторизован.';
  }

  @override
  String get removeFromMix => 'Удалить из Микса';

  @override
  String get addToMix => 'Добавить в Микс';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Повторно загружено $count элементов',
      few: 'Повторно загружены $count элемента',
      one: 'Повторно загружен $count элемент',
      zero: 'Не требуется повторная загрузка.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Длительность буферизации';

  @override
  String get bufferDurationSubtitle =>
      'Размер буфера плеера (в секундах). Требуется перезапуск.';

  @override
  String get language => 'Язык';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get showUncensoredLogMessage =>
      'Этот лог содержит ваши данные для входа. Показать?';

  @override
  String get resetTabs => 'Сбросить вкладки';

  @override
  String get noMusicLibrariesTitle => 'Нет музыкальных библиотек';

  @override
  String get noMusicLibrariesBody =>
      'Finamp не обнаружил музыкальных библиотек. Убедитесь, что на вашем сервере Jellyfin есть хотя бы одна библиотека с типом контента \"Музыка\".';

  @override
  String get refresh => 'ОБНОВИТЬ';

  @override
  String get swipeInsertQueueNext => 'Воспроизвести смахнутую песню следующей';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Разрешить вставлять песню следующей в очереди при свайпе в списке песен, а не добавлять ее в конец.';

  @override
  String get redesignBeta => 'Новый дизайн (бета)';

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
