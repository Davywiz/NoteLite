import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/back_button.dart';
import '../providers/theme_provider.dart';
import '../models/app_themes.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme =
        Provider.of<ThemeManager>(context, listen: false).dataThemeApp;
  }

  void _handleThemeSelection(AppTheme value) {
    setState(() {
      _selectedTheme = value;
    });
    if (value == AppTheme.Light) {
      Provider.of<ThemeManager>(context, listen: false)
          .setTheme(AppTheme.Light);
    } else {
      Provider.of<ThemeManager>(context, listen: false).setTheme(AppTheme.Dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GoBackButton(),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('App Theme',
                              style: TextStyle(fontSize: 24)),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: AppTheme.Light,
                                groupValue: _selectedTheme,
                                onChanged: _handleThemeSelection,
                              ),
                              const Text(
                                'Light theme',
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Theme.of(context).accentColor,
                                value: AppTheme.Dark,
                                groupValue: _selectedTheme,
                                onChanged: _handleThemeSelection,
                              ),
                              const Text(
                                'Dark theme',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DeveloperContact(),
          ],
        ),
      ),
    );
  }
}

class DeveloperContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('About', style: TextStyle(fontSize: 24)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      'Notes Lite is a simple Note taking app, Enjoy the lite Experience.'),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text('Version 1.0.0'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
