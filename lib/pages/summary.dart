import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/record.dart';
import '../providers/subject.dart';

class TableUpdateWidget extends StatefulWidget {
  const TableUpdateWidget({
    super.key,
    required this.recordList,
    required this.subjectList,
  });

  final List recordList;
  final List subjectList;

  @override
  State<TableUpdateWidget> createState() => _TableUpdateWidgetState();
}

class _TableUpdateWidgetState extends State<TableUpdateWidget> {
  List<TableRow> weeklyRecordTableRowList = [];
  final tableDateFormatter = DateFormat('M/d');

  @override
  void initState() {
    super.initState();
    tableUpdate(DateTime.now());
  }

  List<Map> _generateWeeklyRecordSummary(
    List recordList,
    List subjectList,
    DateTime endDate,
  ) {
    /*
      endDateがDateTime(2024,11,28)で、それぞれのデータが`datas/initial_data.dart`の場合以下のようなリストを生成する。
      [
        {"id": 0, "date": "2024-11-22", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 1, "date": "2024-11-23", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 2, "date": "2024-11-24", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "1:00:00"},
        {"id": 3, "date": "2024-11-25", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "1:15:00", "音楽": "0:00:00"},
        {"id": 4, "date": "2024-11-26", "数学": "0:00:00", "英語": "0:00:00", "理科": "2:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 5, "date": "2024-11-27", "数学": "0:00:00", "英語": "0:45:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 6, "date": "2024-11-28", "数学": "1:30:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"}
      ]
     */
    final weeklyRecordList = List<Map>.generate(
      7,
      (index) => {
        'id': index,
        'date': endDate.subtract(Duration(days: 6 - index)),
      },
    );
    /*
      上記実行後
      [
        {"id": 0, "date": "2024-11-22"},
        {"id": 1, "date": "2024-11-23"},
        {"id": 2, "date": "2024-11-24"},
        {"id": 3, "date": "2024-11-25"},
        {"id": 4, "date": "2024-11-26"},
        {"id": 5, "date": "2024-11-27"},
        {"id": 6, "date": "2024-11-28"}
      ]
     */

    for (final subject in subjectList) {
      for (final record in weeklyRecordList) {
        record[subject.title] = Duration.zero;
      }
    }
    /* 
    上記実行後
      [
        {"id": 0, "date": "2024-11-22", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 1, "date": "2024-11-23", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 2, "date": "2024-11-24", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 3, "date": "2024-11-25", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 4, "date": "2024-11-26", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 5, "date": "2024-11-27", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"},
        {"id": 6, "date": "2024-11-28", "数学": "0:00:00", "英語": "0:00:00", "理科": "0:00:00", "社会": "0:00:00", "音楽": "0:00:00"}
      ]
     */

    for (final record in recordList) {
      for (final weeklyRecord in weeklyRecordList) {
        if (record.date == weeklyRecord['date']) {
          weeklyRecord[record.subject.title] += record.time;
        }
      }
    }

    return weeklyRecordList;
  }

  List<TableRow> _createSummaryTable(List weeklyRecordList, List subjectList) {
    final tableRowList = <TableRow>[
      // 日付の作成(一行目)
      TableRow(
        children: [
          const Text(''),
          ...weeklyRecordList.map(
            (record) => SizedBox(
              width: 200,
              child: Text(
                tableDateFormatter.format(record['date']),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ];

    for (final subject in subjectList) {
      // 二行目以降
      tableRowList.add(
        TableRow(
          children: [
            // Subject
            Text(
              subject.title,
              maxLines: 1,
            ),
            ...weeklyRecordList.map(
              (record) {
                final duration = record[subject.title] as Duration;
                return duration == Duration.zero
                    ? const Text('-')
                    : Text(
                        '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}',
                        maxLines: 1,
                      );
              },
            ),
          ],
        ),
      );
    }

    return tableRowList;
  }

  void tableUpdate(DateTime endDate) {
    setState(() {
      weeklyRecordTableRowList = _createSummaryTable(
        _generateWeeklyRecordSummary(
          widget.recordList,
          widget.subjectList,
          endDate,
        ),
        widget.subjectList,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 80 * 8),
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
                child: Table(
                  border: TableBorder.all(),
                  children: weeklyRecordTableRowList,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: DateTimeFormField(
            lastDate: DateTime.now(),
            initialPickerDateTime: DateTime.now(),
            mode: DateTimeFieldPickerMode.date,
            onChanged: (value) {
              if (value != null) {
                tableUpdate(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage> {
  final listDateFormatter = DateFormat('yyyy/M/d');

  void toSubjectRegiterPage() {
    Navigator.of(context).pushNamed(
      '/subject_register',
    );
  }

  void toRecordRegiterPage() {
    Navigator.of(context).pushNamed(
      '/record_register',
    );
  }

  void removeRecord(int id) {
    ref.read(recordsNotifierProvider.notifier).remove(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ID:$idのRecordを削除しました'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectList = ref.watch(subjectsNotifierProvider);
    final recordList = ref.watch(recordsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SummaryPage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TableUpdateWidget(
            recordList: recordList,
            subjectList: subjectList,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: recordList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${index + 1}  ${recordList[index].subject.title} ${recordList[index].content} ${listDateFormatter.format(recordList[index].date)} ${recordList[index].time.inHours}時間${recordList[index].time.inMinutes % 60}分',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          removeRecord(recordList[index].id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: '科目登録',
            backgroundColor: Colors.blue[200],
            onPressed: toSubjectRegiterPage,
            child: const Icon(Icons.menu_book),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            heroTag: '学習記録',
            backgroundColor: Colors.pink[200],
            onPressed: toRecordRegiterPage,
            child: const Icon(Icons.create),
          ),
        ],
      ),
    );
  }
}
