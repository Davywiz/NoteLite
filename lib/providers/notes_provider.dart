import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/notes.dart';

class NoteProvider with ChangeNotifier {
  List<Notes> _items = [
    // Notes(
    //   id: 'n1',
    //   title: 'Test',
    //   content: 'This is a test, to know if it works',
    //   date: DateTime.now(),
    // ),
    // Notes(
    //   id: 'n2',
    //   title: 'Test 2',
    //   content: 'This is a test, to know if it works',
    //   date: DateTime.now(),
    // ),
    // Notes(
    //   id: 'n3',
    //   title: 'Test 3',
    //   content: 'This is a test, to know if it works',
    //   date: DateTime.now(),
    // )
  ];
  String _searchValue;

  void search(String val) {
    _searchValue = val;
    notifyListeners();
  }

  List<Notes> get items {
    if (_searchValue != null) {
      return [
        ..._items
            .where((note) =>
                note.title.toLowerCase().contains(_searchValue.toLowerCase()) ||
                note.content.toLowerCase().contains(_searchValue.toLowerCase()))
            .toList()
              ..sort((a, b) => b.date.compareTo(a.date))
      ];
    }
    return [..._items..sort((a, b) => b.date.compareTo(a.date))];
  }

  List<Notes> get importantItems {
    if (_searchValue != null) {
      return _items
          .where((noteItem) => noteItem.isImportant)
          .where((note) =>
              note.title.toLowerCase().contains(_searchValue.toLowerCase()) ||
              note.content.toLowerCase().contains(_searchValue.toLowerCase()))
          .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
    }

    return [
      ..._items.where((noteItem) => noteItem.isImportant).toList()
        ..sort((a, b) => b.date.compareTo(a.date))
    ];
  }

  Notes findById(String id) {
    return _items.firstWhere((note) => note.id == id, orElse: () => null);
  }

  Future<void> addNote(Notes note) async {
    Notes newNote = Notes(
      id: note.id,
      title: note.title,
      content: note.content,
      date: note.date,
      isImportant: note.isImportant,
    );
    _items.add(newNote);
    //_items.insert(0, newNote);
    notifyListeners();
    DBHelper.insert(
      'all_notes',
      {
        'id': newNote.id,
        'title': newNote.title,
        'content': newNote.content,
        'isImportant': newNote.isImportant == true ? 1 : 0,
        'date': newNote.date.toIso8601String(),
      },
    );
  }

  Future<void> fetchAndSetNotes() async {
    final dataList = await DBHelper.getData('all_notes');
    _items.addAll(dataList
        .map((item) => Notes(
              id: item['id'],
              title: item['title'],
              content: item['content'],
              isImportant: (item['isImportant'] == 1) ? true : false,
              date: DateTime.parse(item['date']),
            ))
        .toList());

    notifyListeners();
  }

  Future<void> changeIsImportant(String id) async {
    final newItem = _items.indexWhere((note) => note.id == id);
    _items[newItem].isImportant = !_items[newItem].isImportant;
    notifyListeners();
    DBHelper.update(
      'all_notes',
      {
        'title': _items[newItem].title,
        'content': _items[newItem].content,
        'isImportant': _items[newItem].isImportant == true ? 1 : 0,
        'date': _items[newItem].date.toIso8601String(),
      },
      id,
    );
  }

  Future<void> updateNote(String id, Notes newNote) async {
    final noteIndex = _items.indexWhere((note) => note.id == id);
    if (noteIndex >= 0) {
      _items[noteIndex] = newNote;
      notifyListeners();
      DBHelper.update(
        'all_notes',
        {
          'title': newNote.title,
          'content': newNote.content,
          'isImportant': newNote.isImportant == true ? 1 : 0,
          'date': newNote.date.toIso8601String(),
        },
        id,
      );
    } else {
      return;
    }
  }

  Future<void> deleteNote(String id) async {
    final _itemToDelete = _items.indexWhere((note) => note.id == id);
    _items.removeAt(_itemToDelete);
    notifyListeners();
    DBHelper.delete(
      'all_notes',
      id,
    );
  }
}
