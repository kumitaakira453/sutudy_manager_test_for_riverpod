import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'models/subject.dart';

class RecordRegisterArguments {
  final void Function(Subject, String, DateTime, Duration) addRecord;
  final List<Subject> subjectList;

  RecordRegisterArguments(this.addRecord, this.subjectList);
}

class RecordRegisterPage extends StatefulWidget {
  const RecordRegisterPage({
    super.key,
    required this.addRecord,
    required this.subjectList,
  });

  final void Function(Subject, String, DateTime, Duration) addRecord;
  final List<Subject> subjectList;

  @override
  RecordRegisterPageState createState() => RecordRegisterPageState();
}

class RecordRegisterPageState extends State<RecordRegisterPage> {

  final formKey = GlobalKey<FormState>();
  final contentFormKey = GlobalKey<FormFieldState<String>>();
  final dateFormKey = GlobalKey<FormFieldState<DateTime>>();

  final hoursController = TextEditingController();
  final minutesController = TextEditingController();

  int selectedValue = 0;

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final addRecord = widget.addRecord;
    final subjectList = widget.subjectList;

    // print(addRecord);
    print(subjectList);

    List<DropdownMenuItem<int>> dropdownMenuItemList = [];
    subjectList.forEach((subjectObj) {
      dropdownMenuItemList.add(
        DropdownMenuItem(
          value: subjectObj.id,
          child: Text(subjectObj.title),
        ),
      );
    });

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
              child: DropdownButton(
                value: selectedValue,
                items: dropdownMenuItemList,
                onChanged: (int? value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
                isExpanded: true,
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
                key: dateFormKey,
                decoration: const InputDecoration(
                  labelText: '学習日',
                ),
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (DateTime? value) {},
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
                    padding:  EdgeInsets.all(4),
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
                        if (value == null || value.isEmpty || int.parse(value) > 60) {
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
            final int hours = int.tryParse(hoursController.text) ?? 0;
            final int minutes = int.tryParse(minutesController.text) ?? 0;
            final DateTime date = dateFormKey.currentState?.value ?? DateTime(0);
            final DateTime updatedDateTime = DateTime(date.year, date.month, date.day);

            addRecord(
              subjectList[selectedValue], 
              contentFormKey.currentState?.value ?? '', 
              updatedDateTime,
              Duration(hours: hours, minutes: minutes),
            );
            Navigator.of(context).pop();
          }
        },
      ),

    );
  }
}

