import 'dart:io' as fromIO;
import 'file:///D:/CodeAndroid/testthongbaodoan/doan-mon-di-dong/lib/utilities/notification_app.dart';
import 'package:doannote/screen/reminder_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:doannote/database/databaseapp.dart';
import 'package:doannote/entities/note.dart';
import 'file:///D:/CodeAndroid/testthongbaodoan/doan-mon-di-dong/lib/utilities/color_pick.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;

class NoteDetail extends StatefulWidget {
  final Note note;
  NoteDetail(this.note);
  @override
  _NoteDetailState createState() => _NoteDetailState(this.note);
}

class _NoteDetailState extends State<NoteDetail> {
  Databaseapp databaseapp = Databaseapp();
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;
  String pathImage;
  FToast fToast;

  bool isEdited = false;
  fromIO.File imageFile;
  DateTime dateTime; //= DateTime.now();
  _NoteDetailState(this.note);

  int count = 0;

  @override
  void initState() {
    super.initState();
    notificationApp.setListenerForLowerVersion(onNotificationInLowerVersions);
    notificationApp.setOnNotificationClick(onNotificationClick);
    showNotificationCount();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    pathImage = note.pathimage;
    if (note.id != null) {
      dateTime = DateTime(2000, 2, 2);
    } else
      dateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[color],
        //bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Note',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        //backgroundColor: colors[color],
        leading: IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
          ),
          onPressed: () => {
            note.id == null ? _showDialog(note.id) : Navigator.pop(context),
          },
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.done,
              color: Colors.black,
            ),
            onPressed: () {
              (titleController.text.length == 0 &&
                      descriptionController.text.length == 0)
                  ? showToastError()
                  : _save();
            },
          ),
          if (note.id != null)
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                _showDialog(note.id);
              },
            ),
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Setting'),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_alert,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Reminder'),
                    ),
                  ],
                ),
              )
            ],
            initialValue: 0,
            onCanceled: () {},
            onSelected: (value) {
              if (value == 1)
                _showOptionsImageAndColors(context);
              else
                //showReminder(color);
                moveToReminder(color);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        color: colors[color],
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // if (imageFile == null)
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 0,
              //     color: Colors.white,
              //   )
              if (pathImage != '')
                Container(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                  child: Image.memory(
                    Base64Decoder().convert(pathImage),

                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    //fit: BoxFit.contain,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: TextField(
                  controller: titleController,
                  //maxLength: 255,
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 18,
                  maxLength: 800,
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 18),
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type not here...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  void _save() async {
    Navigator.pop(context);
    if (pathImage == '')
      note.pathimage = '';
    else {
      note.pathimage = pathImage; //base64Image;
    }

    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != null)
      await databaseapp.updateNote(note);
    else
      await databaseapp.insertNote(note);
  }

  void _showPhotoLibrary() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = fromIO.File(pickedFile.path);
        pathImage = base64Encode(ImageProcess.encodeJpg(
            ImageProcess.decodeImage(
              imageFile.readAsBytesSync(),
            ),
            quality: 10));
      });
      note.pathimage = pathImage;
    }
  }

  void _showOptionsImageAndColors(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 140,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ColorPick(
                      selectedIndex: note.color,
                      onTap: (index) {
                        setState(() {
                          color = index;
                          print('an nut chuyen mau');
                        });
                        note.color = index;
                        print(color.toString());
                      },
                    ),
                    ListTile(
                        onTap: () {
                          _showPhotoLibrary();
                        },
                        leading: Icon(Icons.photo_library),
                        title: Text("Choose from photo library"))
                  ]));
        });
  }

  void moveToReminder(int color) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReminderApp(note: note)));
  }

  void showNotificationCount() async {
    count = await notificationApp.getPendingNotificationCount();
    print('KKK ' + '$count');
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {}

  void delete(int id) async {
    await databaseapp.deleteNote(id);
    Navigator.pop(context);
  }

  void _showDialog(int id) {
    // flutter defined function
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: new Text(
            note.id != null ? "Delete Note?" : "Exit Note",
            style: TextStyle(color: Colors.black),
          ),
          content: new Text(
            note.id != null
                ? "Are you sure you want to delete this note?"
                : "Are you sure want to exit?",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (note.id != null)
                  delete(id);
                else
                  Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showToastError() {
    fToast.removeCustomToast();
    _showToast();
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey[400],
      ),
      child: Text(
        "Title or description can not empty",
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
