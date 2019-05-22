import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';

class AllProjectsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjectsPage> {
  TextEditingController _searchController;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _dropDownItems = ['Nome', 'Cidade', 'Estado'];

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
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
