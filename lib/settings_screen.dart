import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget{
  Function _appTheme;

  SettingsScreen(this._appTheme);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Tema Noturno'),
          onTap: () {
            widget._appTheme("dark");
          },
        ),
        ListTile(
          title: Text('Tema Diurno'),
          onTap: () {
            widget._appTheme("light");
          },
        ),
      ],
    );
  }
}