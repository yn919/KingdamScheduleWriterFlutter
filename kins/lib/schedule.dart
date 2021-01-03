import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void removeSchedule(ScheduleData schedule) {
    if (_schedules.contains(schedule)) {
      _schedules.remove(schedule);
      notifyListeners();
    }
  }
}
