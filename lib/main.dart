import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'pages/record_register.dart';
import 'pages/subject_register.dart';
import 'pages/summary.dart';

void main() {
  Intl.defaultLocale = 'ja_JP';
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
      locale: const Locale('ja', 'JP'),
      supportedLocales: const [
        Locale('en', 'US'), // 英語
        Locale('ja', 'JP'), // 日本語
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
