import '../api/hawa_api.dart';
import '../api/models.dart';
import 'session_service.dart';

class AuthService {
  AuthService({HawaApi? api, SessionService? session})
      : _api = api ?? HawaApi(),
        _session = session ?? SessionService();

  final HawaApi _api;
  final SessionService _session;

  HawaApi get api => _api;
  SessionService get session => _session;

  /// Sign in by verifying the user exists on the API.
  Future<UserModel> signIn({
    required String username,
    bool rememberMe = false,
  }) async {
    final user = await _api.getUser(username.trim());
    await _session.saveUser(user, rememberMe: rememberMe);
    return user;
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String phone,
    required int age,
    required String password,
    bool rememberMe = true,
  }) async {
    final user = await _api.register(
      username: username.trim(),
      email: email.trim(),
      phone: phone.trim(),
      age: age,
      password: password,
    );
    await _session.saveUser(user, rememberMe: rememberMe);
    return user;
  }

  Future<void> signOut() => _session.clearSession();
}
