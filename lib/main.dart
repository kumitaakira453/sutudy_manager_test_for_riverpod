import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/record_register.dart';
import 'pages/subject_register.dart';
import 'pages/summary.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SummaryPage(),
        '/subject_register': (context) => const SubjectRegisterPage(),
        '/record_register': (context) => const RecordRegisterPage(),
      },
    );
  }
}
