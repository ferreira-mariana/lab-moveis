import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/models.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';

class UserProjectsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjectsPage>{
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  TextEditingController _searchController;
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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              TextField(
                controller: _searchController,
                onChanged: (text) {
                  user.updateList();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _searchController.text = "";
                      user.updateList();
                    },
                  ),
                  hintText: "Procurar...",
                ),
              ),
              Expanded(
                child: user.isUpdated
                    ? DragAndDropList(
                  user.projList.length + 1,
                  itemBuilder: (BuildContext context, item) {
                    if (item == user.projList.length) {
                      return new SizedBox(
                        height: 80,
                        child: Center(
                          child: Text("Fim"),
                        ),
                      );
                    } else {
                      return new SizedBox(
                        child:
                        searchItemInList(user.projList[item])
                            ? user.projList[item]
                            : Container(),
                      );
                    }
                  },
                  onDragFinish: (before, after) {
                    ProjectItem item = user.projList[before];
                    user.projList.removeAt(before);
                    user.projList.insert(after, item);
                  },
                  canBeDraggedTo: (one, two) {
                    return two != user.projList.length - 1;
                  },
                  canDrag: (item) {
                    return item != user.projList.length;
                  },
                  dragElevation: 8.0,
                )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
    );
  }
}