import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'pages/record_register.dart';
import 'pages/subject_register.dart';
import 'pages/summary.dart';

final Logger logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SummaryPage(),
        '/subject_register': (context) => const SubjectRegisterPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/record_register') {
          final args = settings.arguments as RecordRegisterArguments;
          return MaterialPageRoute(
            builder: (context) {
              return RecordRegisterPage(
                addRecord: args.addRecord,
                subjectList: args.subjectList,
              );
            },
            // settings: settings,
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return const SummaryPage();
            },
          );
        }
      },
    );
  }
}
