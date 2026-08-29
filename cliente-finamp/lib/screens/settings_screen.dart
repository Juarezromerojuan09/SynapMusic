import 'package:finamp/screens/interaction_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:locale_names/locale_names.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/finamp_settings_helper.dart';
import '../services/locale_helper.dart';
import 'transcoding_settings_screen.dart';
import 'downloads_settings_screen.dart';
import 'audio_service_settings_screen.dart';
import 'layout_settings_screen.dart';
import '../components/SettingsScreen/logout_list_tile.dart';
import 'view_selector.dart';
import 'language_selection_screen.dart';
import 'synap_music/admin_dashboard_screen.dart';
import '../services/jellyfin_api_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.about,
            icon: const Icon(Icons.info),
            onPressed: () async {
              final applicationLegalese =
                  AppLocalizations.of(context)!.applicationLegalese;
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              showAboutDialog(
                context: context,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationLegalese: applicationLegalese,
              );
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            FutureBuilder<bool>(
              future: Future<bool>.microtask(() async {
                try {
                  final userHelper = GetIt.instance<FinampUserHelper>();
                  final currentUser = userHelper.currentUser;
                  if (currentUser == null) return false;
                  
                  final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
                  final response = await http.get(url, headers: {
                    'X-Emby-Token': currentUser.accessToken,
                  });
                  
                  if (response.statusCode == 200) {
                    final data = json.decode(response.body);
                    return data['Policy']?['IsAdministrator'] ?? false;
                  }
                  return false;
                } catch (e) {
                  return false;
                }
              }),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF144477)),
                    title: const Text('Panel de Administrador (Sala de Espera)'),
                    onTap: () => Navigator.of(context).pushNamed(AdminDashboardScreen.routeName),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            ListTile(
              leading: const Icon(Icons.compress),
              title: Text(AppLocalizations.of(context)!.transcoding),
              onTap: () => Navigator.of(context)
                  .pushNamed(TranscodingSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(AppLocalizations.of(context)!.downloadLocations),
              onTap: () => Navigator.of(context)
                  .pushNamed(DownloadsSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(AppLocalizations.of(context)!.audioService),
              onTap: () => Navigator.of(context)
                  .pushNamed(AudioServiceSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.gesture),
              title: Text(AppLocalizations.of(context)!.interactions),
              onTap: () => Navigator.of(context)
                  .pushNamed(InteractionSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: Text(AppLocalizations.of(context)!.layoutAndTheme),
              onTap: () => Navigator.of(context)
                  .pushNamed(LayoutSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.library_music),
              title: Text(AppLocalizations.of(context)!.selectMusicLibraries),
              subtitle: FinampSettingsHelper.finampSettings.isOffline
                  ? Text(
                      AppLocalizations.of(context)!.notAvailableInOfflineMode)
                  : null,
              enabled: !FinampSettingsHelper.finampSettings.isOffline,
              onTap: () =>
                  Navigator.of(context).pushNamed(ViewSelector.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              subtitle: Text(LocaleHelper.locale?.nativeDisplayLanguage ??
                  AppLocalizations.of(context)!.system),
              onTap: () => Navigator.of(context)
                  .pushNamed(LanguageSelectionScreen.routeName),
            ),
            const LogoutListTile(),
          ],
        ),
      ),
    );
  }
}
