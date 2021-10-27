import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/notes_provider.dart';
import '../screens/note_details.dart';

class NotesList extends StatelessWidget {
  final bool _showOnlyImportant;
  NotesList(
    this._showOnlyImportant,
  );

  Future<void> _enterNote(BuildContext context, id) async {
    final result = await Navigator.of(context).pushNamed(
      NotesDetailScreen.routeName,
      arguments: id,
    );
    Scaffold.of(context).removeCurrentSnackBar();
    if (result != null && result == true) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Note Deleted',
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<NoteProvider>(context);
    final notes = _showOnlyImportant ? noteData.importantItems : noteData.items;
    return notes.isEmpty
        ? _showOnlyImportant
            ? Center(child: const Text('No Important Notes'))
            : Center(child: const Text('No Notes'))
        : Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(10),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (ctx, i) => Card(
                        margin: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () => _enterNote(context, notes[i].id),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${notes[i].title.trim().length <= 20 ? notes[i].title.trim() : notes[i].title.trim().substring(0, 20) + '...'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PlayfairDisplay',
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${notes[i].content.trim().split('\n').first.length <= 30 ? notes[i].content.trim().split('\n').first : notes[i].content.trim().split('\n').first.substring(0, 30) + '...'}',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      DateFormat.yMd()
                                          .add_jm()
                                          .format(notes[i].date),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    notes[i].isImportant
                                        ? Icon(Icons.flag,
                                            color:
                                                Theme.of(context).accentColor)
                                        : Icon(
                                            Icons.outlined_flag,
                                            color: Colors.blueGrey,
                                          )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
