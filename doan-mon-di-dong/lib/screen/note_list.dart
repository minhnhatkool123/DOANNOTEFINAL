import 'dart:convert';
import 'package:doannote/screen/note_serach.dart';
import 'file:///D:/CodeAndroid/testthongbaodoan/doan-mon-di-dong/lib/utilities/notification_app.dart';
import 'package:image/image.dart' as ImageProcess;
import 'dart:io';
import 'dart:typed_data';

import 'package:doannote/database/databaseapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:doannote/entities/note.dart';
import 'package:doannote/screen/note_detail.dart';
import 'dart:async';

import '../utilities/color_pick.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Databaseapp databaseapp = Databaseapp();
  List<Note> noteList;
  Uint8List test;
  //int itemCount;
  @override
  Widget build(BuildContext context) {
    if (this.noteList == null) {
      this.noteList = new List<Note>();
      getAllNote();
      print('hello test');
    }

    Widget myAppBar() {
      return AppBar(
        title: Text(
          'App Note',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: noteList.length == 0
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () async {
                  final Note result = await showSearch(
                      context: context, delegate: NoteSearch(notes: noteList));
                  if (result != null) moveToNodeDetail(result);
                },
              ),
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: this.noteList.length == 0
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Click on the add button to add a new note!',
                      style: TextStyle(
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                color: Colors.white,
                child: getNotesList(),
              ),
        // child: Container(
        //   child: getNotesList(),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print('ham on tap');
          moveToNodeDetail(Note('', '', '', 0, -1, -1, -1, -1, -1, -1, ''));
        },
        child: Icon(
          Icons.add,
          color: Colors.black87,
        ),
        tooltip: 'Add Note',
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black87,
            width: 2.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      //padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: this.noteList.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          moveToNodeDetail(this.noteList[index]);
        },
        onLongPress: () {
          _showDialog(this.noteList[index].id);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            //padding: EdgeInsets.all(8),
            //color: Colors.green,
            decoration: BoxDecoration(
              color: colors[this.noteList[index].color],
              border: Border.all(width: 2.0, color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (this.noteList[index].pathimage != '')
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    child: Image.memory(
                      Base64Decoder().convert(this.noteList[index].pathimage),
                      //'https://gamek.mediacdn.vn/thumb_w/690/2019/7/8/1-15625474669018688730.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          noteList[index].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //),
                Container(
                  color: Colors.black,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          this.noteList[index].description,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, //MainAxisAlignment.end,
                    children: [
                      noteList[index].thongbao == -1
                          ? SizedBox(width: 0, height: 0)
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                              child: Icon(Icons.notifications,
                                  color: Colors.black, size: 14),
                            ),
                      Text(
                        this.noteList[index].date,
                        style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            // child: new Center(
            //   child: new CircleAvatar(
            //     backgroundColor: Colors.white,
            //     child: Text('$index'),
            //   ),
            // ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void moveToNodeDetail(Note note) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetail(note)));
    print("EXITTT");
    getAllNote();
    setNotification();
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
            "Delete Note?",
            style: TextStyle(color: Colors.black),
          ),
          content: new Text(
            "Are you sure you want to delete this note",
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
                delete(id);
              },
            ),
          ],
        );
      },
    );
  }

  void delete(int id) async {
    await databaseapp.deleteNote(id);
    getAllNote();
  }

  void getAllNote() async {
    List<Note> notelist = await databaseapp.getNoteList();
    //await databaseapp.database;
    setState(() {
      this.noteList = notelist;
    });
  }

  void setNotification() async {
    List<Note> notelist = await databaseapp.getNoteList();
    for (int i = 0; i < notelist.length; i++) {
      if (notelist[i].thongbao == 1)
        await notificationApp.showNotification(notelist[i]);
    }
  }
}
