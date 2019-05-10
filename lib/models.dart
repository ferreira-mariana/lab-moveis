import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  String _username;
  List<ProjectItem> _userProjects = new List<ProjectItem>();

  UserModel(){
    updateUserProjects();
  }

  String get username => _username;
  set username(String name){
    _username = name;
    notifyListeners();
  }

  List<ProjectItem> get userProjects => _userProjects;

  updateUserProjects() async{
    CollectionReference projectCollection = Firestore.instance.collection("projects");
    Future<QuerySnapshot> query = projectCollection.getDocuments();

    query.then((value) {
      for(DocumentSnapshot item in value.documents){
        String name;
        String state;
        String city;
        String description;

        item.data.forEach((k, v) {
          if(k == "name") name = v;
          if(k == "city") city = v;
          if(k == "state") state = v;
          if(k == "description") description = v;
        });
        userProjects.add(ProjectItem(name, description, state, city, null, null));
      }
      notifyListeners();
    });
  }
}

class ConfigModel extends Model {
  Brightness _bright;

  ConfigModel(this._bright);

  Brightness get bright => _bright;

  changeBrightness() {
    _bright == Brightness.light
        ? _bright = Brightness.dark
        : _bright = Brightness.light;

    notifyListeners();
  }
}

class DataModel extends Model {
  List<ProjectItem> _projList = new List<ProjectItem>();
  String _sort = 'Nome';

  DataModel() {
    _initList();
    _sortList();
  }

  List<ProjectItem> get projList => _projList;

  void _initList() {
    projList.add(ProjectItem('B', 'Nada', 'B', 'A', null, null));
    projList.add(ProjectItem('D', 'Nada', 'A', 'D', null, null));
    projList.add(ProjectItem('A', 'Nada', 'D', 'B', null, null));
    projList.add(ProjectItem('E', 'Nada', 'C', 'E', null, null));
    projList.add(ProjectItem('C', 'Nada', 'E', 'C', null, null));
    projList.add(ProjectItem('G', 'Nada', 'B', 'A', null, null));
    projList.add(ProjectItem('I', 'Nada', 'A', 'D', null, null));
    projList.add(ProjectItem('J', 'Nada', 'D', 'B', null, null));
    projList.add(ProjectItem('F', 'Nada', 'C', 'E', null, null));
    projList.add(ProjectItem('H', 'Nada', 'E', 'C', null, null));
  }

  void addToList(ProjectItem item) {
    projList.add(item);
    _sortList();
    notifyListeners();
  }

  void removeFromList(ProjectItem item) {
    projList.remove(item);
    _sortList();
    notifyListeners();
  }

  void sort(String sort) {
    _sort = sort;
    _sortList();
    notifyListeners();
  }

  void _sortList() {
    switch (_sort) {
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

  void updateList(){
    notifyListeners();
  }
}
