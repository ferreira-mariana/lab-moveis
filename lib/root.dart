import 'user.dart';
import 'login.dart';
import 'main.dart';
import 'models.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'authentication.dart';


class RootPage extends StatefulWidget{
  final BaseAuth auth;
  RootPage({this.auth});
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{

  bool isLoggedIn;
  User currUser;
  @override
  void initState(){
    currUser = User();
    isLoggedIn = false;
    super.initState();
    widget.auth.getCurrentUser().then((user){
      setState((){
        currUser.name = user.email;
        user == null ? isLoggedIn = false : isLoggedIn = true;
      });
    });
  }
  
  void onLogin(){
    print("AEASDASDASDASD");
    widget.auth.getCurrentUser().then((user){
      setState(() {
       isLoggedIn = true;
       currUser.name = user.email; 
      });
    });
  }

  @override
  build(context){
    if(isLoggedIn){
      return new ScopedModelDescendant<UserModel>(
        builder: (context, child, user) {
          user.username = currUser.name;
          return HomeScreen(auth: widget.auth);
        }
      );
    }else{
      return new LoginPage(logIn: onLogin, auth: widget.auth);
    }
  }
}



