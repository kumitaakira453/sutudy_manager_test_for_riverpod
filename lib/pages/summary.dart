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
    final List<Map> weeklyRecordList = List.generate(
      7,
      (index) => {
        'id': index,
        'date': DateTime.now(),
      },
    ).toList();

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
      debugPrint(recordObj.content);

      for (var i = 0; i < 7; i++) {
        debugPrint(recordObj.date);
        debugPrint(weeklyRecordList[i]['date']);
        if (recordObj.date == weeklyRecordList[i]['date']) {
          debugPrint(recordObj.content);
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
          ...List.generate(
            7,
            (index) => Text(
              tableDateFormatter.format(weeklyRecordList[index]['date']),
            ),
          ),
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
        Padding(
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
        Padding(
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
          SizedBox(
            height: 400,
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
