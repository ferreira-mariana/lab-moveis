import 'database.dart';
import 'dart:async';
import 'user.dart';
import 'dart:io';
import 'login.dart';
import 'main.dart';
import 'models.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RootPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RootPageState();

}

class _RootPageState extends State<RootPage>{

  bool isLoggedIn;
  User currUser;
  @override
  void initState(){
    isLoggedIn = false;
    super.initState();
    DBProvider.db.getLoggedIn().then((user){
      setState((){
        currUser = user;
        user == null ? isLoggedIn = false : isLoggedIn = true;
      });
    });

  }
  
  void onLogin(){
    DBProvider.db.getLoggedIn().then((user){
      setState(() {
       isLoggedIn = true;
       currUser = user; 
      });
    });

  }
  @override
  build(context){
    if(isLoggedIn){
      return new ScopedModelDescendant<UserModel>(
        builder: (context, child, user) {
          user.username = currUser.name;
          return HomeScreen();
        }
      );
    }else{
      return new LoginPage(logIn: onLogin);//LoginPage(logIn: onLogin);
    }
        
  }
}



