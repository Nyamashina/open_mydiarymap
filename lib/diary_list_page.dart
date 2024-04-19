import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_diary.dart';
import 'database_helper.dart';
import 'diary_entry.dart';
import 'diary_detail_page.dart';
import 'dart:developer' as developer;

import 'global_events.dart';


class DiaryListPage extends StatefulWidget {
  @override
  _DiaryListPageState createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記リスト(長押しで削除)'),
      ),
      body: FutureBuilder<List<DiaryEntry>>(
        future: DatabaseHelper.instance.queryAllDiaryEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('エラーが発生しました'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => DiaryEntryListItem(
                diaryEntry: snapshot.data![index],
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryDetailPage(diaryEntry: snapshot.data![index]))),
                onLongPress: () => _handleDiaryDelete(context, snapshot.data![index], index),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddDiaryPage())),
      ),
    );
  }

  void _handleDiaryDelete(BuildContext context, DiaryEntry diaryEntry, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除確認'),
          content: const Text('この日記エントリーを削除してもよろしいですか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('削除'),
              onPressed: () async {
                Navigator.of(context).pop(); // ダイアログを閉じる
                try {
                  await DatabaseHelper.instance.deleteDiaryEntry(diaryEntry.id!);
                  Fluttertoast.showToast(
                    msg: "削除しました",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                  );
                  GlobalEvents.diaryDeleted();  // 削除イベントを通知
                  Navigator.popUntil(context, (route) => route.isFirst);
                } catch (e) {
                  developer.log("削除中にエラーが生じました", error: e);
                  Fluttertoast.showToast(
                    msg: "エラーが発生しました: $e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                  );
                }
              },
            ),
          ],
        );
      }
    );
  }


}


class DiaryEntryListItem extends StatelessWidget {
  final DiaryEntry diaryEntry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DiaryEntryListItem({Key? key, required this.diaryEntry, required this.onTap, required this.onLongPress,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(diaryEntry.title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5.0),
              Text(diaryEntry.date),
              const SizedBox(height: 5.0),
              Text(diaryEntry.content),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("緯度: ${diaryEntry.latitude}"),
                  const SizedBox(width: 10.0),
                  Text("経度: ${diaryEntry.longitude}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
