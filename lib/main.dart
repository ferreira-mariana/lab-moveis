import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/delete_project_page.dart';
import 'package:lpdm_proj/side_menu.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'login.dart';

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
      builder: (context, child, config) => MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              brightness: config.bright,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            home: LoginPage(),
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
  TabController _tabController;
  Text _title;
  List _dropDownItems = ['Nome', 'Cidade', 'Estado'];
  String _currentDropDownItem;

  @override
  void initState() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => Scaffold(
            drawer: SideMenu(),
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeleteProjectPage(data.projList),
                        ));
                  },
                ),
                Container(
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(brightness: Brightness.dark),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: _currentDropDownItem,
                          items: _dropDownMenuItems,
                          onChanged: (text) {
                            changedDropDownItem(text);
                            data.sort(text);
                          }),
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
                            builder: (context) => CreateProjectPage()),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                  body: DragAndDropList<ProjectItem>(
                    data.projList,
                    itemBuilder: (BuildContext context, item) {
                      return new SizedBox(
                        child: item,
                      );
                    },
                    onDragFinish: (before, after) {
                      ProjectItem item = data.projList[before];
                      data.projList.removeAt(before);
                      data.projList.insert(after, item);
                    },
                    dragElevation: 8.0,
                    canBeDraggedTo: (one, two) => true,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
