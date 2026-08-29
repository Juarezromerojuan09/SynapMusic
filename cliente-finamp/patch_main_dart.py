with open('lib/main.dart', 'r') as f:
    content = f.read()

import re

# Add imports
if "register_screen.dart" not in content:
    content = content.replace("import 'screens/splash_screen.dart';", "import 'screens/splash_screen.dart';\nimport 'screens/synap_music/register_screen.dart';\nimport 'screens/synap_music/admin_dashboard_screen.dart';")

# Add routes
routes_pattern = r"UserSelector\.routeName: \(context\) => const UserSelector\(\),"
new_routes = """UserSelector.routeName: (context) => const UserSelector(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        AdminDashboardScreen.routeName: (context) => const AdminDashboardScreen(),"""

content = re.sub(routes_pattern, new_routes, content)

with open('lib/main.dart', 'w') as f:
    f.write(content)

print("Routes added to main.dart")
