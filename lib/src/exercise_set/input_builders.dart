import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/exercise_set/other_widget_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';

extension ExerciseSetRecorderStateInputBuilders on ExerciseSetRecorderState {
  get style => const TextStyle(fontFamily: 'Poppins');

  Widget buildWeightInput() {
    return Column(
      children: [
        Text('Weight (kg):', style: style),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconButton(
              icon: Icons.remove,
              onPressed: () {
                weight -= increment;
                weightController.text = formatDouble(weight);
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 95,
              child: TextFormField(
                focusNode: weightFocusNode,
                textInputAction: TextInputAction.go,
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DoubleTextFormatterInput()],
                onChanged: (value) {
                  weight = double.tryParse(value) ?? 0.0;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                style: style,
                onFieldSubmitted: (_) {
                  repsFocusNode.requestFocus();
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                weight += increment;
                weightController.text = formatDouble(weight);
              },
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRepsInput() {
    return Column(
      children: [
        Text('Reps:', style: style),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconButton(
              icon: Icons.remove,
              onPressed: () {
                reps = reps >= 2 ? reps - 1 : reps;
                repsController.text = '$reps';
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 80.0,
              child: TextFormField(
                controller: repsController,
                focusNode: repsFocusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  reps = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                style: style,
                onFieldSubmitted: (_) {
                  selectedCardIndex == -1 ? saveSet() : saveSetEdit();
                  selectedCardIndex = -1;
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                reps += 1;
                repsController.text = '$reps';
              },
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTimeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildIconButton(
          icon: Icons.remove,
          onPressed: () {
            if (tmpRestTime - 10 > 0) {
              tmpRestTime -= 10;
              timeController.text = '$tmpRestTime';
            }
          },
          color: Colors.red,
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 80.0,
          child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.send,
              focusNode: timeFocusNode,
              controller: timeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$'))],
              onChanged: (value) {
                tmpRestTime = int.tryParse(value) ?? 1;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
              style: style,
              onFieldSubmitted: (_) {
                saveTime();
                Navigator.of(context).pop();
              }
          ),
        ),
        const SizedBox(width: 16.0),
        buildIconButton(
          icon: Icons.add,
          onPressed: () {
            tmpRestTime += 10;
            timeController.text = '$tmpRestTime';
          },
          color: Colors.green,
        ),
      ],
    );
  }

  Widget buildIncrementInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconButton(
                icon: Icons.remove,
                onPressed: () {
                  if (tmpIncrement - 0.5 > 0) {
                    tmpIncrement -= 0.5;
                    incrementController.text = '$tmpIncrement';
                  }
                },
                color: Colors.red,
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: 80.0,
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.send,
                    controller: incrementController,
                    focusNode: incrementFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$'))],
                    onChanged: (value) {
                      tmpIncrement = double.tryParse(value) ?? increment;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(),
                    ),
                    style: style,
                    onFieldSubmitted: (_) {
                      saveIncrement();
                      Navigator.of(context).pop();
                    }
                ),
              ),
              const SizedBox(width: 16.0),
              buildIconButton(
                icon: Icons.add,
                onPressed: () {
                  tmpIncrement += 0.5;
                  incrementController.text = '$tmpIncrement';
                },
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
