// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String startupError(String error) {
    return 'Coś poszło nie tak podczas startu aplikacji. Wystąpił błąd :$error\n\nProszę utworzyć zgłoszenie (https://github.com/jmshrv/finamp) wraz ze zrzutem ekranu. Jeśli problem będzie się powtarzać, usuń dane aplikacji.';
  }

  @override
  String get serverUrl => 'Adres URL serwera';

  @override
  String get internalExternalIpExplanation =>
      'Jeśli chcesz uzyskać dostęp do zdalnej instancji Jellyfin, musisz posiadać zewnętrzne IP.\n\nJeśli serwer jest dostępny na portach HTTP(S) (80/443), nie musisz określać portu.';

  @override
  String get emptyServerUrl => 'Adres URL serwera nie może być pusty';

  @override
  String get urlStartWithHttps =>
      'URL musi zaczynać się od http:// lub https://';

  @override
  String get urlTrailingSlash => 'URL nie może kończyć się znakiem \"/\"';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get logs => 'Logi';

  @override
  String get next => 'Dalej';

  @override
  String get selectMusicLibraries => 'Wybierz biblioteki z muzyką';

  @override
  String get couldNotFindLibraries => 'Nie znaleziono żadnych bibliotek.';

  @override
  String get unknownName => 'Bez nazwy';

  @override
  String get songs => 'Utwory';

  @override
  String get albums => 'Albumy';

  @override
  String get artists => 'Wykonawcy';

  @override
  String get genres => 'Gatunki';

  @override
  String get playlists => 'Listy odtwarzania';

  @override
  String get startMix => 'Rozpocznij mix';

  @override
  String get startMixNoSongsArtist =>
      'Kliknij i przytrzymaj nazwę wykonawcy, aby dodać go do mix-u przed jego rozpoczęciem';

  @override
  String get startMixNoSongsAlbum =>
      'Kliknij i przytrzymaj nazwę albumu, aby dodać go do mix-u przed jego rozpoczęciem';

  @override
  String get music => 'Muzyka';

  @override
  String get clear => 'Wyczyść';

  @override
  String get favourites => 'Ulubione';

  @override
  String get shuffleAll => 'Losuj wszystko';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Pobrane';

  @override
  String get settings => 'Ustawienia';

  @override
  String get offlineMode => 'Tryb offline';

  @override
  String get sortOrder => 'Porządek sortowania';

  @override
  String get sortBy => 'Sortuj według';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Wykonawca albumu';

  @override
  String get artist => 'Wykonawca';

  @override
  String get budget => 'Budżet';

  @override
  String get communityRating => 'Ocena społeczności';

  @override
  String get criticRating => 'Ocena krytyków';

  @override
  String get dateAdded => 'Data dodania';

  @override
  String get datePlayed => 'Data odtwarzania';

  @override
  String get playCount => 'Liczba odtworzeń';

  @override
  String get premiereDate => 'Data premiery';

  @override
  String get productionYear => 'Rok produkcji';

  @override
  String get name => 'Nazwa';

  @override
  String get random => 'Losowo';

  @override
  String get revenue => 'Dochód';

  @override
  String get runtime => 'Czas trwania';

  @override
  String get syncDownloadedPlaylists => 'Synchronizuj pobrane playlisty';

  @override
  String get downloadMissingImages => 'Pobierz brakujące obrazy';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pobrano $count brakujących obrazów',
      one: 'Pobrano $count brakujący obraz',
      zero: 'Nie brakuje żadnych obrazów',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Błędy pobierania';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobrań',
      one: '$count pobranie',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      one: '$count utwór',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obrazów',
      one: '$count obraz',
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
    return '$count ukończono pomyślnie';
  }

  @override
  String dlFailed(int count) {
    return '$count ukończono z błędami';
  }

  @override
  String dlEnqueued(int count) {
    return '$count oczekuje';
  }

  @override
  String dlRunning(int count) {
    return '$count w trakcie';
  }

  @override
  String get downloadErrorsTitle => 'Błędy pobierania';

  @override
  String get noErrors => 'Brak błędów!';

  @override
  String get errorScreenError =>
      'Wystąpił błąd podczas pobierania listy błędów. Utwórz zgłoszenie na portalu GitHub i usuń dane aplikacji';

  @override
  String get failedToGetSongFromDownloadId =>
      'Nie udało się pobrać utworu z ID pobierania';

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
    return 'Czy napewno chcesz usunąć $_temp0 \'$itemName\' z tego urządzenia?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Usuń';

  @override
  String get deleteDownloadsAbortButtonText => 'Cofnij';

  @override
  String get error => 'Błąd';

  @override
  String discNumber(int number) {
    return 'Dysk $number';
  }

  @override
  String get playButtonLabel => 'ODTWARZAJ';

  @override
  String get shuffleButtonLabel => 'LOSOWO';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      one: '$count utwór',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Edytuj nazwę listy odtwarzania';

  @override
  String get editPlaylistNameTitle => 'Edytuj nazwę listy odtwarzania';

  @override
  String get required => 'Wymagane';

  @override
  String get updateButtonLabel => 'AKTUALIZUJ';

  @override
  String get playlistNameUpdated => 'Zaktualizowano nazwę listy odtwarzania.';

  @override
  String get favourite => 'Ulubiony';

  @override
  String get downloadsDeleted => 'Usunięto pobrane.';

  @override
  String get addDownloads => 'Wszystkie pobrania';

  @override
  String get location => 'Lokalizacja';

  @override
  String get downloadsAdded => 'Dodano do pobierania.';

  @override
  String get addButtonLabel => 'DODAJ';

  @override
  String get shareLogs => 'Udostępnij logi';

  @override
  String get logsCopied => 'Logi skopiowane.';

  @override
  String get message => 'Wiadomość';

  @override
  String get stackTrace => 'Stos błędu';

  @override
  String get applicationLegalese =>
      'Licencja Mozilla Public License 2.0. Kod źródłowy dostępny na:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkodowanie';

  @override
  String get downloadLocations => 'Lokalizacje pobierania';

  @override
  String get audioService => 'Usługa audio';

  @override
  String get interactions => 'Interakcje';

  @override
  String get layoutAndTheme => 'Układ i motyw';

  @override
  String get notAvailableInOfflineMode => 'Niedostępne w trybie offline';

  @override
  String get logOut => 'Wyloguj';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Pobrane utwory nie zostaną usunięte';

  @override
  String get areYouSure => 'Czy na pewno?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin używa AAC do transkodowania';

  @override
  String get enableTranscoding => 'Włącz transkodowanie';

  @override
  String get enableTranscodingSubtitle =>
      'Transkoduje strumienie muzyczne po stronie serwera.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Wyższy bitrate dostarcza lepszą jakość, ale kosztem większego zużycia transferu danych.';

  @override
  String get customLocation => 'Własna lokalizacja';

  @override
  String get appDirectory => 'Folder aplikacji';

  @override
  String get addDownloadLocation => 'Dodaj lokalizację pobierania';

  @override
  String get selectDirectory => 'Wybierz folder';

  @override
  String get unknownError => 'Nieznany błąd';

  @override
  String get pathReturnSlashErrorMessage => 'Ścieżki nie mogą wskazywać \"/\"';

  @override
  String get directoryMustBeEmpty => 'Folder musi być pusty';

  @override
  String get customLocationsBuggy =>
      'Niestandardowe lokalizacje są bardzo kłopotliwe ze względu na problemy z uprawnieniami. W chwili obecnej ich używanie nie jest zalecane.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Przechodź w stan niskiego priorytetu w trakcie trwania pauzy';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Pozwala usunąć powiadomienie podczas pauzy. Pozwala również systemowi Android na zabicie usługi podczas pauzy.';

  @override
  String get shuffleAllSongCount => 'Maksymalna ilość losowych utworów';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Ilość utworów do załadowania kiedy użyto przycisku \"Losowo\" na wszystkich utworach.';

  @override
  String get viewType => 'Widok';

  @override
  String get viewTypeSubtitle => 'Układ elementów';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Siatka';

  @override
  String get portrait => 'Widok pionowy';

  @override
  String get landscape => 'Widok poziomy';

  @override
  String gridCrossAxisCount(String value) {
    return 'Elementy siatki ($value)';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Ilość elementów w wierszu - $value.';
  }

  @override
  String get showTextOnGridView => 'Pokaż tekst w widoku siatki';

  @override
  String get showTextOnGridViewSubtitle =>
      'Określa czy wyświetlać tekst (tytuł, wykonawca itp.) na siatce elementów.';

  @override
  String get showCoverAsPlayerBackground =>
      'Pokazuj rozmyty obraz jako tło odtwarzacza';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Określa czy używać rozmytego obrazu na ekranie odtwarzacza.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Ukryj wykonawców utworu jeśli odpowiadają wykonawcom albumu';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Określa czy wyświetlać wykonawców utworów na ekranie albumu, jeśli nie różnią się one od wykonawców albumów.';

  @override
  String get disableGesture => 'Wyłącz gesty';

  @override
  String get disableGestureSubtitle => 'Czy wyłączyć gesty.';

  @override
  String get showFastScroller => 'Pokaż szybkie przewijanie';

  @override
  String get theme => 'Motyw';

  @override
  String get system => 'Systemowy';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';

  @override
  String get tabs => 'Zakładki';

  @override
  String get cancelSleepTimer => 'Zatrzymać odliczanie?';

  @override
  String get yesButtonLabel => 'TAK';

  @override
  String get noButtonLabel => 'NIE';

  @override
  String get setSleepTimer => 'Ustaw wyłącznik czasowy';

  @override
  String get minutes => 'Minuty';

  @override
  String get invalidNumber => 'Nieprawidłowa liczba';

  @override
  String get sleepTimerTooltip => 'Wyłącznik czasowy';

  @override
  String get addToPlaylistTooltip => 'Dodaj do playlisty';

  @override
  String get addToPlaylistTitle => 'Dodaj do Playlisty';

  @override
  String get removeFromPlaylistTooltip => 'Usuń z listy odtwarzania';

  @override
  String get removeFromPlaylistTitle => 'Usuń z Listy odtwarzania';

  @override
  String get newPlaylist => 'Nowa lista odtwarzania';

  @override
  String get createButtonLabel => 'UTWÓRZ';

  @override
  String get playlistCreated => 'Utworzono listę odtwarzania.';

  @override
  String get noAlbum => 'Brak albumu';

  @override
  String get noItem => 'Brak elementu';

  @override
  String get noArtist => 'Brak artysty';

  @override
  String get unknownArtist => 'Nieznany artysta';

  @override
  String get streaming => 'STRUMIENIOWANIE';

  @override
  String get downloaded => 'Z POBRANYCH';

  @override
  String get transcode => 'TRANSKODOWANE';

  @override
  String get direct => 'BEZPOŚREDNIE';

  @override
  String get statusError => 'STATUS BŁĘDU';

  @override
  String get queue => 'Kolejka';

  @override
  String get addToQueue => 'Dodaj do kolejki';

  @override
  String get playNext => 'Następne';

  @override
  String get replaceQueue => 'Zastąp kolejkę';

  @override
  String get instantMix => 'Szybki miks';

  @override
  String get goToAlbum => 'Idź do albumu';

  @override
  String get removeFavourite => 'Usuń z ulubionych';

  @override
  String get addFavourite => 'Dodaj do ulubionych';

  @override
  String get addedToQueue => 'Dodano do kolejki.';

  @override
  String get insertedIntoQueue => 'Dodano do kolejki.';

  @override
  String get queueReplaced => 'Kolejka zastąpiona.';

  @override
  String get removedFromPlaylist => 'Usunięto z listy odtwarzania.';

  @override
  String get startingInstantMix => 'Rozpocznij szybki miks.';

  @override
  String get anErrorHasOccured => 'Wystąpił błąd.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Kod statusu $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Kod $statusCode. To najprawdopodobniej oznacza, że użyłeś/aś nieprawidłowej nazwy użytkownika lub hasła.';
  }

  @override
  String get removeFromMix => 'Usuń z miksu';

  @override
  String get addToMix => 'Dodaj do miksu';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ponownie pobrano $count elementów',
      one: 'Ponownie pobrano $count element',
      zero: 'Nie potrzeba ponownego pobierania.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Długość bufora';

  @override
  String get bufferDurationSubtitle =>
      'Ile odtwarzacz powinien buforować, w sekundach. Wymaga ponownego uruchomienia.';

  @override
  String get language => 'Język';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get showUncensoredLogMessage =>
      'Ten log zawiera twoje dane logowania. Pokazać?';

  @override
  String get resetTabs => 'Resetowanie zakładek';

  @override
  String get noMusicLibrariesTitle => 'Brak bibliotek muzycznych';

  @override
  String get noMusicLibrariesBody =>
      'Finamp nie mógł znaleźć żadnych bibliotek muzycznych. Upewnij się, że serwer Jellyfin zawiera co najmniej jedną bibliotekę z typem zawartości ustawionym na \"Muzyka\".';

  @override
  String get refresh => 'ODŚWIEŻ';

  @override
  String get swipeInsertQueueNext => 'Odtwórz Przewiniętą Piosenkę Następnie';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Włącz wstawianie utworu jako następnego elementu w kolejce po przesunięciu palcem na liście utworów zamiast dołączania go na końcu.';

  @override
  String get redesignBeta => 'Przeprojektowanie Beta';

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
