import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/alarm/services/file_proxy.dart';
import 'package:social_media_app/alarm/services/media_handler.dart';
import 'package:social_media_app/alarm/stores/alarm_status/alarm_status.dart';
import 'package:social_media_app/components/life_cycle_event_handler.dart';
import 'package:social_media_app/landing/landing_page.dart';
import 'package:social_media_app/screens/mainscreen.dart';
import 'package:social_media_app/services/user_service.dart';
import 'package:social_media_app/utils/config.dart';
import 'package:social_media_app/utils/constants.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/utils/global.dart';
import 'package:social_media_app/utils/providers.dart';
import 'package:volume/volume.dart';
import 'package:wakelock/wakelock.dart';

import 'alarm/alarm.dart';
import 'alarm/screens/alarm_screen/alarm_screen.dart';
import 'alarm/services/alarm_polling_worker.dart';
import 'alarm/services/life_cycle_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final alarms = await new JsonFileStorage().readList();
  list.setAlarms(alarms);
  list.alarms.forEach((alarm) {
    alarm.loadTracks();
    alarm.loadPlaylists();
  });
  WidgetsBinding.instance.addObserver(LifeCycleListener(list));

  await AndroidAlarmManager.initialize();
  AlarmPollingWorker().createPollingWorker();
  final externalPath = (await getExternalStorageDirectory());
  print(externalPath.path);
  if (!externalPath.existsSync()) externalPath.create(recursive: true);
  Volume.controlVolume(AudioManager.STREAM_MUSIC);
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AlarmStatus status = AlarmStatus();

    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  if (status.isAlarm) {
                    final id = status.alarmId;
                    final alarm = list.alarms.firstWhere(
                        (alarm) => alarm.id == id,
                        orElse: () => null);

                    MediaHandler mediaHandler = MediaHandler();

                    mediaHandler.changeVolume(alarm);
                    mediaHandler.playMusic(alarm);
                    Wakelock.enable();

                    return AlarmScreen(
                        alarm: alarm, mediaHandler: mediaHandler);
                  }
                  return TabScreen();
                } else if (status.isAlarm) {
                  final id = status.alarmId;
                  final alarm = list.alarms.firstWhere(
                      (alarm) => alarm.id == id,
                      orElse: () => null);

                  MediaHandler mediaHandler = MediaHandler();

                  mediaHandler.changeVolume(alarm);
                  mediaHandler.playMusic(alarm);
                  Wakelock.enable();

                  return AlarmScreen(alarm: alarm, mediaHandler: mediaHandler);
                }
                return Landing();
              },
            ),
          );
        },
      ),
    );
  }
}
