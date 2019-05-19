import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/root.dart';
import 'package:scoped_model/scoped_model.dart';
import 'profile.dart';
import 'config.dart';
import 'models.dart';

class Item {
  String nome;
  Item(this.nome);
}

class SideMenu extends StatefulWidget {
  final items = [
    new Item("Perfil"),
    new Item("Configurações"),
    new Item("Sair")
  ];

  @override
  State<StatefulWidget> createState() {
    return new _SideMenuState();
  }
}

class _SideMenuState extends State<SideMenu> {
  int _selectedDrawerIndex = 0;
  changePages(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case 1:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConfigPage()));
        break;
      case 2:
        FirebaseAuth.instance.signOut();
        //widget.auth.signOut();
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => RootPage()));
    }
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      var d = widget.items[i];
      drawerOptions.add(new ListTile(
        title: new Text(d.nome),
        selected: i == _selectedDrawerIndex,
        onTap: () => changePages(i),
      ));
    }
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, user) => Drawer(
              child: ListView(children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(),
                      Material(
                        textStyle:
                            TextStyle(fontSize: 25, color: Colors.deepPurple),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Text(user.username),
                              Padding(padding: EdgeInsets.only(bottom: 8.0)),
                              Text.rich(
                                TextSpan(
                                  text: user.userProjects.length.toString(), style: TextStyle(fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' projetos inscritos',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(children: drawerOptions)
              ]),
            ));
  }
}
