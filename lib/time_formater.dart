import 'package:flutter/material.dart';

/// Generate string based on [DateTime] object representing the date and time.
String timeToString(DateTime t) {
  String day = t.day.toString().padLeft(2, "0");
  String month = t.month.toString().padLeft(2, "0");
  String year = t.year.toString().padLeft(4, "0");

  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$day.$month.$year  $hour:$minute";
}

/// Generate string based on [DateTime] object representing the date.
String dateToString(DateTime t) {
  String day = t.day.toString().padLeft(2, "0");
  String month = t.month.toString().padLeft(2, "0");
  String year = t.year.toString().padLeft(4, "0");

  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$day.$month.$year";
}

/// Generate string based on [TimeOfDay] object representing the time.
String timeOfDayToString(TimeOfDay t) {
  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$hour:$minute";
}
