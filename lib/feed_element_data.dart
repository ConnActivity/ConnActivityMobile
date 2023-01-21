import 'dart:typed_data';

/// A data class that holds the data for a feed element.
class FeedElementData {
  final int id;
  final String title;
  final String description;
  final String? place;
  final DateTime? time;
  final bool? isMember;
  final Uint8List image;

  FeedElementData(
      {this.isMember,
      required this.id,
      required this.title,
      required this.description,
      required this.place,
      required this.image,
      required this.time});
}
