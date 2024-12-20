import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/record.dart';
import 'models/subject.dart';
import 'record_register.dart';

class TableUpdateWidget extends StatefulWidget {
  const TableUpdateWidget({
    super.key,
    required this.recordList,
    required this.subjectList,
  });
  final List recordList;
  final List subjectList;

  // createState() メソッドを呼び出し、この後定義する _FavoriteWidgetState のインスタンスを作成して返す
  @override
  State<TableUpdateWidget> createState() => _TableUpdateWidgetState();
}

class _TableUpdateWidgetState extends State<TableUpdateWidget> {
  List<TableRow> weeklyRecordTableRowList = [];
  final tableDateFormatter = DateFormat('M/d');

  List<Map> weeklyRecordSummary(
    List recordList,
    List subjectList,
    DateTime endDate,
  ) {
    final weeklyRecordList = <Map>[
      {
        'id': 0,
        'date': DateTime.now(),
      },
      {
        'id': 1,
        'date': DateTime.now(),
      },
      {
        'id': 2,
        'date': DateTime.now(),
      },
      {
        'id': 3,
        'date': DateTime.now(),
      },
      {
        'id': 4,
        'date': DateTime.now(),
      },
      {
        'id': 5,
        'date': DateTime.now(),
      },
      {
        'id': 6,
        'date': DateTime.now(),
      },
    ];

    // subjectlistを回して、weeklyRecordListに科目の枠を追加
    // ついでに日付も入れる
    for (final subjectObj in subjectList) {
      for (var i = 0; i < 7; i++) {
        weeklyRecordList[i]['${subjectObj.title}'] = Duration.zero;
        weeklyRecordList[i]['date'] = endDate.subtract(Duration(days: 6 - i));
      }
    }

    // recordListを回してweeklyRecordListに時間を合算
    for (final recordObj in recordList) {
      print(recordObj.content);

      for (var i = 0; i < 7; i++) {
        print(recordObj.date);
        print(weeklyRecordList[i]['date']);
        if (recordObj.date == weeklyRecordList[i]['date']) {
          print(recordObj.content);
          weeklyRecordList[i]['${recordObj.subject.title}'] += recordObj.time;
        }
      }
    }
    return weeklyRecordList;
  }

  List<TableRow> createSummaryTable(List weeklyRecordList, List subjectList) {
    final tableRowList = <TableRow>[
      TableRow(
        children: [
          const Text(''),
          Text(tableDateFormatter.format(weeklyRecordList[0]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[1]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[2]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[3]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[4]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[5]['date'])),
          Text(tableDateFormatter.format(weeklyRecordList[6]['date'])),
        ],
      ),
    ];
    // まず科目で必要な行を作成
    for (final subjectObj in subjectList) {
      final contents = <Text>[
        Text('${subjectObj.title}'),
      ];
      for (var i = 0; i < 7; i++) {
        final Duration subjectDuration =
            weeklyRecordList[i]['${subjectObj.title}'];
        if (subjectDuration == Duration.zero) {
          contents.add(const Text('-'));
        } else {
          contents.add(
            Text(
              '${subjectDuration.inHours}:${subjectDuration.inMinutes % 60}',
            ),
          );
        }
      }
      tableRowList.add(
        TableRow(
          children: contents,
        ),
      );
    }

    return tableRowList;
  }

  void tableUpdate(DateTime endDate) {
    setState(() {
      weeklyRecordTableRowList = createSummaryTable(
        weeklyRecordSummary(
          widget.recordList,
          widget.subjectList,
          DateTime(endDate.year, endDate.month, endDate.day),
        ),
        widget.subjectList,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DateTimeFormField(
              lastDate: DateTime.now(),
              initialPickerDateTime: DateTime.now(),
              mode: DateTimeFieldPickerMode.date,
              onChanged: (value) {
                tableUpdate(value!);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  SummaryPageState createState() => SummaryPageState();
}

class SummaryPageState extends State {
  final List<Subject> subjectList = [];
  final List<Record> recordList = [];

  final listDateFormatter = DateFormat('yyyy/M/d');

  void addSubject(String title) {
    setState(
      () {
        subjectList.add(
          Subject(
            id: subjectList.length,
            title: title,
          ),
        );
      },
    );
  }

  void addRecord(
    Subject subject,
    String content,
    DateTime date,
    Duration time,
  ) {
    setState(
      () {
        recordList.add(
          Record(
            id: recordList.length,
            subject: subject,
            content: content,
            date: date,
            time: time,
          ),
        );
      },
    );
  }

  void toSubjectRegiterPage() {
    Navigator.of(context).pushNamed(
      '/subject_register',
      arguments: addSubject,
    );
  }

  void toRecordRegiterPage() {
    Navigator.of(context).pushNamed(
      '/record_register',
      arguments: RecordRegisterArguments(
        addRecord,
        subjectList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(subjectList);
    print(recordList);

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
          SizedBox(
            height: 200,
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
          const Padding(
            padding: EdgeInsets.all(8),
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
