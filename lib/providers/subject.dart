import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datas/initial_data.dart';
import '../models/subject.dart';

class SubjectsNotifier extends StateNotifier<List<Subject>> {
  SubjectsNotifier() : super(initialState);
  // 初期値
  static List<Subject> initialState = initialSubjects;
  void add(Subject subject) {
    state = [...state, subject];
  }

  void remove(int id) {
    // whereが返すのはiterableだがリストではなく遅延実行されるシーケンスのためリストにする必要がある
    state = state.where((item) => item.id != id).toList();
  }
}

final subjectsNotifierProvider =
    StateNotifierProvider<SubjectsNotifier, List<Subject>>(
  (ref) => SubjectsNotifier(),
);
