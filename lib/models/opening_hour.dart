import 'package:flutter/material.dart';

class OpeningHour {
  final String day;
  bool closed;
  String start;
  String end;

  OpeningHour({
    @required this.day,
    @required this.closed,
    this.start,
    this.end,
  });

  factory OpeningHour.fromMap(Map data) {
    return OpeningHour(
      day: data['day'] ?? '',
      closed: data['closed'] ?? false,
      start: data['start'] ?? '',
      end: data['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'closed': closed,
        'start': start,
        'end': end,
      };
}
