import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

class NumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: removeNonDigits(newValue.text),
      selection: TextSelection.collapsed(offset: removeNonDigits(newValue.text).length),
      // selection: newValue.selection,
    );
  }
}

class DoubleTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: removeNonDouble(newValue.text),
      selection: TextSelection.collapsed(offset: removeNonDouble(newValue.text).length),
      // selection: newValue.selection,
    );
  }
}

class DoubleTextFormatterInput extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: removeNonDouble(newValue.text),
      selection: TextSelection.collapsed(offset: removeNonDouble(newValue.text).length),
      // selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1)}";
}

String removeNonDigits(String value) {
  if(value.trim().isEmpty) return "";
  return value.replaceAll(RegExp(r'[^0-9]'),'');
}

String removeNonDouble(String value) {
  if(value.trim().isEmpty) return "";
  String newValue = value.replaceAll(RegExp(r'[^0-9.]'),'');

  if(newValue.endsWith('.') || newValue.endsWith('0')) return newValue;

  double v = double.tryParse(newValue) ?? 0;
  return formatDouble(v);
}

String formatDouble(double v) {
  if (v == null) return '';

  NumberFormat formatter = NumberFormat();
  // NumberFormat formatter = NumberFormat.decimalPattern('en_US');
  formatter.minimumFractionDigits = 0;
  formatter.maximumFractionDigits = 3;
  return formatter.format(v);
}

double nearestMultiply(double v, bool higher)
{
  int help = v % 5 != 0 ? v ~/ 5 : v ~/ 5 - 1;
  return higher ? help * 5 + 10 : help * 5;
}