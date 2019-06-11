import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpdm_proj/create_project_page.dart';
import 'package:lpdm_proj/project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_webservice/places.dart';

class UserModel extends Model {
  String _username;
  String _email;
  String _bio;
  String _uid;
  String _sort = 'Nome';
  String _imgUrl;
  bool _updated = false;
  List<ProjectItem> _projList = new List<ProjectItem>();

  String get username => _username;

  set username(String name) {
    _username = name;
    notifyListeners();
  }

  String get email => _email;

  set email(String e) {
    _email = e;
    notifyListeners();
  }

  String get bio => _bio;

  set bio(String b) {
    _bio = b;
    notifyListeners();
  }


  String get uid => _uid;

  set uid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  String get imgUrl => _imgUrl;

  set imgUrl(String value) {
    _imgUrl = value;
    notifyListeners();
  }

  bool get isUpdated => _updated;

  List<ProjectItem> get projList => _projList;

  createUserDocument() async {
    _updated = false;
    notifyListeners();

    DocumentReference userDocument =
        Firestore.instance.collection("users").document(_uid);
    await userDocument.get().then((onValue) async {
      if (!onValue.exists) {
        await userDocument.setData(<String, dynamic>{
          "projects": new List<String>(),
          "bio": String,
        });
      }
    });

    await updateUserProjects();
  }

  updateUserProjects() async {
    _updated = false;
    notifyListeners();

    List<String> projects;
    DocumentReference userDocument =
        Firestore.instance.collection("users").document(_uid);
    await userDocument.get().then((onValue) async {
      _bio = onValue['bio'];
      projects = List.from(onValue['projects']);
      projList.clear();
      for (String i in projects) {
        CollectionReference projectCollection =
            Firestore.instance.collection("projects");
        Future<QuerySnapshot> query = projectCollection.getDocuments();

        await query.then((value) {
          for (DocumentSnapshot item in value.documents) {
            if (item.documentID == i) {
              String name;
              String numero = "";
              String rua = "";
              String bairro = "";
              String cidade = "";
              String estado = "";
              String pais = "";
              String placeid = "";
              String description;
              String thumbRef;
              List<String> imgRefs;
              List<String> detailImgRefs;
              item.data.forEach((k, v) {
                if (k == "name") name = v;
                if (k == "numero") numero = v;
                if (k == "rua") rua = v;
                if (k == "bairro") bairro = v;
                if (k == "cidade") cidade = v;
                if (k == "estado") estado = v;
                if (k == "pais") pais = v;
                if (k == "placeid") placeid = v;
                if (k == "description") description = v;
                if (k == "imageUrl") {
                  if (v == null)
                    thumbRef = null;
                  else
                    thumbRef = v.toString();
                }
                if (k == "detailImageUrls") imgRefs = List<String>.from(v);
              });
              projList.add(ProjectItem(
                  placeid,
                  name,
                  description,
                  numero,
                  rua,
                  bairro,
                  cidade,
                  estado,
                  pais,
                  item.documentID,
                  imgRefs,
                  thumbRef));
            }
          }
        });
      }
    });
    _updated = true;
    notifyListeners();
  }

  Future<void> subscribeToProject(String proj) async {
    DocumentReference userProjects =
        Firestore.instance.collection("users").document(_uid);
    List<String> temp = new List<String>();
    temp.add(proj);
    await userProjects.updateData({'projects': FieldValue.arrayUnion(temp)});
    updateUserProjects();
  }

  Future<void> unsubscribeToProjects(List<String> proj) async {
    DocumentReference userProjects =
        Firestore.instance.collection("users").document(_uid);
    await userProjects.updateData({'projects': FieldValue.arrayRemove(proj)});
    updateUserProjects();
  }

  Future<bool> checkSubscription(String proj) async {
    List<String> projects;
    DocumentReference userDocument =
        Firestore.instance.collection("users").document(_uid);
    return await userDocument.get().then((onValue) async {
      projects = List.from(onValue['projects']);
      for (String i in projects) {
        if (i == proj) return Future.value(true);
      }
      return Future.value(false);
    });
  }
  
  void organizeUserProjects() async{
    DocumentReference userProjects =
    Firestore.instance.collection("users").document(_uid);
    List<String> temp = new List<String>();
    for(ProjectItem item in projList)
      temp.add(item.projectId);
    await userProjects.updateData({'projects': FieldValue.arrayRemove(temp)}).
      then((onValue) {
        userProjects.updateData({'projects': FieldValue.arrayUnion(temp)});
      });
  }

  void sort(String sort) {
    _sort = sort;
    _sortList();
    organizeUserProjects();
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
          return a.cidade.toLowerCase().compareTo(b.cidade.toLowerCase());
        });
        break;
      case "Estado":
        projList.sort((a, b) {
          return a.estado.toLowerCase().compareTo(b.estado.toLowerCase());
        });
        break;
    }
  }

  void updateList() {
    notifyListeners();
  }
}

class DataModel extends Model {
  List<ProjectItem> _projList;
  String _sort = 'Nome';
  bool _updated = false;

  DataModel() {
    updateProjects();
    _sortList();
  }

  List<ProjectItem> get projList => _projList;

  bool get isUpdated => _updated;

  void updateProjects() async {
    _updated = false;
    notifyListeners();

    _projList = new List<ProjectItem>();
    CollectionReference projectCollection =
        Firestore.instance.collection("projects");
    Future<QuerySnapshot> query = projectCollection.getDocuments();

    await query.then((value) {
      for (DocumentSnapshot item in value.documents) {
        String name;
        String numero = "";
        String rua = "";
        String bairro = "";
        String cidade = "";
        String estado = "";
        String pais = "";
        String placeid = "";
        String description;
        String thumbRef;
        List<String> imgRefs;

        item.data.forEach((k, v) {
          if (k == "name") name = v;
          if (k == "numero") numero = v;
          if (k == "rua") rua = v;
          if (k == "bairro") bairro = v;
          if (k == "cidade") cidade = v;
          if (k == "estado") estado = v;
          if (k == "pais") pais = v;
          if (k == 'placeid') placeid = v;
          if (k == "description") description = v;
          if (k == "imageUrl") {
            if (v == null)
              thumbRef = null;
            else
              thumbRef = v.toString();
          }
          if (k == "detailImageUrls") imgRefs = List<String>.from(v);
        });
        projList.add(ProjectItem(placeid, name, description, numero, rua,
            bairro, cidade, estado, pais, item.documentID, imgRefs, thumbRef));
      }
    });
    _updated = true;
    notifyListeners();
  }

  void addProject(String name, PlacesDetailsResponse detail, String description,
      File imgMini, List<DisplayImage> imgs) async {
    String numero = "";
    String rua = "";
    String bairro = "";
    String cidade = "";
    String estado = "";
    String pais = "";
    _updated = false;
    notifyListeners();

    for (AddressComponent c in detail.result.addressComponents) {
      if (c.types.contains('street_number'))
        numero = c.longName;
      else if (c.types.contains('route'))
        rua = c.longName;
      else if (c.types.contains('sublocality_level_1'))
        bairro = c.longName;
      else if (c.types.contains('administrative_area_level_2'))
        cidade = c.longName;
      else if (c.types.contains('administrative_area_level_1'))
        estado = c.longName;
      else if (c.types.contains('country')) pais = c.longName;
    }

    CollectionReference projectCollection =
        Firestore.instance.collection("projects");

    StorageReference storageRef;
    StorageTaskSnapshot downloadUrl;
    String urlMini;

    if (imgMini != null) {
      storageRef = FirebaseStorage.instance.ref().child(imgMini.toString());
      downloadUrl = await storageRef.putFile(imgMini).onComplete;
      urlMini = await downloadUrl.ref.getDownloadURL();
    } else
      urlMini = null;

    List<String> imgUrls = new List<String>();

    for (DisplayImage img in imgs) {
      storageRef = FirebaseStorage.instance.ref().child(img.image.toString());
      downloadUrl = await storageRef.putFile(img.image).onComplete;
      imgUrls.add(await downloadUrl.ref.getDownloadURL());
    }
    await projectCollection.add(<String, dynamic>{
      "name": name,
      "numero": numero,
      "rua": rua,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
      "pais": pais,
      "placeid": detail.result.placeId,
      "description": description,
      "imageUrl": urlMini,
      "detailImageUrls": imgUrls
    });
    updateProjects();
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
          return a.cidade.toLowerCase().compareTo(b.cidade.toLowerCase());
        });
        break;
      case "Estado":
        projList.sort((a, b) {
          return a.estado.toLowerCase().compareTo(b.estado.toLowerCase());
        });
        break;
    }
  }

  void updateList() {
    notifyListeners();
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
