import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_parts_list_view.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class AddExerciseForm extends StatefulWidget {
  AddExerciseForm({super.key, required this.bodyPartName});

  String bodyPartName;

  @override
  AddExerciseFormState createState() {
    return AddExerciseFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddExerciseFormState extends State<AddExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  String? _exerciseName;
  late int _restTime;
  late double _increment;

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _incrementController = TextEditingController();

  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _incrementFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _timeController.text = '1';
    _timeFocusNode.addListener(() {
      if (_timeFocusNode.hasFocus) {
        _timeController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _timeController.text.length,
        );
      }
    });

    _incrementController.text = '2.5';
    _incrementFocusNode.addListener(() {
      if (_incrementFocusNode.hasFocus) {
        _incrementController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _incrementController.text.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Add exercise',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      content: buildForm(context),
    );
  }

  bool exerciseExists = false;

  String? _validateExercise(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    if (exerciseExists) {
      return 'This exercise already exists for this body part';
    }

    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bodyPartListHelp = prefs.getString('body_parts') ?? "";
      List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
      BodyPart bodyPart = bodyPartList.firstWhere((element) => element.name == widget.bodyPartName);
      exerciseExists = bodyPart.exercises.indexWhere((exercise) => exercise.name == _exerciseName) == -1 ? false : true;

      if (!exerciseExists) {
        bodyPart.exercises.add(Exercise(name: _exerciseName!));
        bodyPart.exercises.sort((a, b) => a.name.compareTo(b.name));
        await prefs.setString('body_parts', BodyPart.encode(bodyPartList));
        await prefs.setInt("$_exerciseName/time", _restTime);
        await prefs.setDouble("$_exerciseName/increment", _increment);

        setState(() {
          bodyParts = bodyPartList;
        });
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_exerciseName!} added')),
        );
      } else {
        _formKey.currentState!.validate();
        exerciseExists = false;
      }
    }
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            inputFormatters: <TextInputFormatter>[
              UpperCaseTextFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: 'Exercise name',
            ),
            style: const TextStyle(fontFamily: 'Poppins'),
            validator: _validateExercise,
            onSaved: (String? value) {
              _exerciseName = value;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: _timeController,
            focusNode: _timeFocusNode,
            inputFormatters: <TextInputFormatter>[
              NumberTextFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: 'Rest time',
            ),
            style: const TextStyle(fontFamily: 'Poppins'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (String? value) {
              _restTime = int.tryParse(value!) ?? 1;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.send,
            controller: _incrementController,
            focusNode: _incrementFocusNode,
            inputFormatters: <TextInputFormatter>[
              DoubleTextFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: 'Weight increments',
            ),
            style: const TextStyle(fontFamily: 'Poppins'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (String? value) {
              _increment = double.tryParse(value!) ?? 2.5;
            },
            onFieldSubmitted: (_) {
              _submitForm();
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Operation cancelled')),
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffcb0505), // Button color red
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffcb0505), // Button color red
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Poppins', // Apply Poppins globally
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            var context;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddExerciseForm(bodyPartName: 'Chest');
              },
            );
          },
          child: const Text('Add Exercise'),
        ),
      ),
    ),
  ));
}
