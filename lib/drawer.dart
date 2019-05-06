import 'package:flutter/material.dart';
import 'package:lpdm_proj/main.dart';
import 'package:lpdm_proj/root.dart';
import 'package:scoped_model/scoped_model.dart';
import 'config.dart';
import 'models.dart';
import 'database.dart';

class Item{
  String nome;
  Item(this.nome);
}

class SideMenu extends StatefulWidget{

  final itens = [
    new Item("Perfil"),
    new Item("Configurações"),
    new Item("Sair")
  ];

  @override
  State<StatefulWidget> createState() {
    return new PageState();
  }
}

class PageState extends State<SideMenu>{
  int _selectedDrawerIndex = 0;
    changePages(int index){
      switch(index){
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigPage()));
          break;
        case 2:
          DBProvider.db.logOut();
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => RootPage()));
      }
      setState((){
        _selectedDrawerIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      var drawerOptions = <Widget>[];
      for (var i = 0; i < widget.itens.length; i++) {
        var d = widget.itens[i];
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

