import 'dart:convert';

import 'package:doannote/entities/note.dart';
import 'package:flutter/material.dart';

class NoteSearch extends SearchDelegate<Note> {
  final List<Note> notes;
  List<Note> searchNotes = [];
  NoteSearch({this.notes});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  List<Note> getDataAfterSearch(List<Note> notes) {
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].title.toLowerCase().contains(query.toLowerCase()) ||
          notes[i].description.toLowerCase().contains(query.toLowerCase())) {
        searchNotes.add(notes[i]);
      }
    }
    return searchNotes;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search,
                size: 50,
                color: Colors.black,
              ),
            ),
            Text(
              'Enter a note to search.',
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
      );
    } else {
      searchNotes = [];
      getDataAfterSearch(notes);
      if (searchNotes.length == 0) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: searchNotes.length == null ? 0 : searchNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: searchNotes[index].pathimage == ''
                    ? Icon(Icons.note, color: Colors.black)
                    : Container(
                        width: 25,
                        height: 25,
                        child: Image.memory(
                          Base64Decoder().convert(searchNotes[index].pathimage),
                          width: 30,
                          height: 25,
                        ),
                      ),
                title: Text(
                  searchNotes[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  searchNotes[index].description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () => close(context, searchNotes[index]),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search,
                size: 50,
                color: Colors.black,
              ),
            ),
            Text(
              'Enter a note to search.',
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
      );
    } else {
      searchNotes = [];
      getDataAfterSearch(notes);
      if (searchNotes.length == 0) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: searchNotes.length == null ? 0 : searchNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: searchNotes[index].pathimage == ''
                    ? Icon(Icons.note, color: Colors.black)
                    : Container(
                        width: 25,
                        height: 25,
                        child: Image.memory(
                          Base64Decoder().convert(searchNotes[index].pathimage),
                          width: 30,
                          height: 25,
                        ),
                      ),
                title: Text(
                  searchNotes[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  searchNotes[index].description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () => close(context, searchNotes[index]),
              );
            },
          ),
        );
      }
    }
  }
}
