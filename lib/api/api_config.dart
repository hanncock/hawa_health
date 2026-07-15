import 'dart:io';

/// Base URL for the Hawa Services API.
/// Android emulator uses 10.0.2.2 to reach the host machine's localhost.
class ApiConfig {
  static const int port = 8000;

  static String get baseUrl {
    if (Platform.isAndroid) {
      // return 'http://10.0.2.2:$port';
      // return 'http://192.168.88.242:$port';
      // return 'http://192.168.88.242:8000';
      return 'https://dab3-217-21-121-52.ngrok-free.app';
    }
    return 'http://127.0.0.1:$port';
  }

  static String get apiRoot => '$baseUrl/api';
}
