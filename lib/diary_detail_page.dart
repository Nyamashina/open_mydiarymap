import 'package:flutter/material.dart';
import 'diary_entry.dart'; 
import 'dart:io';
import 'diary_edit_page.dart';

class DiaryDetailPage extends StatelessWidget {
  final DiaryEntry diaryEntry;

  const DiaryDetailPage({Key? key, required this.diaryEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記詳細(編集する場合は右のボタン)'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryEditPage(diaryEntry: diaryEntry),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(diaryEntry.title, style:const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(diaryEntry.date, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
            const SizedBox(height: 16.0),
            Text(diaryEntry.content, style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20.0),
            Text("緯度: ${diaryEntry.latitude}", style: const TextStyle(fontSize: 16.0)),
            Text("経度: ${diaryEntry.longitude}", style: const TextStyle(fontSize: 16.0)),
            if (diaryEntry.place != null) 
              Text('場所: ${diaryEntry.place}', style: const TextStyle(fontSize: 16.0)),
            if (diaryEntry.imagePath != null) 
              Builder(
                builder: (context) {
                  try {
                    var file = File(diaryEntry.imagePath!);
                    if (file.existsSync()) {
                      return Image.file(file, fit: BoxFit.cover);
                    } else {
                      return const Text('対象の画像は消去されています', style: TextStyle(color: Colors.red));
                    }
                  } catch (e) {
                    print('画像の読み込み中にエラーが発生しました: $e');
                    return const Text('画像を読み込めませんでした', style: TextStyle(color: Colors.red));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
