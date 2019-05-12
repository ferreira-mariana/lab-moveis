import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/delete_project_page.dart';
import 'package:lpdm_proj/drawer.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
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
      builder: (context, child, config) =>
          MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              brightness: config.bright,
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
  TextEditingController _searchController;
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
    _searchController = new TextEditingController();
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

  bool searchItemInList(ProjectItem item) {
    return (item.name
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        item.city
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()) ||
        item.state
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) =>
          Scaffold(
            primary: true,
            drawer: SideMenu(),
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
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
                        iconSize: 0,
                        hint: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                        items: _dropDownMenuItems,
                        onChanged: (text) {
                          changedDropDownItem(text);
                          data.sort(text);
                        },
                      ),
                    ),
                  ),
                ),
              ],
              //title: _title,
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
                Center(
                  child: ListView(),
                ),
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateProjectPage()),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  body: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      TextField(
                        controller: _searchController,
                        onChanged: (text) {
                          data.updateList();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _searchController.text = "";
                              data.updateList();
                            },
                          ),
                          hintText: "Procurar...",
                        ),
                      ),
                      Expanded(
                        child: DragAndDropList(
                          data.projList.length + 1,
                          itemBuilder: (BuildContext context, item) {
                            if (item == data.projList.length) {
                              return new SizedBox(
                                height: 80,
                                child: Center(
                                  child: Text("Fim"),
                                ),
                              );
                            } else {
                              return new SizedBox(
                                child: searchItemInList(data.projList[item])
                                    ? data.projList[item]
                                    : Container(),
                              );
                            }
                          },
                          onDragFinish: (before, after) {
                            ProjectItem item = data.projList[before];
                            data.projList.removeAt(before);
                            data.projList.insert(after, item);
                          },
                          canBeDraggedTo: (one, two) {
                            return two != data.projList.length - 1;
                          },
                          canDrag: (item) {
                            return item != data.projList.length;
                          },
                          dragElevation: 8.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}