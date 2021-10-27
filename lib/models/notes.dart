import 'package:flutter/foundation.dart';

class Notes {
  final String id;
  final String title;
  final String content;
  bool isImportant;
  final DateTime date;

  Notes({
    @required this.id,
    @required this.title,
    @required this.content,
    this.isImportant = false,
    @required this.date,
  });
}
