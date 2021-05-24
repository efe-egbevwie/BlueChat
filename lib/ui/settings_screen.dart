import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Settings')),
      ),
      body: SettingsList(
        lightBackgroundColor: Theme.of(context).accentColor,
        contentPadding: EdgeInsets.only(top: 30),
        sections: [
          SettingsSection(
            title: 'Display',
           titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
            tiles: [
              SettingsTile(
                title: 'Theme',
                leading: Icon(Icons.wb_sunny),
                onPressed: (context) {
                  showDialog(context: context, builder: (_) => ShowThemeChangerDialog());
                },
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
            title: 'Account',
            tiles: [
              SettingsTile(
                title: 'Change Password',
                leading: Icon(Icons.lock),
                onPressed: (context) {},
              )
            ],
          )
        ],
      ),
    );
  }
}

class ShowThemeChangerDialog extends StatefulWidget {
  const ShowThemeChangerDialog({Key key}) : super(key: key);

  @override
  _ShowThemeChangerDialogState createState() => _ShowThemeChangerDialogState();
}

class _ShowThemeChangerDialogState extends State<ShowThemeChangerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdaptiveThemeMode>(
      future: AdaptiveTheme.getThemeMode(),
      builder: (context, snapshot) {
        var currentThemeMode = snapshot.data.name;
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text('light'),
                value: 'Light',
                activeColor: Colors.green,
                groupValue: currentThemeMode,
                onChanged: (selectedThemeMode) {
                  AdaptiveTheme.of(context).setLight();
                },
              ),
              RadioListTile(
                title: const Text('dark'),
                value: 'Dark',
                groupValue: currentThemeMode,
                activeColor: Colors.green,
                onChanged: (selectedThemeMode) {
                  AdaptiveTheme.of(context).setDark();
                },
              ),
              RadioListTile(
                title: const Text('system'),
                value: 'System',
                groupValue: currentThemeMode,
                activeColor: Colors.green,
                onChanged: (savedThemeMode) {
                  AdaptiveTheme.of(context).setSystem();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
