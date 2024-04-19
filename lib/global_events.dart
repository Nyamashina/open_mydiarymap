// グローバルイベント通知を定義
import 'package:flutter/material.dart';

class GlobalEvents {
  static final notifier = ValueNotifier<bool>(false);

  static void diaryUpdated() {
    notifier.value = true;
  }

  static void diaryDeleted() {
    notifier.value = true; 
  }

  static void reset() {
    notifier.value = false;
  }
}
