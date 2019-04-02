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
  List<Widget> projList = new List<Widget>();
  TabController _tabController;
  Text _title;

  updateList(ProjectItem item) {
    setState(() {
      projList = List.from(projList)..add(item);
    });
  }

  updateTitle() {
    setState(() {
      _title = _tabController.index == 0
          ? Text('Meus Projetos')
          : Text('Lista de Projetos');
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(updateTitle);
    updateTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
