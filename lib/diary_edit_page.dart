import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'diary_entry.dart';
import 'global_events.dart';
import 'database_helper.dart'; 

class DiaryEditPage extends StatefulWidget {
  final DiaryEntry diaryEntry;

  const DiaryEditPage({Key? key, required this.diaryEntry}) : super(key: key);

  @override
  _DiaryEditPageState createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.diaryEntry.title);
    _contentController = TextEditingController(text: widget.diaryEntry.content);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.diaryEntry.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
      DiaryEntry updatedEntry = DiaryEntry(
        id: widget.diaryEntry.id,
        title: _titleController.text,
        content: _contentController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        latitude: widget.diaryEntry.latitude,
        longitude: widget.diaryEntry.longitude,
        place: widget.diaryEntry.place,
        imagePath: widget.diaryEntry.imagePath
      );
      await DatabaseHelper.instance.updateDiaryEntry(updatedEntry);
      GlobalEvents.diaryUpdated();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記の編集'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
