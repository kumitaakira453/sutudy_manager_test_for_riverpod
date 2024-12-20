import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subject.dart';
import '../providers/subject.dart';

class SubjectRegisterPage extends ConsumerStatefulWidget {
  const SubjectRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubjectRegisterPageState();
}

class _SubjectRegisterPageState extends ConsumerState<SubjectRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final titleFormKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    void addSubject(String title) {
      final id = ref.watch(subjectsNotifierProvider).length;
      ref.watch(subjectsNotifierProvider).add(Subject(id: id, title: title));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SubjectRegisterPage'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                key: titleFormKey,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '科目名',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '科目名を入力してください。';
                  } else if (value.length > 20) {
                    return '科目名は20文字以内で入力してください。';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            addSubject(titleFormKey.currentState?.value ?? '');
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
