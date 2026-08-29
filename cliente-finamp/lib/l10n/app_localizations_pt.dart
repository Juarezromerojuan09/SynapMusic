// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String startupError(String error) {
    return 'Ocorreu um erro durante o arranque da aplicação. O erro foi:$error\n\nPor favor, abra um \"Issue\" em github.com/UnicornsOnLSD/finamp que contenha uma captura deste ecrã. Caso o problema persista, tente limpar os dados da aplicação para a repor para o estado original.';
  }

  @override
  String get serverUrl => 'URL do servidor';

  @override
  String get internalExternalIpExplanation =>
      'Se pretende aceder ao seu servidor Jellyfin remotamente, será necessário utilizar o seu IP público.\n\nNo caso do seu servidor utilizar uma das portas padrão do HTTP (80/443), não vai precisar de indicar uma porta. Este será o caso mais provável caso utilize um proxy inverso.';

  @override
  String get emptyServerUrl => 'O URL do servidor não pode estar em branco';

  @override
  String get urlStartWithHttps =>
      'O URL deverá começar com http:// ou https://';

  @override
  String get urlTrailingSlash => 'O URL não pode ter uma barra no fim';

  @override
  String get username => 'Utilizador';

  @override
  String get password => 'Palavra-passe';

  @override
  String get logs => 'Registos';

  @override
  String get next => 'Próximo';

  @override
  String get selectMusicLibraries => 'Seleccione as suas bibliotecas de música';

  @override
  String get couldNotFindLibraries =>
      'Não foi possível encontrar nenhuma biblioteca.';

  @override
  String get unknownName => 'Nome desconhecido';

  @override
  String get songs => 'Músicas';

  @override
  String get albums => 'Álbuns';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Géneros';

  @override
  String get playlists => 'Listas de Reprodução';

  @override
  String get startMix => 'Iniciar Mistura';

  @override
  String get startMixNoSongsArtist =>
      'Antes de iniciar uma mistura, faça um toque longo num artista para adicionar ou remover o mesmo do editor de misturas';

  @override
  String get startMixNoSongsAlbum =>
      'Antes de iniciar uma mistura, faça um toque longo num álbum para adicioná-lo ao editor de misturas';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Misturar todas';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Transferências';

  @override
  String get settings => 'Definições';

  @override
  String get offlineMode => 'Modo Offline';

  @override
  String get sortOrder => 'Ordenação';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista do Álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Orçamento';

  @override
  String get communityRating => 'Avaliação da Comunidade';

  @override
  String get criticRating => 'Avaliação dos Críticos';

  @override
  String get dateAdded => 'Adicionado em';

  @override
  String get datePlayed => 'Reproduzido em';

  @override
  String get playCount => 'Contagem de reproduções';

  @override
  String get premiereDate => 'Data de Lançamento';

  @override
  String get productionYear => 'Ano de Produção';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Aleatório';

  @override
  String get revenue => 'Receita';

  @override
  String get runtime => 'Duração';

  @override
  String get syncDownloadedPlaylists =>
      'Sincronizar listas de reprodução descarregadas';

  @override
  String get downloadMissingImages => 'Transferir imagens inexistentes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens em falta descarregadas',
      one: '$count imagem em falta transferida',
      zero: 'Não foram encontradas imagens em falta',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Erros de transferência';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descarregados',
      one: '$count descarregado',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens',
      one: '$count imagem',
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
    return '$count concluídas';
  }

  @override
  String dlFailed(int count) {
    return '$count falharam';
  }

  @override
  String dlEnqueued(int count) {
    return '$count em espera';
  }

  @override
  String dlRunning(int count) {
    return '$count em execução';
  }

  @override
  String get downloadErrorsTitle => 'Erros de Transferência';

  @override
  String get noErrors => 'Sem erros!';

  @override
  String get errorScreenError =>
      'Ocorreu um erro ao aceder à lista de erros! Neste caso, recomendados que abra um issue no nosso GitHub e que limpe os dados da aplicação';

  @override
  String get failedToGetSongFromDownloadId =>
      'Falha ao adquirir música do ID da descarga';

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
  String get deleteDownloadsConfirmButtonText => 'Apagar';

  @override
  String get deleteDownloadsAbortButtonText => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'REPRODUZIR';

  @override
  String get shuffleButtonLabel => 'MISTURAR';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Músicas',
      one: '$count Música',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar nome da lista de reprodução';

  @override
  String get editPlaylistNameTitle => 'Editar Nome da Lista de Reprodução';

  @override
  String get required => 'Obrigatório';

  @override
  String get updateButtonLabel => 'ACTUALIZAR';

  @override
  String get playlistNameUpdated => 'Nome da lista de reprodução atualizado.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Descargas apagadas.';

  @override
  String get addDownloads => 'Adicionar Descargas';

  @override
  String get location => 'Localização';

  @override
  String get downloadsAdded => 'Descargas adicionadas.';

  @override
  String get addButtonLabel => 'ADICIONAR';

  @override
  String get shareLogs => 'Compartilhar relatórios';

  @override
  String get logsCopied => 'Relatórios copiados.';

  @override
  String get message => 'Mensagem';

  @override
  String get stackTrace => 'Traçado da Pilha';

  @override
  String get applicationLegalese =>
      'Licenciado com a Licença Pública Mozilla 2.0. Código-fonte disponível em:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcodificando';

  @override
  String get downloadLocations => 'Locais de Descargas';

  @override
  String get audioService => 'Serviço de Áudio';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Composição & Tema';

  @override
  String get notAvailableInOfflineMode => 'Não disponível no modo desconectado';

  @override
  String get logOut => 'Sair';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Músicas descarregadas não serão apagadas';

  @override
  String get areYouSure => 'Tem certeza?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin usa AAC para transcodificação';

  @override
  String get enableTranscoding => 'Ativar Transcodificação';

  @override
  String get enableTranscodingSubtitle =>
      'Transcodifica fluxos de música no lado do servidor.';

  @override
  String get bitrate => 'Taxa de bits';

  @override
  String get bitrateSubtitle =>
      'Uma taxa de bits mais alta resulta em áudio de maior qualidade, ao custo de maior largura de banda.';

  @override
  String get customLocation => 'Localização Customizada';

  @override
  String get appDirectory => 'Diretório de apps';

  @override
  String get addDownloadLocation => 'Adicionar Localização de Descargas';

  @override
  String get selectDirectory => 'Selecione Diretório';

  @override
  String get unknownError => 'Erro Desconhecido';

  @override
  String get pathReturnSlashErrorMessage =>
      'Caminhos que retornam \"/\" não podem ser usados';

  @override
  String get directoryMustBeEmpty => 'Diretório deve estar vazio';

  @override
  String get customLocationsBuggy =>
      'Localizações customizadas são extremamente defeituosas devidas à problems com permissões. Estou pensando em maneiras de consertar isso, mas por enquanto não recomendaria usá-las.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Entrar Estado de Baixa-Prioridade durante Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permite que a notificação seja apagada quando pausada. Também permite que o Android elimine o serviço quando pausado.';

  @override
  String get shuffleAllSongCount => 'Contagem de Misturar Todas as Músicas';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Quantidade de músicas para carregar quando usando o botão misturar todas as músicas.';

  @override
  String get viewType => 'Tipo de Visualização';

  @override
  String get viewTypeSubtitle => 'Tipo de visualização para o ecrã de músicas';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Grade';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisagem';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Contagem Eixo Cruzado da Grade';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Quantidade de ícones da grade para usar em cada fila quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto na visualização em grade';

  @override
  String get showTextOnGridViewSubtitle =>
      'Mostrar ou não o texto (título, artista, etc) no ecrã de música grade.';

  @override
  String get showCoverAsPlayerBackground =>
      'Mostrar capa desfocada como plano de fundo do player';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Usar ou não usar arte de capas desfocadas como fundo do ecrã to reprodutor.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Ocultar artistas da música se forem iguais aos artistas do álbum';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Se deve mostrar os artistas das músicas na tela do álbum, se não for diferente dos artistas do álbum.';

  @override
  String get disableGesture => 'Desativar gestos';

  @override
  String get disableGestureSubtitle => 'Se deseja desativar gestos.';

  @override
  String get showFastScroller => 'Mostrar rolagem rápida';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get tabs => 'Abas';

  @override
  String get cancelSleepTimer => 'Cancelar o Cronômetro de Sono?';

  @override
  String get yesButtonLabel => 'SIM';

  @override
  String get noButtonLabel => 'NÃO';

  @override
  String get setSleepTimer => 'Configurar o Cronômetro de Sono';

  @override
  String get minutes => 'Minutos';

  @override
  String get invalidNumber => 'Número Inválido';

  @override
  String get sleepTimerTooltip => 'Cronômetro de Sono';

  @override
  String get addToPlaylistTooltip => 'Adicionar à lista de reprodução';

  @override
  String get addToPlaylistTitle => 'Adicionar à Lista de Reprodução';

  @override
  String get removeFromPlaylistTooltip => 'Remover da lista de reprodução';

  @override
  String get removeFromPlaylistTitle => 'Remover da Lista de Reprodução';

  @override
  String get newPlaylist => 'Nova Lista de Reprodução';

  @override
  String get createButtonLabel => 'CRIAR';

  @override
  String get playlistCreated => 'Lista de reprodução criada.';

  @override
  String get noAlbum => 'Nenhum Álbum';

  @override
  String get noItem => 'Nenhum Ítem';

  @override
  String get noArtist => 'Nenhum Artista';

  @override
  String get unknownArtist => 'Artista Desconhecido';

  @override
  String get streaming => 'TRANSMITINDO';

  @override
  String get downloaded => 'DESCARREGADO';

  @override
  String get transcode => 'TRANSCODIFICAR';

  @override
  String get direct => 'DIRETO';

  @override
  String get statusError => 'ERRO DE CONDIÇÃO';

  @override
  String get queue => 'Fila';

  @override
  String get addToQueue => 'Adicionar à Fila';

  @override
  String get playNext => 'Jogue a seguir';

  @override
  String get replaceQueue => 'Trocar a Fila';

  @override
  String get instantMix => 'Mistura Instantânea';

  @override
  String get goToAlbum => 'Ir para Álbum';

  @override
  String get removeFavourite => 'Remover Favorito';

  @override
  String get addFavourite => 'Adicionar Favorito';

  @override
  String get addedToQueue => 'Adicionado à fila.';

  @override
  String get insertedIntoQueue => 'Inserido na fila.';

  @override
  String get queueReplaced => 'Fila trocada.';

  @override
  String get removedFromPlaylist => 'Removido da lista de reprodução.';

  @override
  String get startingInstantMix => 'Iniciando mistura instantânea.';

  @override
  String get anErrorHasOccured => 'Ocorreu um erro.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de condição $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de condição $statusCode. Isto provavelmente significa que usou um nome de utilizador/palavra-passe errados, ou o seu cliente não está mais autenticado.';
  }

  @override
  String get removeFromMix => 'Remover da Mistura';

  @override
  String get addToMix => 'Adicionar à Mistura';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens baixados novamente',
      one: '$count item baixado novamente',
      zero: 'Não são necessários novos downloads.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duração do buffer';

  @override
  String get bufferDurationSubtitle =>
      'Quanto o player deve armazenar em buffer, em segundos. Requer uma reinicialização.';

  @override
  String get language => 'Linguagem';

  @override
  String get confirm => 'Confirme';

  @override
  String get showUncensoredLogMessage =>
      'Este log contém suas informações de login. Mostrar?';

  @override
  String get resetTabs => 'Redefinir guias';

  @override
  String get noMusicLibrariesTitle => 'Sem bibliotecas de música';

  @override
  String get noMusicLibrariesBody =>
      'A Finamp não encontrou nenhuma biblioteca musical. Certifique-se de que seu servidor Jellyfin contenha pelo menos uma biblioteca com o tipo de conteúdo definido como “Música”.';

  @override
  String get refresh => 'ACTUALIZAR';

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

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String startupError(String error) {
    return 'Algo deu errado na inicialização. O erro foi: $error\n\nPor favor, crie um problema/issue em github.com/UnicornsOnLSD/finamp anexando uma captura de tela dessa página. Se esse erro persistir, limpe os dados para restaurar o aplicativo.';
  }

  @override
  String get serverUrl => 'URL do servidor';

  @override
  String get internalExternalIpExplanation =>
      'Se você quer acessar seu servidor Jellyfin remotamente, você precisa usar seu IP externo.\n\nSe seu servidor está em uma porta HTTP (80/443), você não precisa especificar a porta. Esse será o caso se o servidor estiver atrás de um proxy reverso.';

  @override
  String get emptyServerUrl => 'URL de servidor não pode ser vazia';

  @override
  String get urlStartWithHttps => 'URL deve começar com http:// ou https://';

  @override
  String get urlTrailingSlash => 'URL não pode incluir a barra final';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get logs => 'Registros';

  @override
  String get next => 'Próximo';

  @override
  String get selectMusicLibraries => 'Selecione a biblioteca de Músicas';

  @override
  String get couldNotFindLibraries =>
      'Não foi possível encontrar nenhuma biblioteca.';

  @override
  String get unknownName => 'Nome desconhecido';

  @override
  String get songs => 'Músicas';

  @override
  String get albums => 'Álbuns';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Gêneros';

  @override
  String get playlists => 'Listas de Reprodução';

  @override
  String get startMix => 'Começar Miscelânea';

  @override
  String get startMixNoSongsArtist =>
      'Aperte e segure num artista para adicionar ou remover da mistura antes de iniciá-la';

  @override
  String get startMixNoSongsAlbum =>
      'Aperte e segure num álbum para adicionar ou remover da mistura antes de iniciá-la';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Embaralhar todas';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Configurações';

  @override
  String get offlineMode => 'Modo Offline';

  @override
  String get sortOrder => 'Ordenação';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista do Álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Orçamento';

  @override
  String get communityRating => 'Avaliação da Comunidade';

  @override
  String get criticRating => 'Avaliação dos Críticos';

  @override
  String get dateAdded => 'Adicionado em';

  @override
  String get datePlayed => 'Reproduzido em';

  @override
  String get playCount => 'Contagem de reproduções';

  @override
  String get premiereDate => 'Data de Lançamento';

  @override
  String get productionYear => 'Ano de Produção';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Aleatório';

  @override
  String get revenue => 'Receita';

  @override
  String get runtime => 'Duração';

  @override
  String get syncDownloadedPlaylists =>
      'Sincronizar listas de reprodução baixadas';

  @override
  String get downloadMissingImages => 'Baixar imagens ausentes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baixadas$count imagens ausentes',
      one: 'Baixada $count imagem ausente',
      zero: 'Nenhuma imagem ausente baixada',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'Erros de transferência';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count baixadas',
      one: '$count baixada',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens',
      one: '$count imagem',
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
    return '$count concluídas';
  }

  @override
  String dlFailed(int count) {
    return '$count falharam';
  }

  @override
  String dlEnqueued(int count) {
    return '$count enfileiradas';
  }

  @override
  String dlRunning(int count) {
    return '$count em execução';
  }

  @override
  String get downloadErrorsTitle => 'Erros de Transferência';

  @override
  String get noErrors => 'Sem erros!';

  @override
  String get errorScreenError =>
      'Um erro ocorreu acessando a lista de erros! A este ponto, você provavelmente deve criar um defeito (issue) no GitHub e apagar os dados do aplicativo';

  @override
  String get failedToGetSongFromDownloadId =>
      'Falha em adquirir música do ID da transferência';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'o álbum',
        'playlist': 'a lista de reprodução',
        'artist': 'o artista',
        'genre': 'o gênero',
        'track': 'a música',
        'other': '',
      },
    );
    return 'Você tem certeza que quer deletar $_temp0 \'$itemName\' desse dispositivo?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Deletar';

  @override
  String get deleteDownloadsAbortButtonText => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'REPRODUZIR';

  @override
  String get shuffleButtonLabel => 'MISTURAR';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Músicas',
      one: '$count Música',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar nome da lista de reprodução';

  @override
  String get editPlaylistNameTitle => 'Editar Nome da Lista de Reprodução';

  @override
  String get required => 'Obrigatório';

  @override
  String get updateButtonLabel => 'ATUALIZAÇÃO';

  @override
  String get playlistNameUpdated => 'Nome da lista de reprodução atualizado.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Transferências apagadas.';

  @override
  String get addDownloads => 'Adicionar Transferências';

  @override
  String get location => 'Localização';

  @override
  String get downloadsAdded => 'Transferências adicionadas.';

  @override
  String get addButtonLabel => 'ADICIONAR';

  @override
  String get shareLogs => 'Compartilhar relatórios';

  @override
  String get logsCopied => 'Relatórios copiados.';

  @override
  String get message => 'Mensagem';

  @override
  String get stackTrace => 'Traçado da Pilha';

  @override
  String get applicationLegalese =>
      'Licenciado com a Licença Pública Mozilla 2.0. Código-fonte disponível em:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Transcodificando';

  @override
  String get downloadLocations => 'Locais de Transferências';

  @override
  String get audioService => 'Serviço de Áudio';

  @override
  String get interactions => 'Interações';

  @override
  String get layoutAndTheme => 'Composição & Tema';

  @override
  String get notAvailableInOfflineMode => 'Não disponível no modo desconectado';

  @override
  String get logOut => 'Sair';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'Músicas transferidas não serão apagadas';

  @override
  String get areYouSure => 'Tem certeza?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin usa AAC para transcodificação';

  @override
  String get enableTranscoding => 'Ativar Transcodificação';

  @override
  String get enableTranscodingSubtitle =>
      'A transmissão de músicas será transcodificada pelo servidor.';

  @override
  String get bitrate => 'Taxa de bits';

  @override
  String get bitrateSubtitle =>
      'Uma taxa de bits mais alta resulta em áudio de maior qualidade, ao custo de maior largura de banda.';

  @override
  String get customLocation => 'Localização Customizada';

  @override
  String get appDirectory => 'Diretório de Aplicativos';

  @override
  String get addDownloadLocation => 'Adicionar Localização de Transferências';

  @override
  String get selectDirectory => 'Selecione Diretório';

  @override
  String get unknownError => 'Erro Desconhecido';

  @override
  String get pathReturnSlashErrorMessage =>
      'Caminhos que retornam \"/\" não podem ser usados';

  @override
  String get directoryMustBeEmpty => 'Diretório deve estar vazio';

  @override
  String get customLocationsBuggy =>
      'Localizações customizadas são extremamente defeituosas devidas à problems com permissões. Estou pensando em maneiras de consertar isso, mas por enquanto não recomendaria usá-las.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Entrar Estado de Baixa-Prioridade durante Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permite que a notificação seja dispensada quando pausado. Também permite ao Android terminar o serviço quando pausado.';

  @override
  String get shuffleAllSongCount => 'Contagem de Misturar Todas as Músicas';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Quantidade de músicas para carregar quando usando o botão misturar todas as músicas.';

  @override
  String get viewType => 'Tipo de Visualização';

  @override
  String get viewTypeSubtitle => 'Tipo de visualização para a tela de músicas';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Grade';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisagem';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Contagem Eixo Cruzado da Grade';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Quantidade de ícones da grade para usar em cada fila quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto na visualização de grade';

  @override
  String get showTextOnGridViewSubtitle =>
      'Mostrar ou não o texto (título, artista, etc) na tela de música grade.';

  @override
  String get showCoverAsPlayerBackground =>
      'Mostrar capas desfocadas como fundo do tocador';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Usar ou não usar arte de capas desfocadas como fundo da tela to tocador.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Esconder o nome dos artistas da música se for o mesmo que os artistas do álbum';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Indica se deve mostrar os artistas da música na tela do álbum se eles não forem diferentes dos artistas do álbum.';

  @override
  String get disableGesture => 'Desativar gestos';

  @override
  String get disableGestureSubtitle => 'Indica se deve desativar gestos.';

  @override
  String get showFastScroller => 'Mostrar rolagem rápida';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get tabs => 'Abas';

  @override
  String get cancelSleepTimer => 'Cancelar o Cronômetro de Sono?';

  @override
  String get yesButtonLabel => 'SIM';

  @override
  String get noButtonLabel => 'NÃO';

  @override
  String get setSleepTimer => 'Configurar o Cronômetro de Sono';

  @override
  String get minutes => 'Minutos';

  @override
  String get invalidNumber => 'Número Inválido';

  @override
  String get sleepTimerTooltip => 'Cronômetro de Sono';

  @override
  String get addToPlaylistTooltip => 'Adicionar à lista de reprodução';

  @override
  String get addToPlaylistTitle => 'Adicionar à Lista de Reprodução';

  @override
  String get removeFromPlaylistTooltip => 'Remover da playlist';

  @override
  String get removeFromPlaylistTitle => 'Remover da Playlist';

  @override
  String get newPlaylist => 'Nova Lista de Reprodução';

  @override
  String get createButtonLabel => 'CRIAR';

  @override
  String get playlistCreated => 'Lista de reprodução criada.';

  @override
  String get noAlbum => 'Nenhum Álbum';

  @override
  String get noItem => 'Nenhum Ítem';

  @override
  String get noArtist => 'Nenhum Artista';

  @override
  String get unknownArtist => 'Artista Desconhecido';

  @override
  String get streaming => 'TRANSMITINDO';

  @override
  String get downloaded => 'TRANSFERIDO';

  @override
  String get transcode => 'TRANSCODIFICAR';

  @override
  String get direct => 'DIRETO';

  @override
  String get statusError => 'ERRO DE CONDIÇÃO';

  @override
  String get queue => 'Fila';

  @override
  String get addToQueue => 'Adicionar à Fila';

  @override
  String get playNext => 'Tocar Próximo';

  @override
  String get replaceQueue => 'Trocar a Fila';

  @override
  String get instantMix => 'Mistura Instantânea';

  @override
  String get goToAlbum => 'Ir para Álbum';

  @override
  String get removeFavourite => 'Remover Favorito';

  @override
  String get addFavourite => 'Adicionar Favorito';

  @override
  String get addedToQueue => 'Adicionado à fila.';

  @override
  String get insertedIntoQueue => 'Inserido na fila.';

  @override
  String get queueReplaced => 'Fila trocada.';

  @override
  String get removedFromPlaylist => 'Removido da playlist.';

  @override
  String get startingInstantMix => 'Iniciando mistura instantânea.';

  @override
  String get anErrorHasOccured => 'Ocorreu um erro.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de condição $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de condição $statusCode. Isto provavelmente significa que você usou um nome de usuário/senha errados, ou seu cliente não está mais autenticado.';
  }

  @override
  String get removeFromMix => 'Remover da Mistura';

  @override
  String get addToMix => 'Adicionar à Mistura';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens foram baixados novamente',
      one: '$count item foi baixado novamente',
      zero: 'Sem necessidade de baixar novamente.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duração do buffer';

  @override
  String get bufferDurationSubtitle =>
      'Quanto o reprodutor deve armazenar de buffer, em segundos. Requer uma reinicialização.';

  @override
  String get language => 'Idioma';

  @override
  String get confirm => 'Confirmar';

  @override
  String get showUncensoredLogMessage =>
      'Este registro contém suas credenciais de acesso. Revelar?';

  @override
  String get resetTabs => 'Redefinir abas';

  @override
  String get noMusicLibrariesTitle => 'Sem Bibliotecas de Música';

  @override
  String get noMusicLibrariesBody =>
      'O Finamp não conseguiu encontrar nenhuma biblioteca de música. Certifique-se de que o seu servidor Jellyfin tenha pelo menos uma biblioteca com o tipo de conteúdo definido como \"Música\".';

  @override
  String get refresh => 'ATUALIZAR';

  @override
  String get swipeInsertQueueNext => 'Tocar Música Deslizada em Seguida';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Adicionar uma música como próximo item na lista quando for deslizada, ao invés de adicionar no final.';

  @override
  String get redesignBeta => 'Teste o beta';

  @override
  String get playbackOrderShuffledTooltip =>
      'Embaralhando. Aperte para ativar.';

  @override
  String get playbackOrderLinearTooltip =>
      'Tocando em ordem. Aperte para ativar.';

  @override
  String get loopModeAllTooltip => 'Repetir tudo. Aperte para ativar.';

  @override
  String get loopModeOneTooltip => 'Repetir uma. Aperte para ativar.';

  @override
  String get loopModeNoneTooltip => 'Sem repetição. Aperte para ativar.';

  @override
  String get skipToPrevious => 'Pular para música anterior';

  @override
  String get skipToNext => 'Pular para próxima música';

  @override
  String get togglePlayback => 'Ativar reprodução';

  @override
  String playArtist(String artist) {
    return 'Tocar todos os álbuns de $artist';
  }

  @override
  String shuffleArtist(String artist) {
    return 'Tocar todos os álbuns de $artist em modo aleatório';
  }

  @override
  String downloadArtist(String artist) {
    return 'Baixar todos os álbuns de $artist';
  }

  @override
  String get deleteFromDevice => 'Remover do dispositivo';

  @override
  String get download => 'Baixar';

  @override
  String get sync => 'Sincronizar com servidor';

  @override
  String get about => 'Sobre Finamp';
}
