import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';

class AllProjectsPage extends StatefulWidget{
  final Widget refreshProjects = ScopedModelDescendant<DataModel>(
    builder: (context, child, data) => FlatButton(
      child: Icon(
        Icons.update,
        color: Colors.white,
      ),
      onPressed: () {
        data.updateProjects();
      },
    ),
  );

  final Widget sortProjects =
  ScopedModelDescendant<DataModel>(builder: (context, child, data) {
    List _dropDownItems = ['Nome', 'Cidade', 'Estado'];

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

    List<DropdownMenuItem<String>> _dropDownMenuItems = getDropDownMenuItems();

    return Container(
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
    );
  });

  @override
  State<StatefulWidget> createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjectsPage> with AutomaticKeepAliveClientMixin{
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProjectPage()),
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
                  child: data.isUpdated
                      ? ListView.builder(
                          itemCount: data.projList.length + 1,
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
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
    );
  }
}
