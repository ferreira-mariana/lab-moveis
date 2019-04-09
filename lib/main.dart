import 'package:flutter/material.dart';

import 'create_project_screen.dart';
import 'project_item.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'settings_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  Color primaryColor = Colors.deepPurple;
  Color buttonColor = Colors.deepPurpleAccent;

  void changeTheme(String theme){
    setState(() {
      switch (theme) {
        case "light":
          primaryColor = Colors.deepPurple;
          buttonColor = Colors.deepPurpleAccent;
          return;
        case "dark":
          primaryColor = Colors.black;
          buttonColor = Colors.black38;
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        buttonColor: buttonColor,
      ),
      home: HomeScreen(changeTheme),
    );
  }

}

class HomeScreen extends StatefulWidget {
  final Function changeThemeFunction;

  HomeScreen(this.changeThemeFunction);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<ProjectItem> projList = new List<ProjectItem>();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  TabController _tabController;
  Text _title;
  List _dropDownItems = ['Nome', 'Cidade', 'Estado', 'Custom'];
  String _currentDropDownItem;

  @override
  void initState() {
    super.initState();
    //TEMP
    projList.add(ProjectItem('B', 'Nada', 'B', 'A', null));
    projList.add(ProjectItem('D', 'Nada', 'A', 'D', null));
    projList.add(ProjectItem('A', 'Nada', 'D', 'B', null));
    projList.add(ProjectItem('E', 'Nada', 'C', 'E', null));
    projList.add(ProjectItem('C', 'Nada', 'E', 'C', null));
    //TEMP
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SettingsScreen(widget.changeThemeFunction),
      ),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: ListView(),
          ),
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).buttonColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddNewProjectScreen(projList, updateList)),
                );
              },
              child: Icon(Icons.add),
            ),
            body: _currentDropDownItem == 'Custom'
                ? DragAndDropList<ProjectItem>(
                    projList,
                    itemBuilder: (BuildContext context, item) {
                      return new SizedBox(
                        child: item,
                      );
                    },
                    onDragFinish: (before, after) {
                      ProjectItem data = projList[before];
                      projList.removeAt(before);
                      projList.insert(after, data);
                    },
                    dragElevation: 8.0,
                    canBeDraggedTo: (one, two) => true,
                  )
                : ListView(
                    children: projList,
                  ),
          ),
        ],
      ),
    );
  }
}
