import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'diary_entry.dart';
import 'lat_lng.dart';

class Diary with ChangeNotifier {
  List<DiaryEntry> _entries = [];

  Diary() {
    loadEntries();
  }

  List<DiaryEntry> get entries => [..._entries];

  Future<void> loadEntries() async {
    final dataList = await DatabaseHelper.instance.queryAllDiaryEntries();
    _entries = dataList.map((item) => DiaryEntry.fromMap(item as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  addEntry(String title, String content, LatLng location, String date, String? place, String? imagePath) async {
    final newEntry = DiaryEntry(
      title: title, 
      content: content,
      latitude: location.latitude,
      longitude: location.longitude,
      date: date,
      place: place,
      imagePath: imagePath
    );
    final id = await DatabaseHelper.instance.insertDiaryEntry(newEntry);
    
    final entryWithID = DiaryEntry(id:id, title:newEntry.title, content:newEntry.content, latitude: newEntry.latitude, longitude: newEntry.longitude, date: newEntry.date, place: newEntry.place );
    print('addEntry with ID: ${entryWithID.id}, Title: ${entryWithID.title}, Content: ${entryWithID.content}, Latitude: ${entryWithID.latitude}, Longitude: ${entryWithID.longitude}, Date: ${entryWithID.date}, Place: ${entryWithID.place}');

    loadEntries(); // エントリーリストを更新
  } 

  Future<void> deleteDiaryEntry(int id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    await db.delete(
      'diary_entries',
      where: 'id = ?', 
      whereArgs: [id],
    );
  }
}
