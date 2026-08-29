with open('lib/screens/settings_screen.dart', 'r') as f:
    content = f.read()

if "admin_dashboard_screen.dart" not in content:
    content = content.replace("import '../services/jellyfin_api_helper.dart';", "import '../services/jellyfin_api_helper.dart';\nimport 'synap_music/admin_dashboard_screen.dart';")

# Add a ListTile for the admin dashboard
# Let's search for "ListTile(" and insert it after the first one or at the top of the list.
# Actually, the settings list usually has "Accounts" or similar.
# We can just put it right before the "Logout" or something. Let's see what's in settings.
