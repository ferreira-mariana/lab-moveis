import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel extends Model {
  String _username;
  String _uid;
  bool _updated = false;
  List<ProjectItem> _userProjects = new List<ProjectItem>();

  String get username => _username;

  set username(String name) {
    _username = name;
    notifyListeners();
  }

  String get uid => _uid;

  set uid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  bool get isUpdated => _updated;

  List<ProjectItem> get userProjects => _userProjects;

  createUserDocument() async{
    DocumentReference userProjects = Firestore.instance.collection("users").document(_uid);
    await userProjects.get().then((onValue) async{
      if(!onValue.exists) {
        await userProjects.setData(<String, dynamic> {
          "projects" : new List<String>(),
        });
      }
    });

    await updateUserProjects();
  }

  updateUserProjects() async {
    _updated = false;

    List<String> projects;
    DocumentReference userDocument = Firestore.instance.collection("users").document(_uid);
    userDocument.get().then((onValue) async {
      projects = List.from(onValue['projects']);
      userProjects.clear();
      for (String i in projects) {
        CollectionReference projectCollection = Firestore.instance.collection("projects");
        Future<QuerySnapshot> query = projectCollection.getDocuments();

        query.then((value) {
          for (DocumentSnapshot item in value.documents) {
            if (item.documentID == i) {
              String name;
              String state;
              String city;
              String description;
              String imgRef;
              List<String> detailImgRefs;
              item.data.forEach((k, v) {
                if (k == "name") name = v;
                if (k == "city") city = v;
                if (k == "state") state = v;
                if (k == "imageUrl") imgRef = v;
                if (k == "detailImageUrls") detailImgRefs = List<String>.from(v);
                if (k == "description") description = v;
              });
              userProjects.add(ProjectItem(
                  name, description, state, city, detailImgRefs, imgRef, item.documentID));
            }
          }
          notifyListeners();
        });
      }
    });
    _updated = true;
  }

  Future<void> subscribeToProject(String proj) async {
    DocumentReference userProjects = Firestore.instance.collection("users").document(_uid);

    List<String> temp = new List<String>();
    temp.add(proj);
    await userProjects.updateData({'projects': FieldValue.arrayUnion(temp)});

    updateUserProjects();
  }

  Future<void> unsubscribeToProject(String proj) async {
    DocumentReference userProjects = Firestore.instance.collection("users").document(_uid);

    List<String> temp = new List<String>();
    temp.add(proj);
    await userProjects.updateData({'projects': FieldValue.arrayRemove(temp)});

    updateUserProjects();
  }

  Future<bool> checkSubscription(String proj) async{
    List<String> projects;
    DocumentReference userDocument = Firestore.instance.collection("users").document(_uid);
    return await userDocument.get().then((onValue) async {
      projects = List.from(onValue['projects']);
      for (String i in projects) {
        if(i == proj) return Future.value(true);
      }
      return Future.value(false);
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
  List<ProjectItem> _projList;
  String _sort = 'Nome';
  bool _updated = false;

  DataModel() {
    _initList();
    _sortList();
  }

  List<ProjectItem> get projList => _projList;

  bool get isUpdated => _updated;

  void _initList() {
    _updated = false;

    _projList = new List<ProjectItem>();
    CollectionReference projectCollection = Firestore.instance.collection("projects");
    Future<QuerySnapshot> query = projectCollection.getDocuments();

    query.then((value) {
      for (DocumentSnapshot item in value.documents) {
        String name;
        String state;
        String city;
        String description;
        String thumbRef;
        List<String> imgRefs;

        item.data.forEach((k, v) {
          if (k == "name") name = v;
          if (k == "city") city = v;
          if (k == "state") state = v;
          if (k == "description") description = v;
          if (k == "imageUrl") thumbRef = v.toString();
          if (k == "detailImageUrls") imgRefs = List<String>.from(v);
    
        });
        projList.add(ProjectItem(
            name, description, state, city, imgRefs, thumbRef, item.documentID));
      }
      notifyListeners();
    });

    _updated = true;
  }

  void addProject(String name, String city, String state, String description, File imgMini, List<DisplayImage> imgs) async{
    CollectionReference projectCollection = Firestore.instance.collection("projects");
    
    StorageReference storageRef = FirebaseStorage.instance.ref().child(imgMini.toString());
    StorageTaskSnapshot downloadUrl = await storageRef.putFile(imgMini).onComplete;
    String urlMini = await downloadUrl.ref.getDownloadURL();
    List<String> imgUrls = new List<String>();
    
    for(DisplayImage img in imgs){
      storageRef = FirebaseStorage.instance.ref().child(img.image.toString());
      downloadUrl = await storageRef.putFile(img.image).onComplete;
      imgUrls.add(await downloadUrl.ref.getDownloadURL());
    }
    await projectCollection.add(<String, dynamic> {
      "name" : name,
      "city" : city,
      "state" : state,
      "description" : description,
      "imageUrl" : urlMini,
      "detailImageUrls" : imgUrls
    });
    _initList();
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

  void updateList() {
    notifyListeners();
  }
}
