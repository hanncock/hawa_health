import 'package:shared_preferences/shared_preferences.dart';

import '../api/models.dart';

/// Persists login session locally via SharedPreferences.
class SessionService {
  static const _loggedIn = 'logged_in';
  static const _username = 'username';
  static const _email = 'email';
  static const _age = 'age';
  static const _userId = 'user_id';
  static const _phone = 'phone';
  static const _onboardingComplete = 'onboarding_complete';
  static const _rememberMe = 'remember_me';
  static const _savedUsername = 'saved_username';
  static const _savedEmail = 'saved_email';
  static const _lastPeriodStart = 'last_period_start';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedIn) ?? false;
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingComplete) ?? false;
  }

  Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_loggedIn) ?? false)) return null;

    final username = prefs.getString(_username);
    if (username == null) return null;

    return UserModel(
      id: prefs.getString(_userId),
      username: username,
      email: prefs.getString(_email) ?? '',
      age: prefs.getInt(_age) ?? 0,
      phone: prefs.getString(_phone),
    );
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_username);
  }

  Future<DateTime?> getLastPeriodStart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastPeriodStart);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> saveUser(UserModel user, {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedIn, true);
    await prefs.setString(_username, user.username);
    await prefs.setString(_email, user.email);
    await prefs.setInt(_age, user.age);
    if (user.id != null) await prefs.setString(_userId, user.id!);
    if (user.phone != null) await prefs.setString(_phone, user.phone!);

    await prefs.setBool(_rememberMe, rememberMe);
    if (rememberMe) {
      await prefs.setString(_savedUsername, user.username);
      await prefs.setString(_savedEmail, user.email);
    } else {
      await prefs.remove(_savedUsername);
      await prefs.remove(_savedEmail);
    }
  }

  Future<({String? username, String? email})> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_rememberMe) ?? false)) {
      return (username: null, email: null);
    }
    return (
      username: prefs.getString(_savedUsername),
      email: prefs.getString(_savedEmail),
    );
  }

  Future<void> setOnboardingComplete({DateTime? lastPeriodStart}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingComplete, true);
    if (lastPeriodStart != null) {
      await prefs.setString(_lastPeriodStart, lastPeriodStart.toIso8601String());
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberMe) ?? false;
    final savedUsername = prefs.getString(_savedUsername);
    final savedEmail = prefs.getString(_savedEmail);

    await prefs.remove(_loggedIn);
    await prefs.remove(_username);
    await prefs.remove(_email);
    await prefs.remove(_age);
    await prefs.remove(_userId);
    await prefs.remove(_phone);
    await prefs.remove(_onboardingComplete);
    await prefs.remove(_lastPeriodStart);

    if (remember) {
      await prefs.setBool(_rememberMe, true);
      if (savedUsername != null) await prefs.setString(_savedUsername, savedUsername);
      if (savedEmail != null) await prefs.setString(_savedEmail, savedEmail);
    }
  }
}
