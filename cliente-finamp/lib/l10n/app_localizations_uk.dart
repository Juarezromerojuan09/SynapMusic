// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String startupError(String error) {
    return 'Щось пішло не так під час запуску програми. помилка: $error\n\nБудь ласка, створіть проблему на github.com/UnicornsOnLSD/finamp із знімком екрана цієї сторінки. Якщо проблема не зникне, ви можете очистити дані програми, щоб скинути налаштування програми.';
  }

  @override
  String get serverUrl => 'URL серверу';

  @override
  String get internalExternalIpExplanation =>
      'Якщо ви хочете мати віддалений доступ до свого сервера Jellyfin, вам потрібно використовувати зовнішню IP-адресу.\n\nЯкщо ваш сервер використовує порт HTTP (80/443), вам не потрібно вказувати порт. Ймовірно, це буде необхідно, якщо ваш сервер знаходиться за зворотним проксі.';

  @override
  String get emptyServerUrl => 'URL серверу не може бути порожнім';

  @override
  String get urlStartWithHttps => 'URL має починатися з http:// або http://';

  @override
  String get urlTrailingSlash =>
      'URL-адреса не повинна містити косу риску в кінці';

  @override
  String get username => 'Логін';

  @override
  String get password => 'Пароль';

  @override
  String get logs => 'Логи';

  @override
  String get next => 'Далі';

  @override
  String get selectMusicLibraries => 'Виберіть музичну бібліотеку';

  @override
  String get couldNotFindLibraries =>
      'Неможливо знайти будь-яку музичну бібліотеку.';

  @override
  String get unknownName => 'Невідома назва';

  @override
  String get songs => 'Пісні';

  @override
  String get albums => 'Альбоми';

  @override
  String get artists => 'Виконавці';

  @override
  String get genres => 'Жанри';

  @override
  String get playlists => 'Списки відтворення';

  @override
  String get startMix => 'Почати перемішування';

  @override
  String get startMixNoSongsArtist =>
      'Затисніть виконавця, щоб додати або видалити його з конструктора міксів перед початком міксування';

  @override
  String get startMixNoSongsAlbum =>
      'Затисніть альбом, щоб додати або видалити його з конструктора міксів перед початком міксування';

  @override
  String get music => 'Музика';

  @override
  String get clear => 'Очистити';

  @override
  String get favourites => 'Вибране';

  @override
  String get shuffleAll => 'Перемішати все';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Завантаження';

  @override
  String get settings => 'Налаштування';

  @override
  String get offlineMode => 'Оффлайн режим';

  @override
  String get sortOrder => 'Порядок сортування';

  @override
  String get sortBy => 'Сортування за';

  @override
  String get album => 'Альбомами';

  @override
  String get albumArtist => 'Виконавцями альбомів';

  @override
  String get artist => 'Виконавцями';

  @override
  String get budget => 'Бюджет';

  @override
  String get communityRating => 'Оцінкою спільноти';

  @override
  String get criticRating => 'Оцінкою критиків';

  @override
  String get dateAdded => 'Датою додавання';

  @override
  String get datePlayed => 'Датою відтворення';

  @override
  String get playCount => 'Кількістю відтворень';

  @override
  String get premiereDate => 'Датою прем\'єри';

  @override
  String get productionYear => 'Роком виходу';

  @override
  String get name => 'Ім\'ям';

  @override
  String get random => 'Випадково';

  @override
  String get revenue => 'Дохід';

  @override
  String get runtime => 'Тривалістю';

  @override
  String get syncDownloadedPlaylists => 'Синхронізувати завантажені плейлисти';

  @override
  String get downloadMissingImages => 'Завантажити відсутні зображення';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завантажено $count відсутніх зображень',
      one: 'Завантажено $count відсутніх зображень',
      zero: 'Відсутніх зображень не знайдено',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Завантажити помилки';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Завантажень',
      one: '$count Завантажено',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count елементів',
      one: '$count елементів',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зображень',
      one: '$count Зображення',
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
    return '$count виконано';
  }

  @override
  String dlFailed(int count) {
    return '$count не вдалося';
  }

  @override
  String dlEnqueued(int count) {
    return '$count поставлено в чергу';
  }

  @override
  String dlRunning(int count) {
    return '$count запущено';
  }

  @override
  String get downloadErrorsTitle => 'Завантажити помилки';

  @override
  String get noErrors => 'Немає помилок!';

  @override
  String get errorScreenError =>
      'Під час отримання списку помилок сталася помилка! На цьому етапі вам, ймовірно, слід просто створити проблему на GitHub і видалити дані програми';

  @override
  String get failedToGetSongFromDownloadId =>
      'Не вдалося отримати пісню з ідентифікатора завантаження';

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
    return 'Ви дійсно хочете видалити $_temp0 \'$itemName\' з цього пристрою?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Видалити';

  @override
  String get deleteDownloadsAbortButtonText => 'Скасувати';

  @override
  String get error => 'Помилка';

  @override
  String discNumber(int number) {
    return 'Платівка $number';
  }

  @override
  String get playButtonLabel => 'ГРАТИ';

  @override
  String get shuffleButtonLabel => 'ПЕРЕМІШАТИ';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Пісні',
      one: '$count Пісня',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Редагувати назву плейлисту';

  @override
  String get editPlaylistNameTitle => 'Редагувати назву плейлисту';

  @override
  String get required => 'Обов\'язково';

  @override
  String get updateButtonLabel => 'ОНОВИТИ';

  @override
  String get playlistNameUpdated => 'Ім\'я плейлисту змінено.';

  @override
  String get favourite => 'Улюблене';

  @override
  String get downloadsDeleted => 'Завантаження видалено.';

  @override
  String get addDownloads => 'Додати завантаження';

  @override
  String get location => 'Збережено в';

  @override
  String get downloadsAdded => 'Завантаження додано.';

  @override
  String get addButtonLabel => 'ДОДАТИ';

  @override
  String get shareLogs => 'Поділитися логами';

  @override
  String get logsCopied => 'Логи скопійовано.';

  @override
  String get message => 'Повідомлення';

  @override
  String get stackTrace => 'Трасування стека';

  @override
  String get applicationLegalese =>
      'Ліцензовано за Mozilla Public License 2.0. Вихідний код доступний за адресою:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Транскодування';

  @override
  String get downloadLocations => 'Місце завантаження';

  @override
  String get audioService => 'Служба аудіовідтворення';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Вигляд і тема';

  @override
  String get notAvailableInOfflineMode => 'Недоступне в оффлайн режимі';

  @override
  String get logOut => 'Вийти';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Завантажені пісні не будуть видалені';

  @override
  String get areYouSure => 'Ви впевнені ?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin використовує ААС для транскодування';

  @override
  String get enableTranscoding => 'Ввімкнути транскодування';

  @override
  String get enableTranscodingSubtitle =>
      'Перекодування музичного потоку відбувається зі сторони сервера.';

  @override
  String get bitrate => 'Бітрейт';

  @override
  String get bitrateSubtitle =>
      'Вищий бітрейт забезпечує вищу якість звуку за рахунок вищої пропускної здатності.';

  @override
  String get customLocation => 'Власна папка';

  @override
  String get appDirectory => 'Тека застосунку';

  @override
  String get addDownloadLocation => 'Додати теку завантаження';

  @override
  String get selectDirectory => 'Вибрати теку';

  @override
  String get unknownError => 'Невідома помилка';

  @override
  String get pathReturnSlashErrorMessage =>
      'Шляхи, які повертають \"/\", не можна використовувати';

  @override
  String get directoryMustBeEmpty => 'Тека повинна бути порожньою';

  @override
  String get customLocationsBuggy =>
      'Користувацька текс має багато проблем через проблеми з дозволами. Я думаю, як це виправити, але поки що я б не рекомендував ними користуватися.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Перейти у стан низького пріоритету під час паузи';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Дозволяє змахнути сповіщення під час паузи. Також дозволяє Android вимикати службу під час паузи.';

  @override
  String get shuffleAllSongCount => 'Перемішати всі пісні';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Кількість пісень для завантаження при використанні кнопки перемішування всіх пісень.';

  @override
  String get viewType => 'Тип перегляду';

  @override
  String get viewTypeSubtitle => 'Тип перегляду для музичного екрану';

  @override
  String get list => 'Список';

  @override
  String get grid => 'Таблиця';

  @override
  String get portrait => 'Портретний';

  @override
  String get landscape => 'Альбомний';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Підрахунок поперечних осей сітки';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Кількість плиток сітки для використання в рядку, коли $value.';
  }

  @override
  String get showTextOnGridView => 'Показати текст при перегляді сіткою';

  @override
  String get showTextOnGridViewSubtitle =>
      'Відображати чи ні текст (назву, виконавця тощо) на музичному екрані сітки.';

  @override
  String get showCoverAsPlayerBackground =>
      'Показати розмиту обкладинку як фон гравця';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Використовувати або ні розмиту обкладинку як фон на екрані програвача.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Приховати виконавців пісень, якщо вони збігаються з виконавцями альбомів';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Чи показувати виконавців пісень на екрані альбому, якщо вони не відрізняються від виконавців альбому.';

  @override
  String get disableGesture => 'Вимкнути жести';

  @override
  String get disableGestureSubtitle => 'Чи вимикати жести.';

  @override
  String get showFastScroller => 'Показувати швидку прокрутку';

  @override
  String get theme => 'Тема';

  @override
  String get system => 'Системна';

  @override
  String get light => 'Світла';

  @override
  String get dark => 'Темна';

  @override
  String get tabs => 'Закладки';

  @override
  String get cancelSleepTimer => 'Скасувати таймер сну?';

  @override
  String get yesButtonLabel => 'ТАК';

  @override
  String get noButtonLabel => 'НІ';

  @override
  String get setSleepTimer => 'Встановити таймер сну';

  @override
  String get minutes => 'Хвилини';

  @override
  String get invalidNumber => 'Некоректне число';

  @override
  String get sleepTimerTooltip => 'Таймер сну';

  @override
  String get addToPlaylistTooltip => 'Додати до плейлисту';

  @override
  String get addToPlaylistTitle => 'Додати до плейлисту';

  @override
  String get removeFromPlaylistTooltip => 'Видалити з плейлисту';

  @override
  String get removeFromPlaylistTitle => 'Видалити з плейлисту';

  @override
  String get newPlaylist => 'Новий плейлист';

  @override
  String get createButtonLabel => 'СТВОРИТИ';

  @override
  String get playlistCreated => 'Плейлист створено.';

  @override
  String get noAlbum => 'Альбом невідомий';

  @override
  String get noItem => 'Невідомий елемент';

  @override
  String get noArtist => 'Невідомий виконавець';

  @override
  String get unknownArtist => 'Невідомий виконавець';

  @override
  String get streaming => 'ВІДТВОРЮЄТЬСЯ ЗАРАЗ';

  @override
  String get downloaded => 'ЗАВАНТАЖЕНО';

  @override
  String get transcode => 'ПЕРЕКОДОВУЄТЬСЯ';

  @override
  String get direct => 'ПРЯМЕ ВІДТВОРЕННЯ';

  @override
  String get statusError => 'ПОМИЛКОВИЙ СТАТУС';

  @override
  String get queue => 'Черга';

  @override
  String get addToQueue => 'Додати до черги';

  @override
  String get playNext => 'Відтворити наступним';

  @override
  String get replaceQueue => 'Замінити чергу';

  @override
  String get instantMix => 'Швидкий мікс';

  @override
  String get goToAlbum => 'До альбому';

  @override
  String get removeFavourite => 'Видалити з вибраного';

  @override
  String get addFavourite => 'Додати в вибране';

  @override
  String get addedToQueue => 'Додано в чергу.';

  @override
  String get insertedIntoQueue => 'Вставлено в чергу.';

  @override
  String get queueReplaced => 'Черга змінена.';

  @override
  String get removedFromPlaylist => 'Видалено з плейлисту.';

  @override
  String get startingInstantMix => 'Починається швидкий мікс.';

  @override
  String get anErrorHasOccured => 'Сталася помилка.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Код статусу $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Код статусу $statusCode. Можливо, це означає, що ви використали неправильне ім’я користувача/пароль або ваш клієнт не ввійшов в систему.';
  }

  @override
  String get removeFromMix => 'Видалити з міксу';

  @override
  String get addToMix => 'Додати до міксу';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Повторно завантажено $count елементів',
      one: 'Повторно завантажено $count елемент',
      zero: 'Повторне завантаження не потрібне.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Тривалість буферу';

  @override
  String get bufferDurationSubtitle =>
      'Скільки плеєр має буферизувати, у секундах. Вимагає перезавантаження.';

  @override
  String get language => 'Мова';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get showUncensoredLogMessage =>
      'Цей журнал містить ваші дані для входу. Показати?';

  @override
  String get resetTabs => 'Скинути вкладки';

  @override
  String get noMusicLibrariesTitle => 'Музичні бібліотеки відсутні';

  @override
  String get noMusicLibrariesBody =>
      'Finamp не знайшов жодної музичної бібліотеки. Переконайтеся, що ваш сервер Jellyfin містить принаймні одну бібліотеку з типом вмісту \"Музика\".';

  @override
  String get refresh => 'ОНОВИТИ';

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
