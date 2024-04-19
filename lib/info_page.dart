import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Here is some information about our application.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                '注意事項:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'このアプリケーションは、個人的な日記と地図情報を組み合わせたものです。\n日記の内容や地図上の位置情報は、個人のプライバシーに関わる情報を含むことがあります。\n第三者に不用意に公開しないよう注意してください。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '免責事項:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'このアプリケーションの使用を通じて生じたいかなる損害も、開発者は責任を負いません。\nアプリケーションの使用は、ユーザー自身の責任で行ってください。\nまた、アプリケーションの不具合やデータの損失に対しても、補償は行いません。',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '使い方:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'このアプリでは「Write Diary」で日記を残すことができます。\n位置情報を残すことで地図上にその場所の思い出を表すアイコンが出現します\nアイコンをタップするとタブが出て，このタブを押すと詳細ページに移動します。',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'また「Diary List」にはこれまで残した日記の一覧が表示されます。',
                style: TextStyle(fontSize: 16),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);  // この行で前のページに戻る
                  },
                  child: const Text('戻る'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
