import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lpdm_proj/config_page.dart';
import 'package:lpdm_proj/main.dart';
import 'package:lpdm_proj/models.dart';
import 'package:scoped_model/scoped_model.dart';

class Item{
  String nome;
  Item(this.nome);
}

class SideMenu extends StatefulWidget{
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

class _SideMenuState extends State<SideMenu>{
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  int _selectedDrawerIndex = 0;
    changePages(int index){
      switch(index){
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigPage()));
          break;
        case 2:
          //FirebaseAuth.instance.signOut();
          //widget.auth.signOut();
          _googleSignIn.signOut();
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => MyApp()));
      }
      setState((){
        _selectedDrawerIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      var drawerOptions = <Widget>[];
      for (var i = 0; i < widget.items.length; i++) {
        var d = widget.items[i];
        drawerOptions.add(
            new ListTile(
              title: new Text(d.nome),
              selected: i == _selectedDrawerIndex,
              onTap: () => changePages(i),
            )
        );
      }
      return ScopedModelDescendant<UserModel>(
        builder: (context, child, user) =>  Drawer(
          child: ListView( 
            children: <Widget>[
              DrawerHeader(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(),
                      Material(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurple
                        ),
                        child: Text(user.username),
                      )
                    ],
                  ),),
              Column(children: drawerOptions)
            ]
          ),
        )
      );
    }
}

