import 'package:flutter/material.dart';
import 'package:mydailymap_nanigadokode/diary_entry.dart';
//import 'package:mydailymap_nanigadokode/main.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart'; 
import 'global_events.dart';
import 'select_location_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AddDiaryPage extends StatefulWidget {
  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _place = '';
  XFile? _image;
  String? _savedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedImage = await File(pickedFile.path).copy(filePath);
      setState(() {
        _image = pickedFile;
        _savedImagePath = savedImage.path;
      });
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        DiaryEntry diaryEntry = DiaryEntry(
          title: _titleController.text,
          content: _contentController.text,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          latitude: _latitude,
          longitude: _longitude,
          place: _place,
          imagePath: _savedImagePath,
        );
        await DatabaseHelper.instance.insertDiary(diaryEntry);
        GlobalEvents.diaryUpdated();
        Navigator.pop(context, true); 
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save the entry: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新しい日記')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'タイトル'),
                  validator: (value) => value!.isEmpty ? 'タイトルを入力してください' : null,
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: '内容'),
                  validator: (value) => value!.isEmpty ? '内容を入力してください' : null,
                ),
                ListTile(
                  title: Text('日付: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                if (_image != null) Image.file(File(_image!.path)),
                ElevatedButton(onPressed: _takePicture, child: const Text('写真を撮る')),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic>? selected = await selectLocation(context);
                    setState(() {
                      _latitude = selected?['latitude'];
                      _longitude = selected?['longitude'];
                      _place = selected?['place'];
                    });
                  },
                  child: const Text('位置を選択'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _latitude >= -90.0 && _latitude <= 90.0 && _longitude >= -180.0 && _longitude <= 180.0
                    ? '選択された位置 $_place：緯度 $_latitude, 経度 $_longitude'
                    : '適切な位置情報が記入されてません'
                  ),
                ),
                ElevatedButton(onPressed: _saveEntry, child: const Text('保存')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
