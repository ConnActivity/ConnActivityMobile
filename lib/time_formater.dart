import 'package:flutter/material.dart';

String timeToString(DateTime t) {
  String day = t.day.toString().padLeft(2, "0");
  String month = t.month.toString().padLeft(2, "0");
  String year = t.year.toString().padLeft(4, "0");

  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$day.$month.$year  $hour:$minute";
}

String dateToString(DateTime t) {
  String day = t.day.toString().padLeft(2, "0");
  String month = t.month.toString().padLeft(2, "0");
  String year = t.year.toString().padLeft(4, "0");

  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$day.$month.$year";
}

String timeOfDayToString(TimeOfDay t) {
  String hour = t.hour.toString().padLeft(2, "0");
  String minute = t.minute.toString().padLeft(2, "0");

  return "$hour:$minute";
}
