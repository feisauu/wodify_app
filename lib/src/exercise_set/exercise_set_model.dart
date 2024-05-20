import 'dart:convert';

class ExerciseSet{
  // Exercise exercise;
  double weight;
  int reps;
  DateTime dateTime;

  // ExerciseSet({required this.exercise, this.weight = 0, this.reps = 0, required this.dateTime});
  ExerciseSet({this.weight = 0, this.reps = 0, required this.dateTime});

  factory ExerciseSet.fromJson(Map<String, dynamic> jsonData) {
    return ExerciseSet(
      weight: jsonData['weight'],
      reps: jsonData['reps'],
      dateTime: DateTime.parse(jsonData['dateTime']),
    );
  }

  static Map<String, dynamic> toMap(ExerciseSet set) => {
        'weight': set.weight,
        'reps': set.reps,
        'dateTime': set.dateTime.toIso8601String(),
      };
  
  static String encode(List<ExerciseSet> sets) => json.encode(
        sets
            // .map<String>((set) => json.encode(set))
            .map<Map<String, dynamic>>((set) => toMap(set))
            .toList(),
      );

  static List<ExerciseSet> decode(String sets) =>
      (json.decode(sets) as List<dynamic>)
          // .map<ExerciseSet>((item) => json.decode(item))
          .map<ExerciseSet>((item) => ExerciseSet.fromJson(item))
          .toList();
}