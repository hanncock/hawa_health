import 'dart:math';

enum Mood { happy, sad, anxious, energetic, tired, calm }

enum FlowIntensity { light, medium, heavy, spotting, veryHeavy }

enum FertilityStatus { low, medium, high, ovulation }

class UserProfile {
  final String name;
  final String email;
  final DateTime dateOfBirth;
  final String phone;
  final String location;
  final DateTime lastPeriodDate;
  final int cycleLength; // Average cycle length in days
  final int periodLength; // Average period duration in days
  final bool isRegular;
  final String? profileImage;

  const UserProfile({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.location,
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.isRegular = true,
    this.profileImage,
  });
}

class DailyLog {
  final DateTime date;
  final FlowIntensity? flow;
  final Mood? mood;
  final List<String> symptoms; // e.g., "Cramps", "Headache"
  final double? weight; // in kg
  final double? temperature; // in Fahrenheit
  final bool sexualActivity; // true if intercourse happened
  final bool protectedSex;
  final int waterIntake; // in glasses (approx 250ml)
  final String? notes;

  const DailyLog({
    required this.date,
    this.flow,
    this.mood,
    this.symptoms = const [],
    this.weight,
    this.temperature,
    this.sexualActivity = false,
    this.protectedSex = false,
    this.waterIntake = 0,
    this.notes,
  });
}

class MockData {
  // Current logged in user
  static final UserProfile currentUser = UserProfile(
    name: "Jane Doe",
    email: "jane.doe@example.com",
    dateOfBirth: DateTime(1995, 3, 15),
    phone: "+1 (555) 123-4567",
    location: "New York, USA",
    lastPeriodDate: DateTime(2024, 1, 14),
    cycleLength: 28,
    periodLength: 5,
    isRegular: true,
  );

  // Store logs in a map for easy date lookup
  // Key: DateTime (normalized to midnight)
  static final Map<DateTime, DailyLog> _logs = _generateMockLogs();

  static Map<DateTime, DailyLog> _generateMockLogs() {
    final Map<DateTime, DailyLog> logs = {};
    final random = Random();
    final today = DateTime.now();

    // Generate logs for the past 60 days and next 30 days
    for (int i = -60; i <= 30; i++) {
      final date = DateTime(today.year, today.month, today.day).add(Duration(days: i));
      
      // Simulate some realistic patterns
      FlowIntensity? flow;
      
      // Rough simulation of a period every 28 days
      // Assuming a cycle started exactly cycleLength days ago from the lastPeriodDate
      // For simplicity, let's just use the user's lastPeriodDate as anchor
      final daysSinceLastPeriod = date.difference(currentUser.lastPeriodDate).inDays;
      final cycleDay = (daysSinceLastPeriod % currentUser.cycleLength);
      
      // If cycleDay is negative (date is before lastPeriodDate), handle modulo correctly for past
      // But for simplicity let's stick to forward calculation or simple mock logic
      
      // Actually, let's just sprinkle some data based on simple random logic 
      // but biased to look somewhat real
      
      if (cycleDay >= 0 && cycleDay < currentUser.periodLength) {
        // It's a period day
        if (cycleDay == 0 || cycleDay == currentUser.periodLength - 1) {
          flow = FlowIntensity.light;
        } else if (cycleDay == 1) {
             flow = FlowIntensity.medium;
        } else {
             flow = FlowIntensity.heavy;
        }
      }

      logs[date] = DailyLog(
        date: date,
        flow: flow,
        mood: Mood.values[random.nextInt(Mood.values.length)],
        symptoms: _generateRandomSymptoms(random, flow != null),
        weight: 60.0 + random.nextDouble() * 2 - 1, // Fluctuate around 60kg
        temperature: 98.0 + random.nextDouble(), // 98.0 - 99.0 F
        sexualActivity: random.nextDouble() < 0.1, // 10% chance
        protectedSex: random.nextBool(),
        waterIntake: random.nextInt(10), // 0-9 glasses
        notes: random.nextDouble() < 0.2 ? "Feeling okay today." : null,
      );
    }
    return logs;
  }

  static List<String> _generateRandomSymptoms(Random random, bool isPeriod) {
    List<String> potentialSymptoms = isPeriod 
      ? ["Cramps", "Bloating", "Headache", "Fatigue", "Acne"]
      : ["Headache", "Acne", "Backache", "Nausea", "Insomnia"];
    
    List<String> selected = [];
    if (random.nextDouble() < 0.4) {
      // 40% chance of having symptoms
      int count = random.nextInt(3) + 1; // 1 to 3 symptoms
      for (int i = 0; i < count; i++) {
        String symptom = potentialSymptoms[random.nextInt(potentialSymptoms.length)];
        if (!selected.contains(symptom)) {
          selected.add(symptom);
        }
      }
    }
    return selected;
  }

  // Helper method to get log for a specific date
  static DailyLog? getLogForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _logs[normalizedDate];
  }

  // Get fertility status for a date (Mock logic)
  static FertilityStatus getFertilityStatus(DateTime date) {
    final daysSinceLastPeriod = date.difference(currentUser.lastPeriodDate).inDays;
    // Normalize to positive cycle day
    int cycleDay = daysSinceLastPeriod % currentUser.cycleLength;
    if (cycleDay < 0) cycleDay += currentUser.cycleLength;

    // Ovulation typically around day 14 of 28 day cycle
    // High fertility window: 10-15
    if (cycleDay >= 13 && cycleDay <= 15) {
      return FertilityStatus.ovulation;
    } else if (cycleDay >= 10 && cycleDay <= 16) {
      return FertilityStatus.high;
    } else if (cycleDay >= 7 && cycleDay <= 19) {
      return FertilityStatus.medium;
    } else {
      return FertilityStatus.low;
    }
  }
}
