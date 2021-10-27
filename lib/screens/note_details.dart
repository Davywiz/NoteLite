import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/notes_provider.dart';
import '../widgets/back_button.dart';
import '../screens/add_note_screen.dart';
import '../models/notes.dart';

class NotesDetailScreen extends StatefulWidget {
  static const routeName = '/note_detail';

  @override
  _NotesDetailScreenState createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  Notes _loadedNote;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final noteId = ModalRoute.of(context).settings.arguments as String;
    final currentNote = Provider.of<NoteProvider>(context).findById(noteId);
    if (currentNote == null) {
      _loadedNote = Notes(
        id: '',
        title: '',
        content: '',
        date: DateTime.now(),
      );
    } else {
      _loadedNote = currentNote;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GoBackButton(),
        actions: <Widget>[
          Consumer<NoteProvider>(
            builder: (ctx, notes, _) => IconButton(
              iconSize: Theme.of(context).iconTheme.size,
              tooltip: 'Mark note as important',
              icon: _loadedNote.isImportant
                  ? Icon(
                      Icons.flag,
                      color: Theme.of(context).accentColor,
                    )
                  : Icon(Icons.outlined_flag),
              onPressed: () {
                notes.changeIsImportant(_loadedNote.id);
              },
            ),
          ),
          IconButton(
            iconSize: Theme.of(context).iconTheme.size,
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text('The note will be deleted.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        await Provider.of<NoteProvider>(context, listen: false)
                            .deleteNote(_loadedNote.id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            iconSize: Theme.of(context).iconTheme.size,
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddNoteScreen(),
                  settings: RouteSettings(
                    arguments: _loadedNote.id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).accentColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: SelectableText(
                  _loadedNote.title,
                  cursorColor: Colors.green,
                  autofocus: false,
                  showCursor: false,
                  toolbarOptions:
                      const ToolbarOptions(copy: true, selectAll: true),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  DateFormat.yMd().add_jm().format(_loadedNote.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _loadedNote.content,
                      cursorColor: Colors.green,
                      autofocus: false,
                      showCursor: false,
                      toolbarOptions:
                          const ToolbarOptions(copy: true, selectAll: true),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 8,
                thickness: 1,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
