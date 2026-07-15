import 'package:flutter/material.dart';

import 'Dash.dart';
import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'onboarding.dart';
import 'services/auth_service.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;
  bool _remember = false;
  bool _loading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadRemembered();
  }

  Future<void> _loadRemembered() async {
    final saved = await _auth.session.loadRememberedCredentials();
    if (saved.username != null) {
      setState(() {
        _usernameController.text = saved.username!;
        _remember = true;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      _showError('Please enter your username.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.signIn(username: username, rememberMe: _remember);
      if (!mounted) return;

      final onboardingDone = await _auth.session.isOnboardingComplete();
      if (!mounted) return;

      final next = onboardingDone ? const HawaDashboardPage() : const OnboardingPage();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => next,
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: HawaCurves.smooth),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      _showError('Could not sign in. Check your username and try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Text(
                  'Welcome back',
                  style: HawaTypography.display('Welcome back', size: 34),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your private health space',
                  style: HawaTypography.bodySecondary(size: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                HawaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: HawaColors.secondary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: HawaColors.primary,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      HawaUnderlineField(
                        label: 'Username',
                        controller: _usernameController,
                        hint: 'your_username',
                      ),
                      const SizedBox(height: 20),
                      HawaUnderlineField(
                        label: 'Password',
                        controller: _passwordController,
                        hint: '••••••••',
                        obscureText: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: HawaColors.ink60,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            onChanged: (v) => setState(() => _remember = v ?? false),
                          ),
                          Text('Remember me', style: HawaTypography.bodySecondary(size: 13)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot?',
                              style: HawaTypography.body(
                                size: 13,
                                weight: FontWeight.w600,
                                color: HawaColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      HawaPrimaryButton(
                        label: _loading ? 'Signing in…' : 'Sign in',
                        enabled: !_loading,
                        onPressed: _signIn,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Don't have an account? ", style: HawaTypography.bodySecondary(size: 13)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: HawaTypography.body(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: HawaColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const HawaPrivacyBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
