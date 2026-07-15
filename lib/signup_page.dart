import 'package:flutter/material.dart';

import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'onboarding.dart';
import 'services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final age = int.tryParse(_ageController.text.trim());

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        age == null) {
      _showError('Please fill in username, email, phone, age, and password.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.register(
        username: username,
        email: email,
        phone: phone,
        age: age,
        password: password,
        rememberMe: true,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    } catch (e) {
      _showError(e.toString().replaceFirst('ApiException(', '').replaceAll(')', ''));
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
      appBar: AppBar(
        title: Text('Create account', style: HawaTypography.body(size: 18, weight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Join Hawa Health', style: HawaTypography.display('Join Hawa Health', size: 30)),
              const SizedBox(height: 8),
              Text('Create your private account', style: HawaTypography.bodySecondary(size: 14)),
              const SizedBox(height: 24),
              HawaCard(
                child: Column(
                  children: [
                    HawaUnderlineField(
                      label: 'Username',
                      controller: _usernameController,
                      hint: 'your_username',
                    ),
                    const SizedBox(height: 20),
                    HawaUnderlineField(
                      label: 'Email',
                      controller: _emailController,
                      hint: 'you@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    HawaUnderlineField(
                      label: 'Phone',
                      controller: _phoneController,
                      hint: '+254712345678',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    HawaUnderlineField(
                      label: 'Age',
                      controller: _ageController,
                      hint: '25',
                      keyboardType: TextInputType.number,
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
                    const SizedBox(height: 24),
                    HawaPrimaryButton(
                      label: _loading ? 'Creating…' : 'Sign up',
                      enabled: !_loading,
                      onPressed: _register,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: HawaPrivacyBadge()),
            ],
          ),
        ),
      ),
    );
  }
}
