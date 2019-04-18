import 'package:flutter/material.dart';
import 'config_page.dart';

class Item {
  String nome;

  Item(this.nome);
}

class SideMenu extends StatefulWidget {
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

class PageState extends State<SideMenu> {
  int _selectedDrawerIndex = 0;

  changePages(int index) {
    switch (index) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ConfigPage()));
    }
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.itens.length; i++) {
      var d = widget.itens[i];
      drawerOptions.add(new ListTile(
        title: new Text(d.nome),
        selected: i == _selectedDrawerIndex,
        onTap: () => changePages(i),
      ));
    }

    return Drawer(
      child: new Column(children: <Widget>[
        new UserAccountsDrawerHeader(
            accountName: new Text("Marcelao"), accountEmail: null),
        new Column(children: drawerOptions)
      ]),
    );
  }
}
