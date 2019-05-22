import 'package:flutter/material.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';


class UserModel extends Model{
  String _username;
  
  UserModel();
  String get username => _username;
  set username(String name){
    _username = name;
    notifyListeners();
  }
  
}

class ConfigModel extends Model {
  Brightness _bright;

  ConfigModel(Brightness _bright);

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
  List<ProjectItem> _projsInscritos = new List<ProjectItem>();
  String _sort = 'Nome';

  DataModel() {
    _initList();
    _initList2();
    _sortList();
    _sortListSubscribed();
  }

  List<ProjectItem> get projList => _projList;
  List<ProjectItem> get projsInscritos => _projsInscritos;

  void _initList() {
    projList.add(ProjectItem('B', 'Nada', 'B', 'A', null, 0));
    projList.add(ProjectItem('D', 'Nada', 'A', 'D', null, 0));
    projList.add(ProjectItem('A', 'Nada', 'D', 'B', null, 0));
    projList.add(ProjectItem('E', 'Nada', 'C', 'E', null, 0));
    projList.add(ProjectItem('C', 'Nada', 'E', 'C', null, 0));
  }

  void _initList2() {
    projsInscritos.add(ProjectItem('D', 'Nada', 'K', 'A', null, 1));
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

  void addToListSubscribed(ProjectItem item) {
    projList.remove(item);
    item.changeInscrito();
    projsInscritos.add(item);
    _sortListSubscribed();
    notifyListeners();
  }

  void removeFromListSubscribed(ProjectItem item) {
    projsInscritos.remove(item);
    item.changeInscrito();
    projList.add(item);
    _sortList();
    notifyListeners();
  }

  void removeFromListSubscribedString(String item) {
    for (ProjectItem proj in projsInscritos){
      if (proj.name == item){
        projsInscritos.remove(proj);
        proj.changeInscrito();
        projList.add(proj);
        _sortList();
        notifyListeners();
        break;
      }
    }
  }

  void addToListSubscribedString(String item) {
    for (ProjectItem proj in projsInscritos){
      if (proj.name == item){
        projList.remove(proj);
        proj.changeInscrito();
        projsInscritos.add(proj);
        _sortListSubscribed();
        notifyListeners();
        break;
      }
    }
  }

  void sort(String sort) {
    _sort = sort;
    _sortList();
    _sortListSubscribed();
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

  void _sortListSubscribed() {
    switch (_sort) {
      case "Nome":
        projsInscritos.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case "Cidade":
        projsInscritos.sort((a, b) {
          return a.city.toLowerCase().compareTo(b.city.toLowerCase());
        });
        break;
      case "Estado":
        projsInscritos.sort((a, b) {
          return a.state.toLowerCase().compareTo(b.state.toLowerCase());
        });
        break;
    }
  }
}
