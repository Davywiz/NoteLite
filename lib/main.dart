import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/settings_screen.dart';
import './providers/notes_provider.dart';
import './screens/note_screen.dart';
import './screens/note_details.dart';
import './providers/theme_provider.dart';
import './models/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ThemeData theme;
  if (!prefs.containsKey('userTheme')) {
    theme = appThemeData[AppTheme.Light];
  } else {
    final extractedTheme = prefs.getInt('userTheme');
    theme = appThemeData[AppTheme.values[extractedTheme]];
  }
  runApp(
    MyApp(theme: theme),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({Key key, this.theme}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => NoteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeManager(),
        ),
      ],
      child: ShowApp(theme),
    );
  }
}

class ShowApp extends StatefulWidget {
  final ThemeData theme;
  ShowApp(this.theme);
  @override
  _ShowAppState createState() => _ShowAppState();
}

class _ShowAppState extends State<ShowApp> {
  var _initialTheme = true;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<ThemeManager>(context, listen: false)
          .loadTheme()
          .then((_) => setState(() {
                _initialTheme = false;
              }));
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (ctx, themeManager, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes Lite',
        theme: _initialTheme ? widget.theme : themeManager.themeData,
        home: NoteScreen(),
        routes: {
          NotesDetailScreen.routeName: (ctx) => NotesDetailScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
        },
      );
    });
  }
}
