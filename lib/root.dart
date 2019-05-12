import 'package:firebase_auth/firebase_auth.dart';

import 'user.dart';
import 'login.dart';
import 'main.dart';
import 'models.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'authentication.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool isLoggedIn;
  bool initUserData;
  User currUser;

  @override
  void initState() {
    currUser = User();
    isLoggedIn = false;
    initUserData = true;
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        currUser.name = user.email;
        currUser.uid = user.uid;
        user == null ? isLoggedIn = false : isLoggedIn = true;
      });
    });
  }

  void onLogin() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        isLoggedIn = true;
        currUser.name = user.email;
        currUser.uid = user.uid;
      });
    });
  }

  @override
  build(context) {
    if (isLoggedIn) {
      return new ScopedModelDescendant<UserModel>(
          builder: (context, child, user) {
        user.username = currUser.name;
        user.uid = currUser.uid;
        if (initUserData) {
          user.createUserDocument();
          initUserData = false;
        }
        return HomeScreen();
      });
    } else {
      return new LoginPage(logIn: onLogin);
    }
  }
}
