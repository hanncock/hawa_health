import '../mock_data.dart';

/// Maps UI selections to API IntensityEnum values.
class SymptomMapper {
  static String? flowToBleeding(FlowIntensity? flow) {
    return switch (flow) {
      FlowIntensity.light || FlowIntensity.spotting => 'LOW',
      FlowIntensity.medium => 'NORMAL',
      FlowIntensity.heavy || FlowIntensity.veryHeavy => 'HIGH',
      null => null,
    };
  }

  static String? moodToIntensity(Mood? mood) {
    return switch (mood) {
      Mood.happy || Mood.energetic || Mood.calm => 'HIGH',
      Mood.sad || Mood.anxious || Mood.tired => 'LOW',
      null => null,
    };
  }

  static String? symptomToField(String symptom) {
    const map = {
      'Cramps': 'pain',
      'Headache': 'headache',
      'Bloating': 'bloating',
      'Fatigue': 'fatigue',
      'Acne': 'acne',
    };
    return map[symptom];
  }
}
