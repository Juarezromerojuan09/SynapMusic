with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

content = content.replace('''    _topMexicoFuture = _apiService.getTopMexico();
  }
    _checkAdminStatus();
  }''', '''    _topMexicoFuture = _apiService.getTopMexico();
    _checkAdminStatus();
  }''')

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

