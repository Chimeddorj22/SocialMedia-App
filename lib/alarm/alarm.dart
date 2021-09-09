import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/alarm/screens/alarm_screen/alarm_screen.dart';
import 'package:social_media_app/alarm/screens/home_screen/home_screen.dart';
import 'package:social_media_app/alarm/services/media_handler.dart';
import 'package:social_media_app/alarm/stores/alarm_list/alarm_list.dart';
import 'package:social_media_app/alarm/stores/alarm_status/alarm_status.dart';
import 'package:volume/volume.dart';
import 'package:wakelock/wakelock.dart';

AlarmList list = AlarmList();

class Alarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ухаалаг сануулагч',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color.fromRGBO(25, 12, 38, 1),
        ),
        home: Observer(builder: (context) {
          return HomeScreen(alarms: list);
        }));
  }
}
