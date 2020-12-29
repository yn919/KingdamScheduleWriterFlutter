import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'schedule.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '予定表',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleDatas>(
      create: (_) => ScheduleDatas(),
      child: Scaffold(
          appBar: AppBar(title: Text('予定表')),
          body: ScheduleList(),
          floatingActionButton:
              Consumer<ScheduleDatas>(builder: (_, scheduleDatas, __) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => scheduleDatas.addSchedule(),
            );
          })),
    );
  }
}

class ScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _scheduleDatas = Provider.of<ScheduleDatas>(context);
    return ListView.builder(
      itemCount: _scheduleDatas.schedules.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: _scheduleDatas.schedules[index],
        child: ScheduleTile(),
      ),
    );
  }
}

class ScheduleTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _scheduleData = Provider.of<ScheduleData>(context);
    return Card(
      child: Padding(
        child: Row(
          children: [DatePickerButton()],
        ),
        padding: EdgeInsets.all(10.0),
      ),
    );
  }
}

class DatePickerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _scheduleData = Provider.of<ScheduleData>(context);
    return RaisedButton(
      child: Row(
        children: [
          Icon(Icons.timelapse),
          Text("${_getDayFormatString(_scheduleData.date)})")
        ],
      ),
      onPressed: () => _selectDate(context, _scheduleData),
    );
  }

  Future<Null> _selectDate(
      BuildContext context, ScheduleData scheduleData) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: scheduleData.date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 360)));
    if (picked != null) {
      scheduleData.date = picked;
    }
  }

  String _getDayFormatString(DateTime date) {
    initializeDateFormatting('ja');
    return DateFormat('MM/dd(EEEE)').format(date).toString();
  }
}
