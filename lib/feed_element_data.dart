import 'dart:typed_data';

import 'package:flutter/material.dart';

class FeedElementData {
  final int id;
  final String title;
  final String description;
  final String? place;
  final DateTime? time;
  final bool? isMemeber;
  final Uint8List image;

  FeedElementData(
      {this.isMemeber,
      required this.id,
      required this.title,
      required this.description,
      required this.place,
      required this.image,
      required this.time});
}
