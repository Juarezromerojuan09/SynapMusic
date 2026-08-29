// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String startupError(String error) {
    return 'Qualcosa è andato storto durante l\'avvio dell\'app. L\'errore è stato: $error\n\nPerfavore apri una segnalazione su github.com/UnicornsOnLSD/finamp con uno screenshot di questa pagina. Se il problema persiste puoi cancellare i dati dell\'app per riportarla alle impostazioni iniziali.';
  }

  @override
  String get serverUrl => 'URL del Server';

  @override
  String get internalExternalIpExplanation =>
      'Se vuoi accedere al tuo server di Jellyfin da remoto devi usare il tuo IP pubblico.\n\nSe il tuo server usa una porta HTTP (80/443) non è necessario specificare la porta. Può verificarsi se il tuo server ad esempio si trova dietro un reverse proxy.';

  @override
  String get emptyServerUrl => 'l\'URL del Server non può essere vuoto';

  @override
  String get urlStartWithHttps => 'l\'URL deve iniziare con http:// o https://';

  @override
  String get urlTrailingSlash =>
      'l\'URL non deve contenere il carattere (/) alla fine';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get logs => 'Log';

  @override
  String get next => 'Avanti';

  @override
  String get selectMusicLibraries => 'Seleziona le Librerie Musicali';

  @override
  String get couldNotFindLibraries =>
      'Non è possibile trovare alcuna libreria.';

  @override
  String get unknownName => 'Nome Sconosciuto';

  @override
  String get songs => 'Brani';

  @override
  String get albums => 'Album';

  @override
  String get artists => 'Artisti';

  @override
  String get genres => 'Generi';

  @override
  String get playlists => 'Playlist';

  @override
  String get startMix => 'Riproduco Mix';

  @override
  String get startMixNoSongsArtist =>
      'Effettua una pressione prolungata su un artista per aggiungerlo o rimuoverlo dal mix builder prima di far partire un mix';

  @override
  String get startMixNoSongsAlbum =>
      'Effettua una pressione prolungata su un album per aggiungerlo o rimuoverlo dal mix builder prima di far partire un mix';

  @override
  String get music => 'Musica';

  @override
  String get clear => 'Cancella';

  @override
  String get favourites => 'Preferiti';

  @override
  String get shuffleAll => 'Riproduci casualmente tutti';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Download';

  @override
  String get settings => 'Impostazioni';

  @override
  String get offlineMode => 'Modailtà Offline';

  @override
  String get sortOrder => 'Ordinamento';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artista dell\'Album';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Valutazione della comunità';

  @override
  String get criticRating => 'Punteggio della critica';

  @override
  String get dateAdded => 'Data di Aggiunta';

  @override
  String get datePlayed => 'Data di Riproduzione';

  @override
  String get playCount => 'Conteggio Riproduzioni';

  @override
  String get premiereDate => 'Data di Rilascio';

  @override
  String get productionYear => 'Anno di Produzione';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Casuale';

  @override
  String get revenue => 'Incassi';

  @override
  String get runtime => 'Tempo di esecuzione';

  @override
  String get syncDownloadedPlaylists => 'Sincronizza playlists scaricate';

  @override
  String get downloadMissingImages => 'Scarica immagini mancanti';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scaricate $count immagini mancanti',
      one: 'Scaricata $count immagine mancante',
      zero: 'Non ho trovato alcuna immagine mancante',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Errori durante il download';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count download',
      one: '$count download',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oggetti',
      one: '$count oggetto',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count immagini',
      one: '$count immagine',
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
    return '$count finito';
  }

  @override
  String dlFailed(int count) {
    return '$count falliti';
  }

  @override
  String dlEnqueued(int count) {
    return '$count in coda';
  }

  @override
  String dlRunning(int count) {
    return '$count in riproduzione';
  }

  @override
  String get downloadErrorsTitle => 'Errori durante il Download';

  @override
  String get noErrors => 'Nessun errore!';

  @override
  String get errorScreenError =>
      'Si è verificato un errore mentre tentavo di ottenere la lista degli errori! A questo punto probabilmente dovresti aprire una issue su GitHub e cancellare i dati dell\'app';

  @override
  String get failedToGetSongFromDownloadId =>
      'Impossibile ottenere il brano dall\'ID di download';

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
  String get deleteDownloadsConfirmButtonText => 'Elimina';

  @override
  String get deleteDownloadsAbortButtonText => 'Annulla';

  @override
  String get error => 'Errore';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'RIPRODUCI';

  @override
  String get shuffleButtonLabel => 'RIPRODUCI CASUALMENTE';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Brani',
      one: '$count Brano',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Modifica il nome della playlist';

  @override
  String get editPlaylistNameTitle => 'Modifica il Nome della Playlist';

  @override
  String get required => 'Richiesto';

  @override
  String get updateButtonLabel => 'AGGIORNAMENTO';

  @override
  String get playlistNameUpdated => 'Playlist nome aggiornato.';

  @override
  String get favourite => 'Preferiti';

  @override
  String get downloadsDeleted => 'Download cancellati.';

  @override
  String get addDownloads => 'Aggiungi Download';

  @override
  String get location => 'Posizione';

  @override
  String get downloadsAdded => 'Download aggiunti.';

  @override
  String get addButtonLabel => 'AGGIUNGI';

  @override
  String get shareLogs => 'Condividi i log';

  @override
  String get logsCopied => 'Log copiati.';

  @override
  String get message => 'Messaggio';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String get applicationLegalese =>
      'Concesso in licenza con \"Mozilla Public License 2.0\". Codice Sorgente disponibile su:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcodifica';

  @override
  String get downloadLocations => 'Cartella di Download';

  @override
  String get audioService => 'Servizio Audio';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Aspetto & Temi';

  @override
  String get notAvailableInOfflineMode => 'Non disponibile in modalità offline';

  @override
  String get logOut => 'Disconnetti';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'I brani scaricati non saranno cancellati';

  @override
  String get areYouSure => 'Sei sicuro?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin usa AAC per la transcodifica';

  @override
  String get enableTranscoding => 'Attiva Transcodifica';

  @override
  String get enableTranscodingSubtitle =>
      'Transcodifica I flussi di musica dal lato server.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Un bitrate più alto permette di avere una qualità audio più alta al costo di un più alto consumo della connessione dati.';

  @override
  String get customLocation => 'Posizione Personalizzata';

  @override
  String get appDirectory => 'Cartella dell\'App';

  @override
  String get addDownloadLocation => 'Aggiungi la posizione per i Download';

  @override
  String get selectDirectory => 'Seleziona Cartella';

  @override
  String get unknownError => 'Errore Sconosciuto';

  @override
  String get pathReturnSlashErrorMessage =>
      'Non possono essere usati percorsi che terminano con \"/\"';

  @override
  String get directoryMustBeEmpty => 'La cartella deve essere vuota';

  @override
  String get customLocationsBuggy =>
      'Le posizioni personalizzate sono estremamente instabili a causa di problemi con i permessi. Sto pensando a un modo di aggiustarle, ma per adesso non ne consiglio l\'utilizzo.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Entra nello Stato a Bassa-Priorità quando in Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permette di scartare una notifica quando la riproduzione è in pausa. Inoltre consente ad Android di terminare il servizio quando la riproduzione è in pausa.';

  @override
  String get shuffleAllSongCount =>
      'Riproduci Casualmente Tutte Le Canzoni Conteggiate';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Numero di brani da caricare quando si usa il tasto per la riproduzione casuale di tutti i brani.';

  @override
  String get viewType => 'Modalità di Visualizzazione';

  @override
  String get viewTypeSubtitle =>
      'Modalità di visualizzazione per la schermata musica';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Griglia';

  @override
  String get portrait => 'Visualizzazione verticale';

  @override
  String get landscape => 'Visualizzazione orizzontale';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Numero di Colonne nella Vista a griglia';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Numero di colonne da usare per ciascuna riga quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostra testo nella vista a griglia';

  @override
  String get showTextOnGridViewSubtitle =>
      'Mostrare il testo (titolo, artista, etc.) nella Vista a griglia della schermata della musica.';

  @override
  String get showCoverAsPlayerBackground =>
      'Mostra le copertine sfocate quando il player è in background';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Usare o meno cover sfocate come sfondo nella schermata di riproduzione.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Nascondi l\'artista del brano se uguale all\'artista dell\'album';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Se mostrare gli artisti del brano nella visualizzazione album nel caso coincidano con gli artisti dell\'album.';

  @override
  String get disableGesture => 'Disabilita gesti';

  @override
  String get disableGestureSubtitle => 'Se vuoi disabilitare i gesti.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get tabs => 'Schede';

  @override
  String get cancelSleepTimer => 'Cancellare il Timer di spegnimento?';

  @override
  String get yesButtonLabel => 'SI';

  @override
  String get noButtonLabel => 'NO';

  @override
  String get setSleepTimer => 'Imposta Timer di Spegnimento';

  @override
  String get minutes => 'Minuti';

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get sleepTimerTooltip => 'Timer di spegnimento';

  @override
  String get addToPlaylistTooltip => 'Aggiungi alla playlist';

  @override
  String get addToPlaylistTitle => 'Aggiungi alla Playlist';

  @override
  String get removeFromPlaylistTooltip => 'Rimuovi dalla playlist';

  @override
  String get removeFromPlaylistTitle => 'Rimuovi dalla playlist';

  @override
  String get newPlaylist => 'Nuova Playlist';

  @override
  String get createButtonLabel => 'CREA';

  @override
  String get playlistCreated => 'Playlist creata.';

  @override
  String get noAlbum => 'Nessun Album';

  @override
  String get noItem => 'Nessun Oggetto';

  @override
  String get noArtist => 'Nessun Artista';

  @override
  String get unknownArtist => 'Artista Sconosciuto';

  @override
  String get streaming => 'STREAMING';

  @override
  String get downloaded => 'Scaricato';

  @override
  String get transcode => 'TRANSCODIFICA';

  @override
  String get direct => 'DIRETTO';

  @override
  String get statusError => 'ERRORE DI STATO';

  @override
  String get queue => 'Coda';

  @override
  String get addToQueue => 'Aggiungi alla Coda';

  @override
  String get playNext => 'Suona il prossimo';

  @override
  String get replaceQueue => 'Sostituisci Coda';

  @override
  String get instantMix => 'Mix Istantaneo';

  @override
  String get goToAlbum => 'Vai all\'Album';

  @override
  String get removeFavourite => 'Rimuovi Preferito';

  @override
  String get addFavourite => 'Aggiungi Favorito';

  @override
  String get addedToQueue => 'Aggiunto alla coda.';

  @override
  String get insertedIntoQueue => 'Inserito nella coda.';

  @override
  String get queueReplaced => 'Coda sostituita.';

  @override
  String get removedFromPlaylist => 'Rimosso dalla playlist.';

  @override
  String get startingInstantMix => 'Riproduco un mix istantaneo.';

  @override
  String get anErrorHasOccured => 'Si è verificato un errore.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Codice errore $statusCode. Questo probabilmente significa che hai usato username/password errati, o il tuo client non è più autenticato.';
  }

  @override
  String get removeFromMix => 'Rimuovi dal Mix';

  @override
  String get addToMix => 'Aggiungi al Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Riscaricati $count oggetti',
      one: 'Riscaricato $count oggetto',
      zero: 'Non è necessario riscaricare nulla.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Durata Buffer';

  @override
  String get bufferDurationSubtitle =>
      'Quanto buffer, in secondi, deve avere il player. Richiede riavvio.';

  @override
  String get language => 'Lingua';

  @override
  String get confirm => 'Conferma';

  @override
  String get showUncensoredLogMessage =>
      'Questo log contiene le tue credenziali di accesso. Vuoi vederlo?';

  @override
  String get resetTabs => 'Resettare le schede';

  @override
  String get noMusicLibrariesTitle => 'Nessuna raccolta musicale';

  @override
  String get noMusicLibrariesBody =>
      'Finamp non è riuscito a trovare nessuna raccolta musicale. Sei pregato di controllare che il tuo server Jellyfin contenga almeno una raccolta con il genere configurato come \"Musica\".';

  @override
  String get refresh => 'AGGIORNA';

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
