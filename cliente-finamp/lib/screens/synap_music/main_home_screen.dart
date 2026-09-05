import 'admin_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_it/get_it.dart';

import '../../screens/settings_screen.dart';
import '../../screens/downloads_screen.dart';
import '../../screens/splash_screen.dart';
import '../album_screen.dart';

import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../../services/synap_api_service.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/audio_service_helper.dart';

import '../../components/now_playing_bar.dart';

import 'download_screen.dart';
import 'library_playlists_screen.dart';
import 'album_detail_screen.dart';
import 'artist_profile_screen.dart';
import 'user_profile_screen.dart';
import 'help_feedback_screen.dart';

import '../../models/jellyfin_models.dart';

class MainHomeScreen extends StatefulWidget {
  static const String routeName = '/main-home';

  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _pages = [
    TabNavigator(navigatorKey: _navigatorKeys[0], child: const HomeTab()),
    TabNavigator(navigatorKey: _navigatorKeys[1], child: const DownloadScreen()),
    TabNavigator(navigatorKey: _navigatorKeys[2], child: const LibraryPlaylistsScreen()),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color synapColor = Color(0xFF8B93FF);

    return WillPopScope(
      onWillPop: () async {
        final bool didPop = await _navigatorKeys[_currentIndex].currentState?.maybePop() ?? false;
        final isFirstRouteInCurrentTab = !didPop;
        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            _onTabTapped(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
            // Mini Reproductor de Finamp
            const NowPlayingBar(),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: const Color(0xFF0A0A0A),
        selectedItemColor: synapColor,
        unselectedItemColor: const Color(0xFFA0A0A0),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Encontrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.album),
            label: 'Biblioteca',
          ),
        ],
      ),
    ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final SynapApiService _apiService = SynapApiService();
  late String _userId;
  bool _isAdmin = false;

  Stream<List<dynamic>>? _topSongsStream;
  Stream<List<dynamic>>? _topArtistsStream;
  Stream<List<dynamic>>? _topAlbumsStream;
  Stream<List<dynamic>>? _newReleasesStream;
  Stream<List<dynamic>>? _topMexicoStream;

  @override
  void initState() {
    super.initState();
    final userHelper = GetIt.instance<FinampUserHelper>();
    _userId = userHelper.currentUser?.id ?? "";

    _topSongsStream = _apiService.getTopSongsStream(_userId);
    _topArtistsStream = _apiService.getTopArtistsStream(_userId);
    _topAlbumsStream = _apiService.getTopAlbumsStream(_userId);
    _newReleasesStream = _apiService.getNewReleasesStream(_userId);
    _topMexicoStream = _apiService.getTopMexicoStream();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final currentUser = userHelper.currentUser;
      if (currentUser == null) return;
      
      final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
      final response = await http.get(url, headers: {
        'X-Emby-Token': currentUser.accessToken,
      });
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isAdmin = data['Policy']?['IsAdministrator'] ?? false;
        if (isAdmin != _isAdmin && mounted) {
          setState(() {
            _isAdmin = isAdmin;
          });
        }
      }
    } catch (e) {
      // ignore
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildHorizontalList(Stream<List<dynamic>>? stream, Widget Function(dynamic, int) itemBuilder) {
    return StreamBuilder<List<dynamic>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 150,
            child: Center(child: Text("No hay datos disponibles.")),
          );
        }

        final items = snapshot.data!;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: itemBuilder(items[index], index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCard(String imageUrl, String title, String subtitle, {bool isCircular = false, VoidCallback? onTap, int? rank, String? extraSubtitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: isCircular ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isCircular ? null : BorderRadius.circular(12),
                    color: const Color(0xFF1A1A1A),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: Icon(
                        isCircular ? Icons.person : Icons.music_note,
                        size: 48,
                        color: const Color(0xFFA0A0A0),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B93FF)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (rank != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A), // Círculo oscuro
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2), // Borde blanco delgado de 2px
                      ),
                      child: Center(
                        child: Text(
                          '$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isCircular ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isCircular ? TextAlign.center : TextAlign.start,
            ),
            if (extraSubtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                extraSubtitle,
                style: const TextStyle(
                  color: Color(0xFF8B93FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: isCircular ? TextAlign.center : TextAlign.start,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userHelper = GetIt.instance<FinampUserHelper>();
    final serverUrl = 'http://100.81.156.126:8096'; // We can just use the VPN IP for now
    final userImageUrl = '${serverUrl}/Users/${_userId}/Images/Primary';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16.0,
        title: const Text(
          'SynapMusic',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8B93FF),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              color: const Color(0xFF1A1A1A),
              onSelected: (value) async {
                if (value == 'profile') {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                  ).then((_) {
                    if (mounted) setState(() {});
                  });
                } else if (value == 'settings') {
                  Navigator.of(context, rootNavigator: true).pushNamed(SettingsScreen.routeName);
                } else if (value == 'admin') {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                  );
                } else if (value == 'help') {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => HelpFeedbackScreen(isAdmin: _isAdmin)),
                  );
                } else if (value == 'logout') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      content: const Text('¿Estás seguro de que deseas cerrar sesión?', style: TextStyle(color: Color(0xFFA0A0A0))),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA0A0A0))),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
                      if (audioHandler.playbackState.valueOrNull?.playing == true) {
                        await audioHandler.stop();
                      }
                      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
                      await jellyfinApiHelper.logoutCurrentUser().onError((_, __) {});
                      
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                }
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF1A1A1A),
                backgroundImage: CachedNetworkImageProvider(userImageUrl),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, color: Color(0xFFA0A0A0), size: 20),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text('Perfil', style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: 'settings', child: Text('Configuración', style: TextStyle(color: Colors.white))),
                if (_isAdmin)
                  const PopupMenuItem(value: 'admin', child: Text('Admin', style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: 'help', child: Text('Ayuda y comentarios', style: TextStyle(color: Colors.white))),
                const PopupMenuDivider(height: 1),
                const PopupMenuItem(value: 'logout', child: Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent))),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildSectionTitle('Top 10 México'),
            _buildHorizontalList(_topMexicoStream, (item, index) {
              return _buildCard(item['cover_url'] ?? '', item['title'] ?? '', item['artist'] ?? '', rank: index + 1, onTap: () {
                if (item['local_id'] != null) {
                  // Reproducir localmente
                  BaseItemDto track;
                  if (item['jellyfin_item'] != null) {
                    track = BaseItemDto.fromJson(item['jellyfin_item']);
                  } else {
                    track = BaseItemDto(
                      id: item['local_id'],
                      name: item['title'],
                      type: 'Audio',
                    );
                  }
                  final audioHandler = GetIt.instance<AudioServiceHelper>();
                  audioHandler.replaceQueueWithItem(itemList: [track]).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reproduciendo canción...')));
                  });
                } else {
                  // Poner a descargar
                  _apiService.downloadMedia(item['query_string'] ?? '${item['title']} ${item['artist']}').then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Canción enviada a descargar')));
                  });
                }
              });
            }),

            _buildSectionTitle('Tus Canciones Más Escuchadas'),
            _buildHorizontalList(_topSongsStream, (item, index) {
              final cover = 'http://100.81.156.126:8096/Items/${item['Id']}/Images/Primary';
              final artist = (item['Artists'] != null && (item['Artists'] as List).isNotEmpty) 
                  ? item['Artists'][0] : 'Desconocido';
              final playCount = (item['UserData'] != null && item['UserData']['PlayCount'] != null) 
                  ? item['UserData']['PlayCount'] : 0;
              final extraSubtitle = playCount == 1 ? '1 vez' : '$playCount veces';
              return _buildCard(cover, item['Name'] ?? '', artist, extraSubtitle: extraSubtitle, onTap: () {
                final track = BaseItemDto.fromJson(item);
                final audioHandler = GetIt.instance<AudioServiceHelper>();
                audioHandler.replaceQueueWithItem(itemList: [track]).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reproduciendo canción...')));
                });
              });
            }),

            _buildSectionTitle('Tus Artistas Favoritos'),
            _buildHorizontalList(_topArtistsStream, (item, index) {
              return _buildCard(item['cover_url'] ?? '', item['name'] ?? '', '', isCircular: true, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArtistProfileScreen(artistName: item['name']),
                ));
              });
            }),

            _buildSectionTitle('Álbumes Recomendados'),
            _buildHorizontalList(_topAlbumsStream, (item, index) {
              return _buildCard(item['cover_url'] ?? '', item['title'] ?? '', item['artist'] ?? '', onTap: () {
                if (item['source'] == 'local' && item['jellyfin_item'] != null) {
                  // Abre vista nativa
                  final albumItem = BaseItemDto(
                    id: item['id'],
                    name: item['title'],
                    type: 'MusicAlbum',
                  );
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AlbumScreen(), settings: RouteSettings(arguments: albumItem)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(albumId: item['id']),
                  ));
                }
              });
            }),

            _buildSectionTitle('Novedades para Ti'),
            _buildHorizontalList(_newReleasesStream, (item, index) {
              return _buildCard(item['cover_url'] ?? '', item['title'] ?? '', item['artist'] ?? '', onTap: () {
                if (item['source'] == 'local' && item['jellyfin_item'] != null) {
                  // Abre vista nativa
                  final albumItem = BaseItemDto(
                    id: item['id'],
                    name: item['title'],
                    type: 'MusicAlbum',
                  );
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AlbumScreen(), settings: RouteSettings(arguments: albumItem)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(albumId: item['id']),
                  ));
                }
              });
            }),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const TabNavigator({super.key, required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
