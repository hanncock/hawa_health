import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Dash.dart';
import 'design/hawa_design_system.dart';
import 'login_page.dart';
import 'onboarding.dart';
import 'services/session_service.dart';
import 'theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const HawaHealthApp(),
    ),
  );
}

class HawaHealthApp extends StatelessWidget {
  const HawaHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawa Health',
      debugShowCheckedModeBanner: false,
      theme: buildHawaTheme(),
      home: const AppEntry(),
    );
  }
}

/// Routes to login, onboarding, or dashboard based on persisted session.
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  final _session = SessionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _resolveStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: HawaColors.cream,
            body: Center(
              child: CircularProgressIndicator(color: HawaColors.primary),
            ),
          );
        }
        return snapshot.data!;
      },
    );
  }

  Future<Widget> _resolveStartScreen() async {
    final loggedIn = await _session.isLoggedIn();
    if (!loggedIn) return const LoginPage();

    final onboardingDone = await _session.isOnboardingComplete();
    if (!onboardingDone) return const OnboardingPage();

    return const HawaDashboardPage();
  }
}
