import 'package:flutter/material.dart';
import 'package:social_media_app/alarm/components/default_container/default_container.dart';
import 'package:social_media_app/alarm/screens/edit_alarm/components/edit_alarm_time.dart';
import 'package:social_media_app/alarm/services/alarm_list_manager.dart';
import 'package:social_media_app/alarm/services/alarm_scheduler.dart';
import 'package:social_media_app/alarm/stores/observable_alarm/observable_alarm.dart';

import 'components/edit_alarm_days.dart';
import 'components/edit_alarm_head.dart';
import 'components/edit_alarm_music.dart';
import 'components/edit_alarm_slider.dart';

class EditAlarm extends StatelessWidget {
  final ObservableAlarm alarm;
  final AlarmListManager manager;

  EditAlarm({this.alarm, this.manager});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('$alarm');
        await manager.saveAlarm(alarm);
        await AlarmScheduler().scheduleAlarm(alarm);
        return true;
      },
      child: DefaultContainer(
        child: SingleChildScrollView(
          child: Column(children: [
            Text(
              'Alarm',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    EditAlarmHead(alarm: this.alarm),
                    Divider(),
                    EditAlarmTime(alarm: this.alarm),
                    Divider(),
                    EditAlarmDays(alarm: this.alarm),
                    Divider(),
                    EditAlarmMusic(alarm: this.alarm),
                    Divider(),
                    EditAlarmSlider(alarm: this.alarm),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
