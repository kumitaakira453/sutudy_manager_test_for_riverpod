import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record.dart';
import '../providers/record.dart';
import '../providers/subject.dart';

class RecordRegisterPage extends ConsumerStatefulWidget {
  const RecordRegisterPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecordRegisterPageState();
}

class _RecordRegisterPageState extends ConsumerState<RecordRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final contentFormKey = GlobalKey<FormFieldState<String>>();
  final dateFormKey = GlobalKey<FormFieldState<DateTime>>();
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();

  Map<String, dynamic> formValue = {};
  int selectedValue = 0;

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectList = ref.watch(subjectsNotifierProvider);

    void addRecord(Map<String, dynamic> formValue) {
      final id = ref.watch(recordsNotifierProvider).length;
      ref.read(recordsNotifierProvider.notifier).add(
            Record(
              id: id,
              subject: formValue['subject'],
              content: formValue['content'],
              date: formValue['date'],
              time: formValue['time'],
            ),
          );
    }

    final dropdownMenuItemList = <DropdownMenuItem<int>>[];
    for (final subject in subjectList) {
      dropdownMenuItemList.add(
        DropdownMenuItem(
          value: subject.id,
          child: Text(subject.title),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('RecordRegisterPage'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: DropdownButton(
                  value: selectedValue,
                  items: dropdownMenuItemList,
                  menuWidth: 140,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  isExpanded: false,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                key: contentFormKey,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '内容',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DateTimeFormField(
                initialValue: DateTime.now(),
                key: dateFormKey,
                decoration: const InputDecoration(
                  labelText: '学習日',
                ),
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: hoursController,
                      decoration: const InputDecoration(
                        labelText: '時間',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hours';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: minutesController,
                      decoration: const InputDecoration(
                        labelText: '分',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.parse(value) > 60) {
                          return 'Please enter minutes';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final hours = int.tryParse(hoursController.text) ?? 0;
            final minutes = int.tryParse(minutesController.text) ?? 0;
            formValue['subject'] = subjectList[selectedValue];
            formValue['content'] = contentFormKey.currentState?.value ?? '';
            formValue['date'] = dateFormKey.currentState?.value ?? '';
            formValue['time'] = Duration(hours: hours, minutes: minutes);
            addRecord(formValue);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
