import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class BodyPart {
  String name;
  List<Exercise> exercises;

  BodyPart({required this.name, required this.exercises});

  factory BodyPart.fromJson(Map<String, dynamic> jsonData) {
    return BodyPart(
      name: jsonData['name'],
      exercises: Exercise.decode(jsonData['exercises']),
    );
  }

  static Map<String, dynamic> toMap(BodyPart bodyPart) => {
    'name': bodyPart.name,
    'exercises': Exercise.encode(bodyPart.exercises),

  };

  static String encode(List<BodyPart> bodyParts) => json.encode(
    bodyParts
        .map<Map<String, dynamic>>((bodyPart) => toMap(bodyPart))
        .toList(),
  );

  static List<BodyPart> decode(String bodyParts) =>
      (json.decode(bodyParts) as List<dynamic>)
          .map<BodyPart>((item) => BodyPart.fromJson(item))
          .toList();
}

class Exercise {
  String name;

  Exercise({required this.name});

  factory Exercise.fromJson(Map<String, dynamic> jsonData) {
    return Exercise(
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Exercise exercise) => {
    'name': exercise.name,
  };

  static String encode(List<Exercise> exercises) => json.encode(
    exercises
        .map<Map<String, dynamic>>((exercise) => toMap(exercise))
        .toList(),
  );

  static List<Exercise> decode(String exercises) =>
      (json.decode(exercises) as List<dynamic>)
          .map<Exercise>((item) => Exercise.fromJson(item))
          .toList();
}

int elapsedRestTimeGlobal = 0;
Timer? timerGlobal;

List<BodyPart> bodyParts = [
  BodyPart(
    name: 'Chest',
    exercises: [
      Exercise(name: 'Dumbbell Bench Press'),
      Exercise(name: 'Barbell Bench Press'),
      Exercise(name: 'Incline Dumbbell Press'),
      Exercise(name: 'Decline Bench Press'),
      Exercise(name: 'Chest Flyes'),
      Exercise(name: 'Push-ups'),
      Exercise(name: 'Cable Crossover'),
      Exercise(name: 'Dumbbell Pullover'),
      Exercise(name: 'Machine Chest Press'),
      Exercise(name: 'Dumbbell Squeeze Press'),
    ],
  ),
  BodyPart(
    name: 'Back',
    exercises: [
      Exercise(name: 'Deadlift'),
      Exercise(name: 'Pull-ups'),
      Exercise(name: 'Bent Over Rows'),
      Exercise(name: 'T-Bar Rows'),
      Exercise(name: 'Lat Pulldowns'),
      Exercise(name: 'Seated Cable Rows'),
      Exercise(name: 'Chin-ups'),
      Exercise(name: 'Dumbbell Rows'),
      Exercise(name: 'Hyperextensions'),
      Exercise(name: 'Good Mornings'),
    ],
  ),
  BodyPart(
    name: 'Legs',
    exercises: [
      Exercise(name: 'Squats'),
      Exercise(name: 'Leg Press'),
      Exercise(name: 'Deadlifts'),
      Exercise(name: 'Lunges'),
      Exercise(name: 'Leg Curls'),
      Exercise(name: 'Leg Extensions'),
      Exercise(name: 'Calf Raises'),
      Exercise(name: 'Hack Squats'),
      Exercise(name: 'Step Ups'),
      Exercise(name: 'Glute Ham Raises'),
    ],
  ),
  BodyPart(
    name: 'Shoulders',
    exercises: [
      Exercise(name: 'Military Press'),
      Exercise(name: 'Dumbbell Shoulder Press'),
      Exercise(name: 'Front Raises'),
      Exercise(name: 'Lateral Raises'),
      Exercise(name: 'Upright Rows'),
      Exercise(name: 'Face Pulls'),
      Exercise(name: 'Shrugs'),
      Exercise(name: 'Arnold Press'),
      Exercise(name: 'Reverse Flyes'),
      Exercise(name: 'Dumbbell Shrugs'),
    ],
  ),
  BodyPart(
    name: 'Biceps',
    exercises: [
      Exercise(name: 'Barbell Curl'),
      Exercise(name: 'Dumbbell Curl'),
      Exercise(name: 'Preacher Curl'),
      Exercise(name: 'Hammer Curl'),
      Exercise(name: 'EZ Bar Curl'),
      Exercise(name: 'Incline Dumbbell Curl'),
      Exercise(name: 'Concentration Curl'),
      Exercise(name: 'Spider Curl'),
      Exercise(name: 'Reverse Curl'),
      Exercise(name: 'Machine Curl'),
    ],
  ),
  BodyPart(
    name: 'Triceps',
    exercises: [
      Exercise(name: 'Close Grip Bench Press'),
      Exercise(name: 'Tricep Dips'),
      Exercise(name: 'Skull Crushers'),
      Exercise(name: 'Tricep Pushdowns'),
      Exercise(name: 'Overhead Tricep Extension'),
      Exercise(name: 'Tricep Kickbacks'),
      Exercise(name: 'Diamond Push-ups'),
      Exercise(name: 'Rope Pushdowns'),
      Exercise(name: 'EZ Bar Skull Crushers'),
      Exercise(name: 'Bench Dips'),
    ],
  ),
  BodyPart(
    name: 'Forearms',
    exercises: [
      Exercise(name: 'Wrist Curls'),
      Exercise(name: 'Reverse Wrist Curls'),
      Exercise(name: 'Plate Pinches'),
      Exercise(name: 'Farmer\'s Walk'),
      Exercise(name: 'Hammer Curls'),
      Exercise(name: 'Gripper Training'),
      Exercise(name: 'Forearm Plank'),
      Exercise(name: 'Behind-the-Back Wrist Curls'),
      Exercise(name: 'Towel Hangs'),
      Exercise(name: 'Reverse Curls'),
    ],
  ),
  BodyPart(
    name: 'Abs',
    exercises: [
      Exercise(name: 'Crunches'),
      Exercise(name: 'Planks'),
      Exercise(name: 'Leg Raises'),
      Exercise(name: 'Russian Twists'),
      Exercise(name: 'Mountain Climbers'),
      Exercise(name: 'Sit-ups'),
      Exercise(name: 'Bicycle Crunches'),
      Exercise(name: 'Hanging Leg Raises'),
      Exercise(name: 'Flutter Kicks'),
      Exercise(name: 'Wood Choppers'),
    ],
  ),
];







