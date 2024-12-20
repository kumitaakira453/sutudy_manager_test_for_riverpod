import 'subject.dart';

class Record {
  Record({
    required this.id,
    required this.subject,
    required this.content,
    required this.date,
    required this.time,
  });

  final int id;
  final Subject subject;
  final String content;
  final DateTime date;
  final Duration time;
}
