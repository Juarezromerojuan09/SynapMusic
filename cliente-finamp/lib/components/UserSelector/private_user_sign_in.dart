import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/logs_screen.dart';
import '../../screens/view_selector.dart';
import '../../screens/synap_music/main_home_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../error_snackbar.dart';
import '../../screens/synap_music/register_screen.dart';

class PrivateUserSignIn extends StatefulWidget {
  const PrivateUserSignIn({Key? key}) : super(key: key);

  @override
  State<PrivateUserSignIn> createState() => _PrivateUserSignInState();
}

class _PrivateUserSignInState extends State<PrivateUserSignIn> {
  bool isAuthenticating = false;

  String? baseUrl = "http://100.81.156.126:8096";
  String? username;
  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF8C93FD),
            Color(0xFF7574E4),
            Color(0xFF5F57CD),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'images/finamp.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SynapMusic',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: formKey,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.username],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: AppLocalizations.of(context)!.username,
                                  prefixIcon: const Icon(Icons.person),
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                                onSaved: (newValue) => username = newValue,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                autocorrect: false,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: AppLocalizations.of(context)!.password,
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) async => await sendForm(),
                                onSaved: (newValue) => password = newValue,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: isAuthenticating ? null : () async => await sendForm(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B93FF),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isAuthenticating
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                    : Text(
                                        AppLocalizations.of(context)!.next.toUpperCase(),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/register'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "REGISTRARSE",
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(LogsScreen.routeName),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white70,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.logs.toUpperCase(),
                          style: const TextStyle(letterSpacing: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Function to handle logging in for Widgets, including a snackbar for errors.
  Future<void> loginHelper(
      {required String username,
      String? password,
      required String baseUrl,
      required BuildContext context}) async {
    JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    // We trim the base url in case the user accidentally added some trailing whitespce
    baseUrl = baseUrl.trim();

    jellyfinApiHelper.baseUrlTemp = Uri.parse(baseUrl);

    try {
      if (password == null) {
        await jellyfinApiHelper.authenticateViaName(username: username);
      } else {
        await jellyfinApiHelper.authenticateViaName(
          username: username,
          password: password,
        );
      }

      // Auto-configure music views to seamlessly transition directly to SynapMusic
      try {
        final finampUserHelper = GetIt.instance<FinampUserHelper>();
        final views = await jellyfinApiHelper.getViews();
        final musicViews = views
            .where((element) => element.collectionType == "music")
            .toList();
        final selectedViews = musicViews.isNotEmpty
            ? musicViews
            : views.where((element) => element.collectionType != "playlists").toList();

        if (selectedViews.isNotEmpty) {
          finampUserHelper.setCurrentUserViews(selectedViews);
        }
      } catch (e) {
        debugPrint("Auto-configuring views error: $e");
      }

      if (!mounted) return;

      final finampUserHelper = GetIt.instance<FinampUserHelper>();
      if (finampUserHelper.currentUser?.currentView != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          MainHomeScreen.routeName,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamed(ViewSelector.routeName);
      }
    } catch (e) {
      errorSnackbar(e, context);

      // We return here to stop the function from continuing.
      return;
    }
  }

  Future<void> sendForm() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState!.save();
      setState(() {
        isAuthenticating = true;
      });
      await loginHelper(
        username: username!,
        password: password,
        baseUrl: baseUrl!,
        context: context,
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }
}
