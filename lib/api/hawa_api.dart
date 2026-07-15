import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'models.dart';

class HawaApi {
  HawaApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> _decode(http.Response response) async {
    final body = response.body.isEmpty ? '{}' : response.body;
    Map<String, dynamic> json;
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      if (response.statusCode >= 400) {
        throw ApiException(
          'Request failed (${response.statusCode})',
          statusCode: response.statusCode,
          body: body,
        );
      }
      rethrow;
    }

    if (response.statusCode >= 400) {
      final detail = json['detail'] ?? json['message'] ?? body;
      throw ApiException(
        detail is String ? detail : detail.toString(),
        statusCode: response.statusCode,
        body: body,
      );
    }
    return json;
  }

  Future<List<dynamic>> _decodeList(http.Response response) async {
    if (response.statusCode >= 400) {
      throw ApiException(
        'Request failed (${response.statusCode})',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('${ApiConfig.apiRoot}$path').replace(queryParameters: query);
  }

  // --- User ---

  /// POST /api/user/register
  /// Body: { username, email, phone, age, password }
  Future<UserModel> register({
    required String username,
    required String email,
    required String phone,
    required int age,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'phone': phone,
        'age': age,
        'password': password,
      }),
    );
    final json = await _decode(response);
    return UserModel.fromJson(json);
  }

  Future<UserModel> getUser(String username) async {
    final response = await _client.get(_uri('/user/$username/'));
    final json = await _decode(response);
    return UserModel.fromJson(json);
  }

  // --- Cycles ---

  Future<UserCyclesModel> getCycles(String username) async {
    final response = await _client.get(_uri('/user/$username/cycles/'));
    final json = await _decode(response);
    return UserCyclesModel.fromJson(json);
  }

  Future<UserCyclesModel> createCycle(
    String username, {
    required DateTime startDate,
    required DateTime endDate,
    int? periodLength,
    String? status,
  }) async {
    final response = await _client.post(
      _uri('/user/$username/cycles/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
        if (periodLength != null) 'period_length': periodLength,
        if (status != null) 'status': status,
      }),
    );
    final json = await _decode(response);
    return UserCyclesModel.fromJson(json);
  }

  // --- Symptoms ---

  Future<List<String>> getSymptomCatalog() async {
    final response = await _client.get(_uri('/user/symptoms/'));
    final list = await _decodeList(response);
    return list.map((e) => e.toString()).toList();
  }

  Future<List<SymptomLogModel>> getUserSymptoms(String username) async {
    final response = await _client.get(_uri('/user/$username/symptoms/'));
    final list = await _decodeList(response);
    return list.map((e) => SymptomLogModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SymptomLogModel> addSymptom(
    String username, {
    required String cycleId,
    String? bleeding,
    String? mood,
    String? fatigue,
    String? bloating,
    String? painLevel,
    bool headache = false,
    bool acneFlare = false,
    String notes = '',
  }) async {
    final response = await _client.post(
      _uri('/user/$username/symptoms/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cycle_id': cycleId,
        if (bleeding != null) 'bleeding': bleeding,
        if (mood != null) 'mood': mood,
        if (fatigue != null) 'fatigue': fatigue,
        if (bloating != null) 'bloating': bloating,
        if (painLevel != null) 'pain_level': painLevel,
        'headache': headache,
        'acne_flare': acneFlare,
        'notes': notes,
      }),
    );
    final json = await _decode(response);
    return SymptomLogModel.fromJson(json);
  }

  // --- Predictions ---

  Future<PredictionModel> predictForUser(String username, {String? algorithm}) async {
    final response = await _client.post(
      _uri('/predictions/$username/predict', algorithm != null ? {'algorithm': algorithm} : null),
    );
    final json = await _decode(response);
    return PredictionModel.fromJson(json);
  }

  Future<PredictionModel> latestPrediction(String username) async {
    final response = await _client.get(_uri('/predictions/$username/latest'));
    final json = await _decode(response);
    return PredictionModel.fromJson(json);
  }
}
