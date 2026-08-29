// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String startupError(String error) {
    return 'Uygulama başlarken bir hata meydana geldi. Hata: $error\n\nLütfen bu sayfanın ekran görüntüsüyle github.com/UnicornsOnLSD/finamp adresinde bir issue oluşturun. Eğer bu sorun devam ederse uygulamayı sıfırlamak için uygulama verisini sıfırlayabilirsiniz.';
  }

  @override
  String get serverUrl => 'Sunucunun URL\'i';

  @override
  String get internalExternalIpExplanation =>
      'Jellyfin sunucunuza uzaktan erişmek istiyorsanız dış IP adresinizi kullanmalısınız.\n\nEğer sunucunuz HTTP portlarından (80/443) birindeyse port belirtmenize gerek yok. Sunucunuz bir reverse proxy\'nin arkasındaysa muhtemelen bu durum geçerlidir.';

  @override
  String get emptyServerUrl => 'Sunucu URL\'i boş bırakılamaz';

  @override
  String get urlStartWithHttps => 'URL http:// veya https:// ile başlamalı';

  @override
  String get urlTrailingSlash => 'URL\'in sonunda eğik çizgi olmamalı';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get password => 'Parola';

  @override
  String get logs => 'Uygulama dökümleri';

  @override
  String get next => 'Sıradaki';

  @override
  String get selectMusicLibraries => 'Müzik Kütüphanelerini Seç';

  @override
  String get couldNotFindLibraries => 'Hiçbir kütüphane bulunamadı.';

  @override
  String get unknownName => 'Bilinmeyen İsim';

  @override
  String get songs => 'Şarkılar';

  @override
  String get albums => 'Albümler';

  @override
  String get artists => 'Sanatçılar';

  @override
  String get genres => 'Tarzlar';

  @override
  String get playlists => 'Çalma listeleri';

  @override
  String get startMix => 'Mix\'i başlat';

  @override
  String get startMixNoSongsArtist =>
      'Mix\'i başlatmadan önce bir sanatçıya uzun basarak mix\'e ekleyip çıkar';

  @override
  String get startMixNoSongsAlbum =>
      'Mix\'i başlatmadan önce bir albüme uzun basarak mix\'e ekleyip çıkar';

  @override
  String get music => 'Müzik';

  @override
  String get clear => 'Temizle';

  @override
  String get favourites => 'Favoriler';

  @override
  String get shuffleAll => 'Tümünü karıştır';

  @override
  String get finamp => 'Finamp';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get offlineMode => 'Çevrim dışı Mod';

  @override
  String get sortOrder => 'Sıralama düzeni';

  @override
  String get sortBy => 'Sıralama ölçütü';

  @override
  String get album => 'Albüm';

  @override
  String get albumArtist => 'Albüm Sanatçısı';

  @override
  String get artist => 'Sanatçı';

  @override
  String get budget => 'Bütçe';

  @override
  String get communityRating => 'Topluluk Puanı';

  @override
  String get criticRating => 'Eleştirmen Puanı';

  @override
  String get dateAdded => 'Eklenme Tarihi';

  @override
  String get datePlayed => 'Oynatma Tarihi';

  @override
  String get playCount => 'Oynatma Sayısı';

  @override
  String get premiereDate => 'Gösterim Tarihi';

  @override
  String get productionYear => 'Prodüksiyon Yılı';

  @override
  String get name => 'İsim';

  @override
  String get random => 'Rastgele';

  @override
  String get revenue => 'Gelir';

  @override
  String get runtime => 'Çalma süresi';

  @override
  String get syncDownloadedPlaylists => 'İndirilen çalma listelerini eşzamanla';

  @override
  String get downloadMissingImages => 'Eksik görselleri indir';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane eksik görsel indirildi',
      one: '$count tane eksik görsel indirildi',
      zero: 'Eksik görsel yok',
    );
    return '$_temp0';
  }

  @override
  String get downloadErrors => 'İndirme hataları';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane indirme$count',
      one: '$count tane indirme',
    );
    return '$_temp0';
  }

  @override
  String downloadedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya',
      one: '$count dosya',
    );
    return '$_temp0';
  }

  @override
  String downloadedImagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane görsel',
      one: '$count tane görsel',
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
    return '$count tane tamamlandı';
  }

  @override
  String dlFailed(int count) {
    return '$count tane başarısız';
  }

  @override
  String dlEnqueued(int count) {
    return '$count tane kuyruğa alındı';
  }

  @override
  String dlRunning(int count) {
    return '$count tane devam ediyor';
  }

  @override
  String get downloadErrorsTitle => 'İndirme Hataları';

  @override
  String get noErrors => 'Hata yok!';

  @override
  String get errorScreenError =>
      'Hata listesi oluşturulurken hata meydana geldi. Bu noktada, GitHub\'da bir sorun oluşturmalı ve uygulama verilerini silmelisiniz';

  @override
  String get failedToGetSongFromDownloadId =>
      'İndirme ID\'sinden şarkıya ulaşılamadı';

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
    return 'Bu aygıttan $_temp0 \'$itemName\' silmek istediğinizden emin misiniz?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Sil';

  @override
  String get deleteDownloadsAbortButtonText => 'İptal';

  @override
  String get error => 'Hata';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'OYNAT';

  @override
  String get shuffleButtonLabel => 'KARIŞTIR';

  @override
  String songCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Şarkı',
      one: '$count Şarkı',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Çalma listesinin adını düzenle';

  @override
  String get editPlaylistNameTitle => 'Çalma Listesinin Adını Düzenle';

  @override
  String get required => 'Gerekli';

  @override
  String get updateButtonLabel => 'GÜNCELLE';

  @override
  String get playlistNameUpdated => 'Çalma listesinin adı güncellendi.';

  @override
  String get favourite => 'Favori';

  @override
  String get downloadsDeleted => 'İndirmeler silindi.';

  @override
  String get addDownloads => 'İndirme Ekle';

  @override
  String get location => 'Lokasyon';

  @override
  String get downloadsAdded => 'İndirilenler eklendi.';

  @override
  String get addButtonLabel => 'EKLE';

  @override
  String get shareLogs => 'Uygulama dökümlerini paylaş';

  @override
  String get logsCopied => 'Uygulama dökümleri kopyalandı.';

  @override
  String get message => 'Mesaj';

  @override
  String get stackTrace => 'Fonksiyon Çağrı Yığını';

  @override
  String get applicationLegalese =>
      'Mozilla Public License 2.0 ile lisanslandı. Kaynak koda buradan ulaşılabilir:\n\ngithub.com/jmshrv/finamp';

  @override
  String get transcoding => 'Yeniden kodlama (transcoding)';

  @override
  String get downloadLocations => 'İndirilenler Lokasyonları';

  @override
  String get audioService => 'Ses Servisi';

  @override
  String get interactions => 'Etkileşimler';

  @override
  String get layoutAndTheme => 'Düzen & Tema';

  @override
  String get notAvailableInOfflineMode => 'Çevrim dışı modda mevcut değil';

  @override
  String get logOut => 'Çıkış Yap';

  @override
  String get downloadedSongsWillNotBeDeleted =>
      'İndirilmiş şarkılar silinmeyecek';

  @override
  String get areYouSure => 'Emin misiniz?';

  @override
  String get jellyfinUsesAACForTranscoding =>
      'Jellyfin transcoding için AAC kullanıyor';

  @override
  String get enableTranscoding => 'Transcoding\'i aktifleştir';

  @override
  String get enableTranscodingSubtitle =>
      'Sunucu tarafında müzik akışlarını yeniden kodlar.';

  @override
  String get bitrate => 'Bit oranı';

  @override
  String get bitrateSubtitle =>
      'Daha yüksek bir bit oranı, daha fazla bant genişliği kullanır ancak daha kaliteli ses verir.';

  @override
  String get customLocation => 'Farklı Lokasyon';

  @override
  String get appDirectory => 'Uygulama Klasörü';

  @override
  String get addDownloadLocation => 'İndirme Lokasyonu Ekle';

  @override
  String get selectDirectory => 'Klasör Seç';

  @override
  String get unknownError => 'Bilinmeyen Hata';

  @override
  String get pathReturnSlashErrorMessage =>
      '\"/\" döndüren yollar kullanılamaz';

  @override
  String get directoryMustBeEmpty => 'Klasör boş olmalı';

  @override
  String get customLocationsBuggy =>
      'İzinlerden kaynaklanan sorunlar dolayısıyla özel konum seçmek fazlasıyla bug\'a yol açmakta. Şimdilik kullanmanızı önermiyorum, çözmenin bir yolunu düşünüyorum.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Bekletmede Düşük Öncelik Durumuna Geç';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Şarkı duraklatıldığında bildirimin temizlenebilmesini sağlar. Ayrıca Android\'in hizmeti kapatmasına izin verir.';

  @override
  String get shuffleAllSongCount => 'Karıştırılacak Tüm Şarkıların Sayısı';

  @override
  String get shuffleAllSongCountSubtitle =>
      'Tüm şarkıları karıştır butonuna tıklandığında karıştırılacak şarkıların sayısı.';

  @override
  String get viewType => 'Görüntüleme Tipi';

  @override
  String get viewTypeSubtitle => 'Müzik ekranı için görüntüleme tipi';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Izgara';

  @override
  String get portrait => 'Dikey mod';

  @override
  String get landscape => 'Yatay mod';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Izgara Çapraz Eksen Sayısı';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Değer $value olduğunda satır başına kullanılacak ızgara karosu.';
  }

  @override
  String get showTextOnGridView => 'Izgara görünümünde metin göster';

  @override
  String get showTextOnGridViewSubtitle =>
      'Izgara müzik ekranında metin (başlık, sanatçı, vs.) gösterilip gösterilmeyeceğini belirler.';

  @override
  String get showCoverAsPlayerBackground =>
      'Oynatıcı arkaplanı olarak bulanık kapak fotoğrafını göster';

  @override
  String get showCoverAsPlayerBackgroundSubtitle =>
      'Oynatıcı arkaplanı olarak bulanık kapak fotoğrafını gösterilip gösterilmeyeceğini belirler.';

  @override
  String get hideSongArtistsIfSameAsAlbumArtists =>
      'Albüm ile şarkı sanatçısı aynıysa gösterme';

  @override
  String get hideSongArtistsIfSameAsAlbumArtistsSubtitle =>
      'Eğer albüm sanatçısından farklı değilse şarkı sanatçısını albüm ekranında gösterilip gösterilmeyeceğini belirler.';

  @override
  String get disableGesture => 'Jestleri devre dışı bırak';

  @override
  String get disableGestureSubtitle =>
      'Jestleri devre dışı bırakır veya aktifleştirir.';

  @override
  String get showFastScroller => 'Hızlı kaydırıcıyı göster';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistem';

  @override
  String get light => 'Aydınlık';

  @override
  String get dark => 'Karanlık';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get cancelSleepTimer => 'Uyuma Zamanlayıcısını İptal Et?';

  @override
  String get yesButtonLabel => 'EVET';

  @override
  String get noButtonLabel => 'HAYIR';

  @override
  String get setSleepTimer => 'Uyuma Zamanlayıcısını Ayarla';

  @override
  String get minutes => 'Dakika';

  @override
  String get invalidNumber => 'Geçersiz Sayı';

  @override
  String get sleepTimerTooltip => 'Uyku zamanlayıcısı';

  @override
  String get addToPlaylistTooltip => 'Çalma listesine ekle';

  @override
  String get addToPlaylistTitle => 'Listeye Ekle';

  @override
  String get removeFromPlaylistTooltip => 'Çalma listesinden çıkart';

  @override
  String get removeFromPlaylistTitle => 'Listeden Çıkart';

  @override
  String get newPlaylist => 'Yeni Çalma Listesi';

  @override
  String get createButtonLabel => 'OLUŞTUR';

  @override
  String get playlistCreated => 'Çalma listesi oluşturuldu.';

  @override
  String get noAlbum => 'Albüm Yok';

  @override
  String get noItem => 'İçerik Yok';

  @override
  String get noArtist => 'Sanatçı Yok';

  @override
  String get unknownArtist => 'Bilinmeyen Sanatçı';

  @override
  String get streaming => 'YAYIN ALINIYOR';

  @override
  String get downloaded => 'İNDİRİLDİ';

  @override
  String get transcode => 'YENİDEN KODLA';

  @override
  String get direct => 'DİREKT';

  @override
  String get statusError => 'DURUM HATASI';

  @override
  String get queue => 'Kuyruk';

  @override
  String get addToQueue => 'Kuyruğa Ekle';

  @override
  String get playNext => 'Ardından Oynat';

  @override
  String get replaceQueue => 'Kuyruğu Değiştir';

  @override
  String get instantMix => 'Anlık Mix';

  @override
  String get goToAlbum => 'Albüme Git';

  @override
  String get removeFavourite => 'Favoriden Çıkart';

  @override
  String get addFavourite => 'Favoriye Ekle';

  @override
  String get addedToQueue => 'Kuyruğa eklendi.';

  @override
  String get insertedIntoQueue => 'Kuyruğun içine eklendi.';

  @override
  String get queueReplaced => 'Kuyruk değiştirildi.';

  @override
  String get removedFromPlaylist => 'Çalma listesinden çıkarıldı.';

  @override
  String get startingInstantMix => 'Anlık mix başlatılıyor.';

  @override
  String get anErrorHasOccured => 'Bir hata meydana geldi.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Durum kodu $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Durum kodu $statusCode. Muhtemelen yanlış kullanıcı adı veya şifreyi kullandınız ya da uygulamadan çıkış yaptınız.';
  }

  @override
  String get removeFromMix => 'Mix\'ten Çıkart';

  @override
  String get addToMix => 'Mix\'e Ekle';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane yeniden indirildi.',
      one: '$count tane yeniden indirildi.',
      zero: 'Yeniden indirmeye gerek yok.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Önden Kaydetme Süresi';

  @override
  String get bufferDurationSubtitle =>
      'Oynatıcının kaç saniye önden kaydetmesi gerektiğini ayarlar. Yeniden başlatmayı gerektirir.';

  @override
  String get language => 'Dil';

  @override
  String get confirm => 'Onayla';

  @override
  String get showUncensoredLogMessage =>
      'Bu günlük oturum açma bilgilerinizi içerir. Gösterilsin mi?';

  @override
  String get resetTabs => 'Sekmeleri sıfırla';

  @override
  String get noMusicLibrariesTitle => 'Müzik Kütüphanesi Bulunamadı';

  @override
  String get noMusicLibrariesBody =>
      'Finamp herhangi bir müzik kütüphanesi bulamadı. Lütfen Jellyfin sunucunun içerik türü \"Müzik\" olarak ayarlanmış en az bir kütüphaneye sahip olduğundan emin ol.';

  @override
  String get refresh => 'YENİLE';

  @override
  String get swipeInsertQueueNext => 'Kaydırılan Şarkıyı Ardından Oynat';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Şarkı listesinde kaydırıldığında bir şarkıyı sona eklemek yerine sıradaki öge olarak eklemeyi etkinleştirin.';

  @override
  String get redesignBeta => 'Yeniden Tasarım Beta';

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
