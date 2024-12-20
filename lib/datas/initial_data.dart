import '../models/record.dart';
import '../models/subject.dart';

List<Subject> initialSubjects = [
  Subject(id: 0, title: '数学'),
  Subject(id: 1, title: '英語'),
  Subject(id: 2, title: '理科'),
  Subject(id: 3, title: '社会'),
  Subject(id: 4, title: '音楽'),
];

// Record テストデータ
List<Record> initialRecords = [
  Record(
    id: 1,
    subject: initialSubjects[0], // 数学
    content: '一次方程式の練習問題を解いた',
    date: DateTime(2024, 11, 28),
    time: const Duration(hours: 1, minutes: 30),
  ),
  Record(
    id: 2,
    subject: initialSubjects[1], // 英語
    content: '英単語を30個覚えた',
    date: DateTime(2024, 11, 27),
    time: const Duration(hours: 0, minutes: 45),
  ),
  Record(
    id: 3,
    subject: initialSubjects[2], // 理科
    content: '化学反応式の復習をした',
    date: DateTime(2024, 11, 26),
    time: const Duration(hours: 2),
  ),
  Record(
    id: 4,
    subject: initialSubjects[3], // 社会
    content: '歴史の年表を暗記した',
    date: DateTime(2024, 11, 25),
    time: const Duration(hours: 1, minutes: 15),
  ),
  Record(
    id: 5,
    subject: initialSubjects[4], // 音楽
    content: 'ピアノの練習をした',
    date: DateTime(2024, 11, 24),
    time: const Duration(hours: 1),
  ),
];
