import 'package:flutter/material.dart';
import 'package:lpdm_proj/delete_project_page.dart';
import 'package:lpdm_proj/drawer.dart';
import 'package:lpdm_proj/login.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/user_projects_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lpdm_proj/all_projects_page.dart';

void main() {
  final ConfigModel config = ConfigModel(Brightness.light);
  final DataModel data = DataModel();
  final UserModel user = UserModel();

  runApp(
    ScopedModel<ConfigModel>(
      model: config,
      child: ScopedModel<DataModel>(
        model: data,
        child: ScopedModel<UserModel>(
          model: user,
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, config) => ScopedModelDescendant<UserModel>(
            builder: (context, child, user) => MaterialApp(
                  theme: ThemeData(
                    primarySwatch: Colors.deepPurple,
                    brightness: config.bright,
                  ),
                  home: LoginPage(user),
                ),
          ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<Widget> actionBarWidges = new List<Widget>();
  TabController _tabController;
  List _dropDownItems = ['Nome', 'Cidade', 'Estado'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _dropDownMenuItems = getDropDownMenuItems();
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

  List<Widget> _getAppBarActions(UserModel user, DataModel data) {
    List<Widget> temp = new List<Widget>();
    if (_tabController.index == 0) {
      temp.add(
        FlatButton(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteProjectPage(user.projList),
                ));
          },
        ),
      );
      temp.add(
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              iconSize: 0,
              hint: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              items: _dropDownMenuItems,
              onChanged: (text) {
                user.sort(text);
              },
            ),
          ),
        ),
      );
    } else {
      temp.add(
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              iconSize: 0,
              hint: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              items: _dropDownMenuItems,
              onChanged: (text) {
                data.sort(text);
              },
            ),
          ),
        ),
      );
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => ScopedModelDescendant<UserModel>(
            builder: (context, child, user) => Scaffold(
                  drawer: SideMenu(),
                  appBar: AppBar(
                    actions: _getAppBarActions(user, data),
                    bottom: TabBar(
                      labelPadding: EdgeInsets.only(top: 10),
                      controller: _tabController,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.edit),
                          text: "Meus Projetos",
                        ),
                        Tab(
                          icon: Icon(Icons.list),
                          text: "Lista de Projetos",
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      UserProjectsPage(),
                      AllProjectsPage(),
                    ],
                  ),
                ),
          ),
    );
  }
}
