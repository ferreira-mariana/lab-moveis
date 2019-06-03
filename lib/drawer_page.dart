import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/config_page.dart';
import 'package:lpdm_proj/main.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/profile_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'package:lpdm_proj/custom_route.dart';
import 'project_item.dart';

class Item {
  String nome;
  Item(this.nome);
}

class SideMenu extends StatefulWidget {
  final List<Item> items = [ //atributo
    new Item("Perfil"),
    new Item("Configurações"),
    new Item("Sair")
  ];

  List<ProjectItem> projects; //atributo

  SideMenu(List<ProjectItem> projList){ //construtor
    this.projects = projList;
  }

  @override
  State<StatefulWidget> createState() {
    return new _SideMenuState();
  }
}

class _SideMenuState extends State<SideMenu> {
  int _selectedDrawerIndex = 0;

    changePages(int index, List<ProjectItem>projects) async{
      switch(index){
        case 0:
          Navigator.push(
              context, CustomRoute(builder: (context) => ProfilePage(projects)));
          break;
        case 1:
          Navigator.push(context, CustomRoute(builder: (context) => ConfigPage()));
          break;
        case 2:
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, new CustomRoute(builder: (context) => MyApp()));
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
      drawerOptions.add(new ListTile(
        title: new Text(d.nome),
        selected: i == _selectedDrawerIndex,
        onTap: () => changePages(i, widget.projects),
      ));
    }

    String textProjsInscritos;
    String numberProjsInscritos = widget.projects.length.toString();
    if(widget.projects.length <= 1){
      textProjsInscritos = "projeto inscrito";
      if(widget.projects.length == 0) numberProjsInscritos = "nenhum";
    }
    else{
      textProjsInscritos = "projetos inscritos";
    }
    
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, user) => Drawer(
              child: ListView(children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(backgroundImage: NetworkImage(user.imgUrl),),
                      Material(
                        textStyle:
                            TextStyle(fontSize: 25, color: Colors.deepPurple),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Text(user.username),
                              Padding(padding: EdgeInsets.only(bottom: 8.0)),
                              Text(numberProjsInscritos + " " + textProjsInscritos, style: TextStyle(fontSize: 14)),
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
