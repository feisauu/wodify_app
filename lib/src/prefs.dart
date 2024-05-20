import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<BodyPart>> getBodyPartsList() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var bodyPartListHelp = prefs.getString('body_parts') ?? "";
  List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
  return bodyPartList;
}

Future<BodyPart> getBodyPart(String name) async
{
  List<BodyPart> bodyPartList = await getBodyPartsList();
  BodyPart bodyPart = bodyPartList.firstWhere((element) => element.name == name);
  return bodyPart;
}

// Future<List<ExerciseSet>> getExercisesList(String name) async
// {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var historyHelp = prefs.getString(name) ?? "";
//   return historyHelp.isNotEmpty ? ExerciseSet.decode(historyHelp) : [];
// }