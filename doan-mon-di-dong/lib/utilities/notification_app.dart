import 'package:doannote/entities/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class NotificationApp {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationApp._() {
    init();
  }
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersion(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('test_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });
    initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
  }

  Future<void> showNotification(Note note) async {
    final now =
        new DateTime(note.nam, note.thang, note.ngay, note.gio, note.phut);
    int giotam;
    int giodung;
    print(now);
    final realtime = new DateTime.now();
    print(realtime);
    int nam = now.year - realtime.year;
    int thang = now.month - realtime.month;
    int ngay = now.day - realtime.day;
    // if (now.hour > 12)
    //   giotam = now.hour - 12;
    // else
    //   giotam = now.hour;
    // if (realtime.hour > 12)
    //   giodung = realtime.hour - 12;
    // else
    //   giodung = realtime.hour;
    int gio = now.hour - realtime.hour; //realtime.hour;
    int phut = now.minute - realtime.minute;
    if (nam < 0) {
      return;
    } else if (nam == 0) {
      if (now.month < realtime.month)
        return;
      else if (thang == 0) {
        if (now.day < realtime.day)
          return;
        else if (ngay == 0) {
          if (gio < 0)
            return;
          else if (gio == 0) if (phut < 0) return;
        }
      }
    }
    if (ngay == 0 && thang == 0 && nam == 0 && gio == 0 && phut == 0) return;

    print("Note ID" + note.id.toString());

    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      note.id,
      note.title,
      note.description,
      now,
      platformChannelSpecifics,
      payload: 'Test PayLoad',
      androidAllowWhileIdle: true,
    );
    //flutterLocalNotificationsPlugin.schedule(id, title, body, scheduledDate, notificationDetails)
    //flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails)
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification(int id) async {
    print("CANCEL" + id.toString());
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

NotificationApp notificationApp = NotificationApp._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
