import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          floatingActionButton: Consumer<ScheduleDatas>(
              builder: (context, scheduleDatas, widget) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: FloatingActionButton(
                      child: Icon(Icons.send),
                      onPressed: () {
                        scheduleDatas.copySchedulesToClipboard();

                        Scaffold.of(context).hideCurrentSnackBar();
                        final snackbar =
                            SnackBar(content: Text('クリップボードにコピーしました'));
                        Scaffold.of(context).showSnackBar(snackbar);
                      }),
                  margin: EdgeInsets.only(left: 10, right: 10),
                ),
                Container(
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => scheduleDatas.addSchedule(),
                  ),
                  margin: EdgeInsets.only(left: 10, right: 10),
                ),
              ],
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
        child: ScheduleCard(),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DatePickerButton(),
            PlacePullDawn(),
            TimePullDawn(),
            MoreMenuButton()
          ],
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.timelapse),
          Text("${_scheduleData.getDayFormatString()}")
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
      scheduleData.setDate(picked);
    }
  }
}

class TimePullDawn extends StatelessWidget {
  final List<String> _times = [
    '9-11',
    '11-13',
    '13-15',
    '15-17',
    '17-19',
    '19-21'
  ];

  @override
  Widget build(BuildContext context) {
    final _scheduleData = Provider.of<ScheduleData>(context);
    return DropdownButton(
      items: _times.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: _scheduleData.time,
      onChanged: (String value) {
        _scheduleData.setTime(value);
      },
    );
  }
}

class PlacePullDawn extends StatelessWidget {
  final List<String> _places = [
    'スポセン第1',
    'スポセン第2',
    '上納池',
  ];

  @override
  Widget build(BuildContext context) {
    final _scheduleData = Provider.of<ScheduleData>(context);
    return DropdownButton(
      items: _places.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: _scheduleData.place,
      onChanged: (String value) {
        _scheduleData.setPlace(value);
      },
    );
  }
}

class MoreMenuButton extends StatelessWidget {
  final List<String> _menuItems = ['削除', 'コピーして挿入'];
  @override
  Widget build(BuildContext context) {
    final _scheduleData = Provider.of<ScheduleData>(context);
    return Consumer<ScheduleDatas>(builder: (_, scheduleDatas, __) {
      return PopupMenuButton(
        itemBuilder: (context) => _menuItems.map((String value) {
          return PopupMenuItem(
            child: Text(value),
            value: value,
          );
        }).toList(),
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case '削除':
              scheduleDatas.removeSchedule(_scheduleData);
              break;
            case 'コピーして挿入':
              scheduleDatas.copyAndInsertSchedule(_scheduleData);
              break;
          }
        },
      );
    });
  }
}
