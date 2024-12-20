import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datas/initial_data.dart';
import '../models/record.dart';

class RecordsNotifier extends StateNotifier<List<Record>> {
  RecordsNotifier() : super(initialState);
  static List<Record> initialState = initialRecords;
  void add(Record record) {
    state = [...state, record];
  }

  void remove(int id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final recordsNotifierProvider =
    StateNotifierProvider<RecordsNotifier, List<Record>>(
  (ref) => RecordsNotifier(),
);
