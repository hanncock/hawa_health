class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UserModel {
  UserModel({
    required this.username,
    required this.email,
    required this.age,
    this.id,
    this.phone,
  });

  final String? id;
  final String username;
  final String email;
  final int age;
  final String? phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      phone: json['phone'] as String?,
    );
  }
}

class CycleModel {
  CycleModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.updatedAt,
  });

  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime updatedAt;

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    return CycleModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  int get periodLengthDays => endDate.difference(startDate).inDays + 1;
}

class UserCyclesModel {
  UserCyclesModel({required this.username, required this.cycleRecords});

  final String username;
  final List<CycleModel> cycleRecords;

  factory UserCyclesModel.fromJson(Map<String, dynamic> json) {
    final records = (json['cycle_records'] as List<dynamic>? ?? [])
        .map((e) => CycleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserCyclesModel(
      username: json['username'] as String,
      cycleRecords: records,
    );
  }
}

class PredictionModel {
  PredictionModel({
    required this.id,
    required this.nextPeriodStart,
    required this.nextPeriodEnd,
    required this.predictedCycleLength,
    required this.predictedPeriodLength,
    required this.confidenceLevel,
    required this.algorithmUsed,
    required this.numCyclesUsed,
  });

  final String id;
  final DateTime nextPeriodStart;
  final DateTime nextPeriodEnd;
  final int predictedCycleLength;
  final int predictedPeriodLength;
  final String confidenceLevel;
  final String algorithmUsed;
  final int numCyclesUsed;

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'] as String,
      nextPeriodStart: DateTime.parse(json['next_period_start'] as String),
      nextPeriodEnd: DateTime.parse(json['next_period_end'] as String),
      predictedCycleLength: json['predicted_cycle_length'] as int,
      predictedPeriodLength: json['predicted_period_length'] as int,
      confidenceLevel: json['confidence_level'] as String,
      algorithmUsed: json['algorithm_used'] as String,
      numCyclesUsed: json['num_cycles_used'] as int,
    );
  }
}

class SymptomLogModel {
  SymptomLogModel({
    required this.id,
    required this.cycleId,
    required this.createdAt,
    this.notes,
    this.bleeding,
    this.mood,
    this.headache = false,
    this.bloating,
    this.fatigue,
    this.acneFlare = false,
  });

  final String id;
  final String cycleId;
  final DateTime createdAt;
  final String? notes;
  final String? bleeding;
  final String? mood;
  final bool headache;
  final String? bloating;
  final String? fatigue;
  final bool acneFlare;

  factory SymptomLogModel.fromJson(Map<String, dynamic> json) {
    return SymptomLogModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      notes: json['notes'] as String?,
      bleeding: json['bleeding'] as String?,
      mood: json['mood'] as String?,
      headache: json['headache'] as bool? ?? false,
      bloating: json['bloating'] as String?,
      fatigue: json['fatigue'] as String?,
      acneFlare: json['acne_flare'] as bool? ?? false,
    );
  }
}
