// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String startupError(String error) {
    return 'Während dem Starten der App ist etwas schief gelaufen. Der Fehler war: $error\n\nBitte öffne ein Issue auf github.com/UnicornsOnLSD/finamp mit einem Bildschirmfoto von dieser Seite. Wenn dieses Problem weiterhin besteht, kannst du deine App-Daten löschen, um die App zurückzusetzen.';
  }

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get internalExternalIpExplanation =>
      'Wenn du deinen Jellyfin Server aus der Ferne erreichen möchtest, benötigst du eine externe IP.\n\nWenn dein Server einen HTTP Port (80/443) benutzt, musst du keinen Port festlegen. Dies ist vermutlich der Fall wenn dein Server sich hinter einer Reverse Proxy befindet.';

  @override
  String get emptyServerUrl => 'Server-URL darf nicht leer sein';

  @override
  String get urlStartWithHttps => 'URL muss mit http:// oder https:// beginnen';

  @override
  String get urlTrailingSlash =>
      'URL darf keinen Schrägstrich am Ende enthalten';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get logs => 'Protokolle';

  @override
  String get next => 'Weiter';

  @override
  String get selectMusicLibraries => 'Musikbibliotheken auswählen';

  @override
  String get couldNotFindLibraries => 'Konnte keine Bibliotheken finden.';

  @override
  String get unknownName => 'Unbekannter Name';

  @override
  String get songs => 'Lieder';

  @override
  String get albums => 'Alben';

  @override
  String get artists => 'Künstler';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Playlists';

  @override
  String get startMix => 'Starte Mix';

  @override
  String get startMixNoSongsArtist =>
      'Vor dem Starten eines Mixes lange auf einen Künstler gedrückt halten, um ihn zum Mixzusammensteller hinzuzufügen oder zu entfernen';

  @override
  String get startMixNoSongsAlbum =>
      'Vor dem Starten eines Mixes lange auf ein Album gedrückt halten, um es zum Mixzusammensteller hinzuzufügen oder zu entfernen';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Entfernen';

  @override
  String get favourites => 'Favoriten';

  @override
  String get shuffleAll => 'Alle mischen';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Einstellungen';

  @override
  String get offlineMode => 'Offline-Modus';

  @override
  String get sortOrder => 'Sortierreihenfolge';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumkünstler';

  @override
  String get artist => 'Künstler';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Community-Bewertung';

  @override
  String get criticRating => 'Kritikerbewertung';

  @override
  String get dateAdded => 'Datum hinzugefügt';

  @override
  String get datePlayed => 'Datum gespielt';

  @override
  String get playCount => 'Anzahl abgespielt';

  @override
  String get premiereDate => 'Erscheinungsdatum';

  @override
  String get productionYear => 'Produktionsjahr';

  @override
  String get name => 'Name';

  @override
  String get random => 'Zufällig';

  @override
  String get revenue => 'Einspielergebnis';

  @override
  String get runtime => 'Dauer';

  @override
  String get syncDownloadedPlaylists =>
      'Heruntergeladene Playlisten synchronisieren';

  @override
  String get downloadMissingImages => 'Fehlende Bilder herunterladen';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fehlende Bilder heruntergeladen',
      one: '$count fehlendes Bild heruntergeladen',
      zero: 'Keine fehlenden Bilder gefunden',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Download-Fehler';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads',
      one: '$count Download',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '$count Element',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bilder',
      one: '$count Bild',
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
    return '$count fertiggestellt';
  }

  @override
  String dlFailed(int count) {
    return '$count fehlgeschlagen';
  }

  @override
  String dlEnqueued(int count) {
    return '$count in der Warteschlange';
  }

  @override
  String dlRunning(int count) {
    return '$count laufend';
  }

  @override
  String get downloadErrorsTitle => 'Download-Fehler';

  @override
  String get noErrors => 'Keine Fehler!';

  @override
  String get errorScreenError =>
      'Beim Erstellen der Fehlerliste kam es zu einem Fehler! An dieser Stelle solltest du ein Fehlerticket auf GitHub erstellen und die App-Daten löschen';

  @override
  String get failedToGetSongFromDownloadId =>
      'Song konnte nicht über die Download-ID abgerufen werden';

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
    return 'Bist du sicher, dass du $_temp0 \'$itemName\' von diesem Gerät löschen willst?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Löschen';

  @override
  String get deleteDownloadsAbortButtonText => 'Abbrechen';

  @override
  String get error => 'Fehler';

  @override
  String discNumber(int number) {
    return 'CD $number';
  }

  @override
  String get playButtonLabel => 'ABSPIELEN';

  @override
  String get shuffleButtonLabel => 'MISCHEN';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '$count Titel',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Wiedergabeliste-Name editieren';

  @override
  String get editPlaylistNameTitle => 'Wiedergabeliste-Name editieren';

  @override
  String get required => 'Erforderlich';

  @override
  String get updateButtonLabel => 'AKTUALISIERUNG';

  @override
  String get playlistNameUpdated => 'Wiedergabeliste-Name aktualisiert.';

  @override
  String get favourite => 'Favorit';

  @override
  String get downloadsDeleted => 'Downloads gelöscht.';

  @override
  String get addDownloads => 'Downloads hinzufügen';

  @override
  String get location => 'Ort';

  @override
  String get downloadsAdded => 'Downloads hinzugefügt.';

  @override
  String get addButtonLabel => 'Hinzufügen';

  @override
  String get shareLogs => 'Protokolle teilen';

  @override
  String get logsCopied => 'Protokolle kopiert.';

  @override
  String get message => 'Nachricht';

  @override
  String get stackTrace => 'Stacktrace';

  @override
  String get applicationLegalese =>
      'Lizensiert mit der Mozilla Public License 2.0. Quellcode verfügbar unter:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transkodierung';

  @override
  String get downloadLocations => 'Download Orte';

  @override
  String get audioService => 'Audio Service';

  @override
  String get interactions => 'Interaktionen';

  @override
  String get layoutAndTheme => 'Aufbau & Thema';

  @override
  String get notAvailableInOfflineMode => 'Im Offline-Modus nicht verfügbar';

  @override
  String get logOut => 'Abmelden';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Heruntergeladene Lieder werden nicht gelöscht';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin verwendet AAC zur Transkodierung';

  @override
  String get enableTranscoding => 'Transkodierung aktivieren';

  @override
  String get enableTranscodingSubtitle =>
      'Transkodiert Musikstreams serverseitig.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Eine höhere Bitrate verbessert die Audioqualität auf Kosten der benötigten Bandbreite.';

  @override
  String get customLocation => 'Benutzerdefinierter Ort';

  @override
  String get appDirectory => 'App-Verzeichnis';

  @override
  String get addDownloadLocation => 'Download-Ort hinzufügen';

  @override
  String get selectDirectory => 'Verzeichnis auswählen';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get pathReturnSlashErrorMessage =>
      'Pfade die mit \"/\" antworten können nicht genutzt werden';

  @override
  String get directoryMustBeEmpty => 'Verzeichnis muss leer sein';

  @override
  String get customLocationsBuggy =>
      'Benutzerdefinierte Orte sind extrem fehlerbehaftet aufgrund von Problemen mit Berechtigungen. Ich denke über Möglichkeiten nach, um dies zu beheben, aber im Moment würde ich davon abraten, diese zu nutzen.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Niedrige Priorität-Modus beim Pausieren aktivieren';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Ermöglicht, dass die Benachrichtigung im pausierten Zustand weggewischt werden kann. Dies erlaubt es Android ebenfalls, den Prozess im pausierten Zustand zu terminieren.';

  @override
  String get shuffleAllSongCount => 'Mische-Alle Titelanzahl';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Die Anzahl der zu ladenden Titel wenn der Mische-Alle Knopf betätigt wird.';

  @override
  String get viewType => 'Ansichtsart';

  @override
  String get viewTypeSubtitle => 'Ansichtsart für den Musik-Bildschirm';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Raster';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Landschaft';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Raster Querachsen-Anzahl';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Menge der zu benutzenden Rasterkacheln wenn $value.';
  }

  @override
  String get showTextOnGridView => 'Text in Rasteransicht anzeigen';

  @override
  String get showTextOnGridViewSubtitle =>
      'Ob oder nicht Text (Titel, Künstler etc.) auf dem Raster des Musikbildschirms angezeigt werden soll.';

  @override
  String get showCoverAsPlayerBackground =>
      'Zeige verschwommene Cover als Player-Hintergrund';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Ob oder nicht verschwommene Cover als Hintergrund im Player-Bildschirm benutzt werden sollen.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Verstecke Titel-Künstler falls derselbe wie Album-Künstler';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Ob Titel-Künstler in der Albenansicht angezeigt werden sollen, falls sie sich nicht von den Album-Künstlern unterscheiden.';

  @override
  String get disableGesture => 'Gesten deaktivieren';

  @override
  String get disableGestureSubtitle => 'Ob Gesten deaktiviert werden sollen.';

  @override
  String get showFastScroller => 'Schnellen Scroller anzeigen';

  @override
  String get theme => 'Thema';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get tabs => 'Tabs';

  @override
  String get cancelSleepTimer => 'Schlaf-Timer abbrechen?';

  @override
  String get yesButtonLabel => 'JA';

  @override
  String get noButtonLabel => 'NEIN';

  @override
  String get setSleepTimer => 'Schlaf-Timer einstellen';

  @override
  String get minutes => 'Minuten';

  @override
  String get invalidNumber => 'Ungültige Zahl';

  @override
  String get sleepTimerTooltip => 'Schlaf-Timer';

  @override
  String get addToPlaylistTooltip => 'Zur Wiedergabeliste hinzufügen';

  @override
  String get addToPlaylistTitle => 'Zur Wiedergabeliste hinzufügen';

  @override
  String get removeFromPlaylistTooltip => 'Aus Wiedergabeliste entfernen';

  @override
  String get removeFromPlaylistTitle => 'Aus Wiedergabeliste entfernen';

  @override
  String get newPlaylist => 'Neue Wiedergabeliste';

  @override
  String get createButtonLabel => 'ERSTELLEN';

  @override
  String get playlistCreated => 'Wiedergabeliste erstellt.';

  @override
  String get noAlbum => 'Kein Album';

  @override
  String get noItem => 'Kein Element';

  @override
  String get noArtist => 'Kein Künstler';

  @override
  String get unknownArtist => 'Unbekannter Künstler';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'HERUNTERGELADEN';

  @override
  String get transcode => 'TRANSKODIERUNG';

  @override
  String get direct => 'DIREKT';

  @override
  String get statusError => 'STATUS FEHLER';

  @override
  String get queue => 'Warteschlange';

  @override
  String get addToQueue => 'Zur Warteschlange hinzufügen';

  @override
  String get playNext => 'Als Nächstes wiedergeben';

  @override
  String get replaceQueue => 'Warteschlange austauschen';

  @override
  String get instantMix => 'Sofort Mix';

  @override
  String get goToAlbum => 'Gehe zu Album';

  @override
  String get removeFavourite => 'Favorit entfernen';

  @override
  String get addFavourite => 'Favorit hinzufügen';

  @override
  String get addedToQueue => 'Zur Warteschlange hinzugefügt.';

  @override
  String get insertedIntoQueue => 'Zur Warteschlange hinzufügen.';

  @override
  String get queueReplaced => 'Warteschlange ausgetauscht.';

  @override
  String get removedFromPlaylist => 'Aus der Wiedergabeliste entfernt.';

  @override
  String get startingInstantMix => 'Starte Sofort-Mix.';

  @override
  String get anErrorHasOccured => 'Ein Fehler ist aufgetreten.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status Code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status Code $statusCode. Dies bedeutet vermutlich, dass du den falschen Benutzernamen oder Passwort benutzt hast oder dass dein Client nicht länger authentifiziert ist.';
  }

  @override
  String get removeFromMix => 'Aus Mix entfernen';

  @override
  String get addToMix => 'Zu Mix hinzufügen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente erneut heruntergeladen',
      one: '$count Element erneut heruntergeladen',
      zero: 'Keine erneuten Downloads notwendig.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Pufferdauer';

  @override
  String get bufferDurationSubtitle =>
      'Wie viel gepuffert werden soll, in Sekunden. Neustart erforderlich.';

  @override
  String get language => 'Sprache';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get showUncensoredLogMessage =>
      'Dieses Protokoll enthält deine Anmeldedaten. Anzeigen?';

  @override
  String get resetTabs => 'Tabs zurücksetzen';

  @override
  String get noMusicLibrariesTitle => 'Keine Musik-Bibliotheken';

  @override
  String get noMusicLibrariesBody =>
      'Finamp konnte keine Musikbibliotheken finden. Bitte stelle sicher, dass dein Jellyfin-Server mindestens eine Bibliothek mit dem Medientyp \"Musik\" enthält.';

  @override
  String get refresh => 'AKTUALISIEREN';

  @override
  String get swipeInsertQueueNext => 'Gewischtes Lied als Nächstes abspielen';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Aktivieren, um das in der Liste nach links/rechts gewischte Lied als Nächstes abzuspielen, statt es am Ende der Warteschlange einzufügen.';

  @override
  String get redesignBeta => 'Teste die Beta';

  @override
  String get playbackOrderShuffledTooltip => 'Mischen. Zum Umschalten tippen.';

  @override
  String get playbackOrderLinearTooltip =>
      'Abspielen in Reihenfolge. Zum umschalten tippen.';

  @override
  String get loopModeAllTooltip => 'Wiederhole alle. Zum umschalten tippen.';

  @override
  String get loopModeOneTooltip => 'Wiederhole einen. Zum umschalten tippen.';

  @override
  String get loopModeNoneTooltip => 'Wiederholt nicht. Zum umschalten tippen.';

  @override
  String get skipToPrevious => 'Springe zum vorherigen Lied';

  @override
  String get skipToNext => 'Springe zum nächsten Lied';

  @override
  String get togglePlayback => 'Wiedergabe umschalten';

  @override
  String playArtist(String artist) {
    return 'Spiele alle Alben von $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Spiele alle Alben von $artist in zufälliger Reihenfolge';
  }

  @override
  String downloadArtist(String artist) {
    return 'Lade alle Alben von $artist herunter';
  }

  @override
  String get deleteFromDevice => 'Vom Gerät Löschen';

  @override
  String get download => 'Herunterladen';

  @override
  String get sync => 'Mit Server synchronisieren';

  @override
  String get about => 'Über Finamp';
}
