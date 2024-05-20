import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/add_exercise_form.dart';
import 'package:flutter_workout_tracker/src/prefs.dart';
import 'package:flutter_workout_tracker/src/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './exercise_set_recorder.dart';
import 'package:collection/collection.dart';

class ExerciseListView extends StatefulWidget {
  BodyPart bodyPart;

  ExerciseListView({super.key, required this.bodyPart});

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  void initState() {
    super.initState();
    widget.bodyPart.exercises.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    // print("rebuild");
    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    '${widget.bodyPart.name} - Exercises',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFCB0505), // Red color
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AddExerciseForm(bodyPartName: widget.bodyPart.name);
                })
                    .then((value) async {
                  BodyPart bodyPart = await getBodyPart(widget.bodyPart.name);
                  setState( () {
                    widget.bodyPart = bodyPart;
                  });
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children:
              widget.bodyPart.exercises.mapIndexed((index, element) =>
                  ListTile(
                    title: Text(widget.bodyPart.exercises[index].name),
                    // Add more details or actions as needed
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExerciseSetRecorder(exercise: widget.bodyPart.exercises[index])
                          )
                      );
                    },
                  )
              ).toList(),
            )
        ),
      ),
    );
  }
}
