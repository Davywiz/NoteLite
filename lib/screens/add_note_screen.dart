import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notes.dart';
import '../widgets/back_button.dart';
import '../providers/notes_provider.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  var _isImportant = false;
  String _noteTitle;
  var _isInit = true;
  var _editedNote = Notes(
    id: null,
    title: '',
    content: '',
    date: null,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final noteId = ModalRoute.of(context).settings.arguments as String;
      if (noteId != null) {
        final _loadedNote =
            Provider.of<NoteProvider>(context, listen: false).findById(noteId);
        _editedNote = _loadedNote;
        _titleController.text = _editedNote.title;
        _contentController.text = _editedNote.content;
        _isImportant = _editedNote.isImportant;
      }
    }
    _isInit = false;
  }

  void _saveNote() {
    if (_editedNote.id != null) {
      if (_contentController.text.isEmpty) {
        return;
      }
      _noteTitle = _titleController.text;
      var editNote = Notes(
        id: _editedNote.id,
        date: DateTime.now(),
        title: _noteTitle.isEmpty ? _noteTitle = 'Untitled Note' : _noteTitle,
        content: _contentController.text,
        isImportant: _isImportant,
      );
      Provider.of<NoteProvider>(context, listen: false)
          .updateNote(_editedNote.id, editNote);
      Navigator.of(context).pop();
    } else {
      if (_contentController.text.isEmpty) {
        return Navigator.of(context).pop(true);
      }
      _noteTitle = _titleController.text;
      var newNote = Notes(
        id: DateTime.now().toString(),
        date: DateTime.now(),
        title: _noteTitle.isEmpty ? _noteTitle = 'Untitled Note' : _noteTitle,
        content: _contentController.text,
        isImportant: _isImportant,
      );
      Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentFocusNode.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      leading: CancelBackButton(),
      actions: <Widget>[
        IconButton(
          iconSize: Theme.of(context).iconTheme.size,
          tooltip: 'Mark note as important',
          icon: _isImportant
              ? Icon(
                  Icons.flag,
                  color: Theme.of(context).accentColor,
                )
              : Icon(Icons.outlined_flag),
          onPressed: () {
            setState(() {
              _isImportant = !_isImportant;
            });
          },
        ),
        IconButton(
          iconSize: Theme.of(context).iconTheme.size,
          tooltip: 'Save',
          icon: Icon(Icons.check),
          onPressed: _saveNote,
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Container(
          height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top),
          margin: const EdgeInsets.all(5),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                height: 35,
                child: TextField(
                  controller: _titleController,
                  autofocus: true,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Enter Title',
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  focusNode: _contentFocusNode,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  cursorColor: Colors.green,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Type Note...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
