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

final subjectsMaxIdProvider = Provider<int>((ref) {
  // providerの変化を検知
  final subjects = ref.watch(subjectsNotifierProvider);
  if (subjects.isEmpty) return -1;
  return subjects.map((e) => e.id).reduce((a, b) => a > b ? a : b);
});

final subjectsMinIdProvider = Provider<int>((ref) {
  final subjects = ref.watch(subjectsNotifierProvider);
  if (subjects.isEmpty) return -1;
  return subjects.map((e) => e.id).reduce((a, b) => a < b ? a : b);
});
