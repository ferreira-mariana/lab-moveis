import 'package:flutter/material.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:postgres/postgres.dart';

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
  String _sort = 'Nome';
  PostgreSQLConnection connection;

  DataModel() {
    _initList();
    _sortList();
  }

  List<ProjectItem> get projList => _projList;

  void _initList() async {
    connection = new PostgreSQLConnection("191.250.147.111", 5432, "lpdm",
        username: "postgres", password: "451226062922");
    await connection.open();
    refreshList();
  }

  void refreshList() async {
    List<List<dynamic>> list = await connection.query("SELECT * FROM project");
    projList.clear();

    for (int i = 0; i < list.length; i++) {
      projList
          .add(ProjectItem(list[i][1], "nada", list[i][2], list[i][3], null));
    }
    _sortList();
    notifyListeners();
  }

  void addToList(ProjectItem item) async{
    await connection.query(
        "INSERT INTO project VALUES(DEFAULT, @nome, @cidade, @estado)",
        substitutionValues: {
          "nome": item.name,
          "cidade": item.city,
          "estado": item.state
        });
    refreshList();
  }

  void removeFromList(ProjectItem item) {
    projList.remove(item);
    //refreshList();
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
}
