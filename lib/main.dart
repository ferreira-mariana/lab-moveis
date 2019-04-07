import 'package:flutter/material.dart';

import 'create_project_screen.dart';
import 'project_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<ProjectItem> projList = new List<ProjectItem>();
  List<DropdownMenuItem<String>> _dropDownMenuItems = new List();
  TabController _tabController;
  Text _title;
  List _dropDownItems = ['Nome', 'Cidade', 'Estado'];
  String _currentDropDownItem;

  @override
  void initState() {
    //TEMP
    projList.add(ProjectItem('B', 'Nada', null, 'B', 'A'));
    projList.add(ProjectItem('D', 'Nada', null, 'A', 'D'));
    projList.add(ProjectItem('A', 'Nada', null, 'D', 'B'));
    projList.add(ProjectItem('E', 'Nada', null, 'C', 'E'));
    projList.add(ProjectItem('C', 'Nada', null, 'E', 'C'));
    //TEMP

    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(updateTitle);
    _dropDownMenuItems = getDropDownMenuItems();
    _currentDropDownItem = _dropDownMenuItems[0].value;
    updateTitle();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _dropDownItems) {
      items.add(new DropdownMenuItem(
        value: city,
        child: new Text(city),
      ));
    }
    return items;
  }

  updateList(ProjectItem item) {
    setState(() {
      projList.add(item);
      sortList();
      projList = List.from(projList);
    });
  }

  sortList() {
    switch (_currentDropDownItem) {
      case "Nome":
        projList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case "Cidade":
        projList.sort((a, b) {
          return a.city.toLowerCase().compareTo(b.city.toLowerCase());
        });
        break;
      case "Estado":
        projList.sort((a, b) {
          return a.state.toLowerCase().compareTo(b.state.toLowerCase());
        });
        break;
    }
  }

  updateTitle() {
    setState(() {
      _title = _tabController.index == 0
          ? Text('Meus Projetos')
          : Text('Lista de Projetos');
    });
  }

  void changedDropDownItem(String selected) {
    setState(() {
      _currentDropDownItem = selected;
      sortList();
      projList = List.from(projList);
      print(_currentDropDownItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            child: Theme(
              data: Theme.of(context).copyWith(brightness: Brightness.dark),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _currentDropDownItem,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
              ),
            ),
          ),
        ],
        title: _title,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.edit)),
            Tab(icon: Icon(Icons.list)),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Center(
          child: ListView(),
        ),
        Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddNewProjectScreen(projList, updateList)),
                );
              },
              child: Icon(Icons.add)),
          body: ListView(
            children: projList,
          ),
        ),
      ]),
    );
  }
}
