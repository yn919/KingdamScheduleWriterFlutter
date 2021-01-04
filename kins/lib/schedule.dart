import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ScheduleData extends ChangeNotifier {
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  void setDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  String _time = '19-21';
  String get time => _time;
  void setTime(String value) {
    _time = value;
    notifyListeners();
  }

  String _place = 'スポセン第1';
  String get place => _place;
  void setPlace(String value) {
    _place = value;
    notifyListeners();
  }

  String getDayFormatString() {
    initializeDateFormatting('ja');
    return DateFormat('M/d(E)', 'ja').format(_date).toString();
  }
}

class ScheduleDatas extends ChangeNotifier {
  final _schedules = <ScheduleData>[];

  List<ScheduleData> get schedules => _schedules;
  int get schedulesCOunt => _schedules.length;

  ScheduleData getScheduleAtIndex(int index) {
    return _schedules[index];
  }

  void addSchedule() {
    _schedules.add(new ScheduleData());
    notifyListeners();
  }

  void copyAndInsertSchedule(ScheduleData schedule) {
    ScheduleData _copySchedule = new ScheduleData();
    _copySchedule.setDate(schedule.date);
    _copySchedule.setPlace(schedule.place);
    _copySchedule.setTime(schedule.time);

    _schedules.add(schedule);
    notifyListeners();
  }

  void removeSchedule(ScheduleData schedule) {
    if (_schedules.contains(schedule)) {
      _schedules.remove(schedule);
      notifyListeners();
    }
  }

  Future<void> copySchedulesToClipboard() async {
    if (_schedules.length <= 0) return;

    String _outText = '';
    _outText += '${_schedules[0].date.month}月の予定 \r\n';

    for (var schedule in _schedules) {
      _outText +=
          '${schedule.getDayFormatString()} ${schedule.place} ${schedule.time}\r\n';
    }

    final clipboardData = ClipboardData(text: _outText);
    await Clipboard.setData(clipboardData);
  }
}
