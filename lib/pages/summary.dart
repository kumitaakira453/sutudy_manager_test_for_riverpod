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
  // テーブル表示用の行リスト
  List<TableRow> weeklyRecordTableRowList = [];
  final tableDateFormatter = DateFormat('M/d');

  /// 指定された期間の週次記録を生成
  List<Map> weeklyRecordSummary(
    List recordList,
    List subjectList,
    DateTime endDate,
  ) {
    // 初期化（各日付を生成）
    final weeklyRecordList = List<Map>.generate(
      7,
      (index) => {
        'id': index,
        'date': endDate.subtract(Duration(days: 6 - index)),
      },
    );

    // 科目の枠を追加
    for (final subjectObj in subjectList) {
      for (final record in weeklyRecordList) {
        record[subjectObj.title] = Duration.zero;
      }
    }

    // 各記録を合算
    for (final recordObj in recordList) {
      for (final record in weeklyRecordList) {
        if (recordObj.date == record['date']) {
          record[recordObj.subject.title] += recordObj.time;
        }
      }
    }

    return weeklyRecordList;
  }

  /// 週次記録リストを元にテーブルの行を作成
  List<TableRow> createSummaryTable(List weeklyRecordList, List subjectList) {
    final tableRowList = <TableRow>[
      // ヘッダー行
      TableRow(
        children: [
          const Text(''),
          ...weeklyRecordList.map(
            (record) => SizedBox(
              width: 200,
              child: Text(
                tableDateFormatter.format(record['date']),
                // maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ];

    // 各科目のデータ行
    for (final subjectObj in subjectList) {
      tableRowList.add(
        TableRow(
          children: [
            Text(
              subjectObj.title,
              maxLines: 1,
            ),
            ...weeklyRecordList.map(
              (record) {
                final duration = record[subjectObj.title] as Duration;
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

  /// テーブルを更新
  void tableUpdate(DateTime endDate) {
    setState(() {
      weeklyRecordTableRowList = createSummaryTable(
        weeklyRecordSummary(
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
        // テーブル表示
        Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 横方向スクロールを有効に

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                // minWidth: MediaQuery.of(context).size.width,
                minWidth: 80 * 8, // 幅を強制的に大きく指定
              ),
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

        // 日付選択
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
