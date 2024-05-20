import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../exercise_set/exercise_set_model.dart';

class LineTitles {
  List<ExerciseSet> history = [];
  bool bigDiff = false;

  LineTitles({required this.history}) {
    double min = double.maxFinite, max = -double.maxFinite;
    for(ExerciseSet set in history)
    {
      if(set.weight < min) min = set.weight;
      if(set.weight > max) max = set.weight;
    }
    if(max - min > 100) bigDiff = true;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    int index = value.toInt();
    Widget text;

    if(history.length <= 4 || (index % (history.length / 4 + 1).toInt()) == 0) {
      text = Text(
        DateFormat('yyyy-MM-dd\nHH:mm:ss').format(history[index].dateTime), 
        style: style,
        textAlign: TextAlign.center,
      );
    }
    else {
      text = const Text("");
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget sideTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    int intVal = value.toInt();
    Widget text;

    if(!bigDiff || intVal % 25 == 0) {
      text = Text('$intVal', style: style);
    }
    else {
      text = const Text("");
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  getTitleData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false, // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          interval: 5,
          getTitlesWidget: sideTitleWidgets,
          reservedSize: 62
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Text(
          'Date and time',
          textAlign: TextAlign.left,
        ),
        axisNameSize: 38,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 52,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        axisNameWidget: const Text(
          'Weight (kg)',
          textAlign: TextAlign.left,
        ),
        axisNameSize: 0,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 5,
          getTitlesWidget: sideTitleWidgets,
          reservedSize: 42,
        ),
      ),
    );
  }
}