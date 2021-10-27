import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

import '../widgets/notes_list.dart';
import '../screens/settings_screen.dart';
import '../providers/notes_provider.dart';
import '../widgets/my_popup_menu.dart' as mypopup;

import '../screens/add_note_screen.dart';

enum FilterOptions {
  Important,
  All,
  Settings,
}

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  var _showOnlyImportant = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<NoteProvider>(context, listen: false)
          .fetchAndSetNotes()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _addNote(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddNoteScreen(),
      ),
    );
    scaffoldKey.currentState.removeCurrentSnackBar();
    if (result != null && result == true) {
      scaffoldKey.currentState.hideCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Empty Note is not created',
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    appBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        onChange: (String val) {
          Provider.of<NoteProvider>(context, listen: false).search(val);
        },
        searchHint: 'Search...',
        mainAppBar: AppBar(
          title: Text('Notes'),
          actions: <Widget>[
            if (!_showOnlyImportant)
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                tooltip: 'Add Note',
                icon: Icon(Icons.note_add),
                onPressed: () => _addNote(context),
              ),
            IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                tooltip: 'Search',
                icon: Icon(Icons.search),
                onPressed: () {
                  appBarController.stream.add(true);
                }),
            mypopup.PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Important) {
                    _showOnlyImportant = true;
                  } else if (selectedValue == FilterOptions.All) {
                    _showOnlyImportant = false;
                  } else {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                mypopup.PopupMenuItem(
                  child: Text('Only Important'),
                  value: FilterOptions.Important,
                ),
                mypopup.PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
                mypopup.PopupMenuItem(
                  child: Text('Settings'),
                  value: FilterOptions.Settings,
                ),
              ],
            ),
          ],
        ));
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: appBar,
      // body: FutureBuilder(
      //   future: Provider.of<NoteProvider>(context,listen: false).fetchAndSetNotes(),
      //   builder: (ctx, snapshot) => snapshot.connectionState ==
      //           ConnectionState.waiting
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: 150.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).canvasColor,
                    ),
                    alignment: Alignment.center,
                    child: const Text('Loading...'),
                  ),
                ),
              )
            : NotesList(_showOnlyImportant),
      ),
    );
  }
}
