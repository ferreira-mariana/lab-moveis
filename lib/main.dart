import 'package:flutter/material.dart';
import 'package:lpdm_proj/delete_project_page.dart';
import 'package:lpdm_proj/drawer_page.dart';
import 'package:lpdm_proj/login_page.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AllProjectsPage allProjectsPage = new AllProjectsPage();
  UserProjectsPage userProjectsPage = new UserProjectsPage();
  List<Widget> actionBarWidgets = new List<Widget>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(tabChanged);
    tabChanged();
  }

  void tabChanged(){
      List<Widget> temp = new List<Widget>();
      if(_tabController.index == 0){
        temp.add(userProjectsPage.deleteProjects);
        temp.add(userProjectsPage.sortProjects);
      }else{
        temp.add(allProjectsPage.refreshProjects);
        temp.add(allProjectsPage.sortProjects);
      }
    setState(() {
      actionBarWidgets = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => ScopedModelDescendant<UserModel>(
            builder: (context, child, user) => Scaffold(
                  drawer: SideMenu(user.projList),
                  appBar: AppBar(
                    actions: actionBarWidgets,
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
                      userProjectsPage,
                      allProjectsPage,
                    ],
                  ),
                ),
          ),
    );
  }
}
