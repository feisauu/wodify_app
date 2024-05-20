import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/exercise_set/input_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';

extension ExerciseSetRecorderStateExtensions on ExerciseSetRecorderState {
  get style => const TextStyle(fontFamily: 'Poppins');

  Widget buildHistoryTab() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'History:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              buildHistory(),
            ],
          ),
        )
    );
  }

  Widget buildHistory() {
    return Column(
      children: history.reversed.map(
            (set) => Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${DateFormat('yyyy-MM-dd | HH:mm:ss').format(set.dateTime)}",
                  style: style,
                ),
                Text(
                  "${formatDouble(set.weight)} kg | ${set.reps} ${repsOrRep(set)}",
                  style: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ),
      ).toList(),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget timerButton(BuildContext context) {
    return buildIconButton(
        icon: Icons.timer_sharp,
        color: Color(0xffcb0505),
        onPressed: () {
          tmpRestTime = restTime;
          timeController.text = '$tmpRestTime';

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(child: Text('Edit rest time', style: TextStyle(fontFamily: 'Poppins'))),
                  content: buildTimeInput(),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            tmpRestTime = restTime;
                            timeController.text = '$tmpRestTime';
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
                        ),
                        TextButton(
                          onPressed: () {
                            saveTime();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save', style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Widget settingsButton(BuildContext context) {
    return buildIconButton(
        icon: Icons.settings,
        color: Color(0xffcb0505),
        onPressed: () {
          tmpIncrement = increment;
          incrementController.text = '$tmpIncrement';

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(child: Text('Edit increment', style: TextStyle(fontFamily: 'Poppins'))),
                  content: buildIncrementInput(),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            tmpIncrement = increment;
                            incrementController.text = '$tmpIncrement';
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
                        ),
                        TextButton(
                          onPressed: () {
                            saveIncrement();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save', style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Widget buildRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildWeightInput(),
          const SizedBox(height: 16.0),
          buildRepsInput(),
          const SizedBox(height: 16.0),
          if (selectedCardIndex == -1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffcb0505),
              ),
              onPressed: saveSet,
              child: const Text('Save', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      history.remove(recordedSets1[selectedCardIndex]);
                      recordedSets1.remove(recordedSets1[selectedCardIndex]);
                      selectedCardIndex = -1;
                    });
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Set deleted', style: TextStyle(fontFamily: 'Poppins'))),
                    );
                    await saveHistory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 0, 0),
                  ),
                  child: const Text('Delete set', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 100, 0),
                  ),
                  onPressed: () async {
                    setState(() {
                      saveSetEdit();
                      selectedCardIndex = -1;
                    });
                    await saveHistory();
                  },
                  child: const Text('Save changes', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                ),
              ],
            ),
          const SizedBox(height: 16.0),
          const Text(
            'Recorded Sets:',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
          buildRecordedSets(),
        ],
      ),
    );
  }

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
            },
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
                  },
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
