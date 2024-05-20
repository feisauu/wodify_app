import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'line_titles.dart';

extension ExerciseSetRecorderStateExtensions on ExerciseSetRecorderState {
  Widget buildGraphTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Weight graph:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: LineChart(mainData()),
          ),
        ],
      ),
    );
  }

    Widget buildGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [LineChart(mainData())]
    );
  }

  LineChartData mainData() {
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return LineChartData(
      minX: 0,
      maxX: history.length.toDouble() - 1,
      // minY: history == null || history.isEmpty ? 1 : max(history.reduce((curr, next) => curr.weight < next.weight ? curr : next).weight - 10, 0),
      minY: history.isEmpty ? 1 : nearestMultiply(history.reduce((curr, next) => curr.weight < next.weight ? curr : next).weight, false),
      // maxY: history == null || history.isEmpty ? 1 : max(history.reduce((curr, next) => curr.weight < next.weight ? next : curr).weight + 10, 0),
      maxY: history.isEmpty ? 1 : nearestMultiply(history.reduce((curr, next) => curr.weight < next.weight ? next : curr).weight, true),
      // titlesData: LineTitles.getTitleData(),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      titlesData: LineTitles(history: history).getTitleData(),
      lineBarsData: [
        LineChartBarData(
          spots: history.mapIndexed((index, set) => FlSpot(
              // set.dateTime.minute.toDouble(),
              index.toDouble(),
              set.weight)
          ).toList(),
          isCurved: false,
          // colors: gradientColors,
          barWidth: 5,
          // dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              color: gradientColors[0].withOpacity(0.3)
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          maxContentWidth: 100,
          tooltipBgColor: Colors.black,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors[0] ??
                    touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                '${DateFormat('yyyy-MM-dd\nHH:mm:ss').format(history[touchedSpot.x.toInt()].dateTime)},'
                '\n${formatDouble(touchedSpot.y)} kg | ${history[touchedSpot.x.toInt()].reps} ${repsOrRep(history[touchedSpot.x.toInt()])}',
                textStyle,
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        getTouchLineStart: (data, index) => 0,
      ),
    );
  }
}