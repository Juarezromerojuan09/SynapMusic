import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()


vars_old = """  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    HomeTab(),
    DownloadScreen(),
    LibraryPlaylistsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }"""

vars_new = """  int _currentIndex = 0;

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
  }"""

content = content.replace(vars_old, vars_new)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)
