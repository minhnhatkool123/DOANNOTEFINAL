import 'package:doannote/entities/note.dart';
import 'file:///D:/CodeAndroid/testthongbaodoan/doan-mon-di-dong/lib/utilities/notification_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../utilities/color_pick.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    if (this.year > other.year)
      return true;
    else if (this.year == other.year) {
      if (this.month > other.month)
        return true;
      else if (this.month == other.month) if (this.day > other.day) return true;
      //else if (this.day == other.day) return true;
    }
    return false;
    // return this.year == other.year &&
    //     this.month == other.month &&
    //     this.day == other.day;
  }
}

class ReminderApp extends StatefulWidget {
  final Note note;
  ReminderApp({this.note});
  @override
  _ReminderAppState createState() => _ReminderAppState(this.note);
}

class _ReminderAppState extends State<ReminderApp> {
  Note note;

  _ReminderAppState(this.note);
  int checkthongbao;
  FToast fToast;
  DateTime selectedDate; // DateTime.now();
  TimeOfDay timeOfDay; //= TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    timeOfDay = TimeOfDay.now();
    fToast = FToast();
    fToast.init(context);

    checkthongbao = note.thongbao;
    print("KHOITAO");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colors[this.note.color],
        elevation: 0,
        title: Text(
          'Reminder',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: TextEditingController(
                        text: DateFormat.yMMMd().format(selectedDate),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        //icon: Icon(Icons.calendar_today),
                        labelText: 'Select Date',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        _selectTime(context);
                      },
                      controller: TextEditingController(
                        text: timeOfDay.hour.toString() +
                            ':' +
                            timeOfDay.minute.toString(),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.watch_later_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Select Time',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                width: double.infinity,
                child: RaisedButton(
                  //icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    if (checkthongbao != -1) {
                      if (note.id != null)
                        await notificationApp.cancelNotification(note.id);
                      setState(() {
                        this.checkthongbao = -1;
                      });
                      this.note.thongbao = -1;
                      return;
                    }

                    if (!showToastError()) {
                      fToast.removeCustomToast();
                      _showToast();
                      return;
                    } else {
                      // this.note.ngay == -1 &&
                      //     this.note.thang == -1 &&
                      //     this.note.nam == -1 &&
                      //     this.note.gio == -1 &&
                      //     this.note.phut == -1
                      if (checkthongbao == -1) {
                        this.note.ngay = selectedDate.day;
                        this.note.thang = selectedDate.month;
                        this.note.nam = selectedDate.year;
                        this.note.gio = timeOfDay.hour;
                        this.note.phut = timeOfDay.minute;
                        checkthongbao = this.note.thongbao = 1;

                        Navigator.pop(context);
                      } else {
                        // setState(() {
                        //   this.checkthongbao = -1;
                        // });
                        // this.note.thongbao = -1;
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        checkthongbao == -1
                            ? 'Set Time'
                            : ("Time set: " +
                                note.ngay.toString() +
                                "/" +
                                note.thang.toString() +
                                "/" +
                                note.nam.toString() +
                                "  " +
                                note.gio.toString() +
                                ":" +
                                note.phut.toString()),
                        style: TextStyle(color: Colors.black),
                      ),
                      checkthongbao == -1
                          ? SizedBox(
                              width: 0,
                              height: 0,
                            )
                          : Text(
                              "Press to clear",
                              style: TextStyle(color: Colors.black),
                            )
                    ],
                  ),

                  color: Colors.white,
                  shape: Border.all(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (t != null && t != timeOfDay) {
      setState(() {
        timeOfDay = t;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool showToastError() {
    var reSultDate = selectedDate.isSameDate(DateTime.now());
    var reSultTimeHour = timeOfDay.hour - TimeOfDay.now().hour;
    var reSultTimeMinute = timeOfDay.minute - TimeOfDay.now().minute;
    //print(reSultDate);
    if (reSultDate == true)
      return true;
    else {
      if (reSultTimeHour > 0 || (reSultTimeHour == 0 && reSultTimeMinute >= 1))
        return true;
    }
    return false;

    // if (reSultDate == false ||
    //     (reSultTimeHour == 0 && reSultTimeMinute < 1) ||
    //     reSultTimeHour < 0) {
    //   return false;
    // } else {
    //   return true;
    // }
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey[400],
      ),
      child: Text(
        "Set the time some where in the future",
        style: TextStyle(color: Colors.black),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
