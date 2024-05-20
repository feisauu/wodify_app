import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_model.dart';
import 'package:flutter_workout_tracker/src/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

extension ExerciseSetRecorderWorkerMethods on ExerciseSetRecorderState {
  get style => const TextStyle(fontFamily: 'Poppins');
  Future<void> playBeepSound() async {
    await Future.delayed(Duration(seconds: restTime));
    timerWorking = false;
    AssetSource src = AssetSource('beep.mp3');
    await audioPlayer!.play(src);
  }

  void saveSet() async{
    FocusScope.of(context).unfocus();
    if (reps > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set saved')),
      );

      playBeepSound();

      timerWorking = true;

      if(timerGlobal == null || (timerGlobal != null && !timerGlobal!.isActive))
      {
        elapsedRestTimeGlobal = restTime;
        timerGlobal = Timer.periodic(const Duration(seconds: 1), (timerGlobal) {
        if (elapsedRestTimeGlobal > 0) {
          elapsedRestTimeGlobal--;
        } else {
          timerGlobal.cancel();
        }
      });
      }

      if(timer == null || (timer != null && !timer!.isActive))
      {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (elapsedRestTime > 0) {
            setState(() {elapsedRestTime = elapsedRestTimeGlobal;});
            // setState(() {elapsedRestTime--;});
          } else {
            timer.cancel(); 
            setState(() {elapsedRestTime = restTime;});
          }
        });
      }

      ExerciseSet setInfo1 = ExerciseSet(weight: weight, reps: reps, dateTime: DateTime.now());

      // recordedSets1.add(setInfo1);
      setState(() {
        recordedSets1.add(setInfo1);
      });

    history.add(setInfo1);
    await saveHistory();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps should be more than 0!')),
      );
    }
  }

  void saveSetEdit() async{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved')),
    );
    FocusScope.of(context).unfocus();
    // selectedCardIndex = -1;
    if (reps > 0) {
      var oldSet = recordedSets1[selectedCardIndex];
      ExerciseSet setInfo1 = ExerciseSet(weight: weight, reps: reps, dateTime: oldSet.dateTime);
      int indexInHistory = history.indexWhere((element) => element == oldSet);
      // ExerciseSet setInHistory = history.firstWhere((element) => element == oldSet);
      history[indexInHistory] = setInfo1;
      recordedSets1[selectedCardIndex] = setInfo1;
      // setState(() {
      //   recordedSets1[selectedCardIndex] = setInfo1;
      // });

      await saveHistory();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps should be more than 0!')),
      );
    }
  }

  void initFocusNodes(){
    weightFocusNode.addListener(() {
      if (weightFocusNode.hasFocus) {
        weightController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: weightController.text.length,
        );
      }
    });

    repsFocusNode.addListener(() {
      if (repsFocusNode.hasFocus) {
        repsController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: repsController.text.length,
        );
      }
    });

    timeFocusNode.addListener(() {
      if (timeFocusNode.hasFocus) {
        timeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: timeController.text.length,
        );
      }
    });

    incrementFocusNode.addListener(() {
      if (incrementFocusNode.hasFocus) {
        incrementController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: incrementController.text.length,
        );
      }
    });
  }

  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var historyHelp = prefs.getString(widget.exercise.name) ?? "";
      history = historyHelp.isNotEmpty ? ExerciseSet.decode(historyHelp) : [];
      // history = await getExercisesList(widget.exercise.name);
      weight = history.isNotEmpty ? (history[history.length - 1].weight) : 0;
      reps = history.isNotEmpty ? (history[history.length - 1].reps) : 1;
      weightController.text = formatDouble(weight);
      repsController.text = '$reps';

      var savedTime = prefs.getInt("${widget.exercise.name}/time") ?? 1;
      restTime = savedTime;
      // elapsedRestTime = restTime;
      elapsedRestTime = elapsedRestTimeGlobal == 0 ? restTime : elapsedRestTimeGlobal;
      timeController.text = '$restTime';
      var savedIncrement = prefs.getDouble("${widget.exercise.name}/increment") ?? 2.5;
      increment = savedIncrement;
      incrementController.text = '$increment';
    });

    for(var set in history) {
      if(set.dateTime.day == DateTime.now().day && set.dateTime.month == DateTime.now().month && set.dateTime.year == DateTime.now().year){
        recordedSets1.add(set);
      }
    }

    if(timer == null || (timer != null && !timer!.isActive) && elapsedRestTimeGlobal != 0)
      {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (elapsedRestTime > 0) {
            // elapsedRestTime--;
            setState(() {elapsedRestTime = elapsedRestTimeGlobal;});
            // setState(() {elapsedRestTime--;});
          } else {
            timer.cancel(); 
            setState(() {elapsedRestTime = restTime;});
          }
        });
      }
  }

  Future<void> saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.exercise.name, ExerciseSet.encode(history));
  }

  Future<void> saveTime() async {
    restTime = tmpRestTime;
    elapsedRestTime = restTime;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("${widget.exercise.name}/time", restTime);
  }

  Future<void> saveIncrement() async {
    increment = tmpIncrement;
    // setState(() {
    //   increment = tmpIncrement;
    // });
  
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("${widget.exercise.name}/increment", increment);
  }

  String repsOrRep(ExerciseSet set) => set.reps >= 2 ? 'reps' : 'rep';
}