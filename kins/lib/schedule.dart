import 'package:flutter/material.dart';

class ScheduleData extends ChangeNotifier {
  DateTime date = DateTime.now();
  String time = "";
  String place = "";
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
