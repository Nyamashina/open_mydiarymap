import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_helper.dart';
import 'diary_entry.dart';

// DiaryEntryのリストを保持する状態Notifier
class DiaryEntryListNotifier extends StateNotifier<List<DiaryEntry>> {
  DiaryEntryListNotifier() : super([]);

  // データベースから日記エントリーを読み込んで状態を更新するメソッド
  Future<void> loadEntries() async {
    final dataList = await DatabaseHelper.instance.queryAllDiaryEntries();
    state = dataList;
  }

  // 新しい日記エントリーを追加するメソッド
  Future<void> addEntry(DiaryEntry entry) async {
    final id = await DatabaseHelper.instance.insertDiaryEntry(entry);
    entry = entry.copyWith(id: id); // IDを設定
    state = [...state, entry];
  }
}

// DiaryEntryListNotifierを提供するProvider
final diaryEntryListProvider = StateNotifierProvider<DiaryEntryListNotifier, List<DiaryEntry>>((ref) {
  return DiaryEntryListNotifier();
});
