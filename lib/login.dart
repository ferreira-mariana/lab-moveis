import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'user.dart';

//class User{
//  String name;
//  String password;
//  User(name, password){
//    this.name = name;
//    this.password = password;
//  }
//}

class LoginPage extends StatefulWidget{
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  List<User> _users;
  
  Future<List<User>> getData() async{
    var source = await rootBundle.loadString('assets/users.json');
    setState(() {
      var data = json.decode(source);
      var users = data["users"] as List;
      print(users);
      _users = users.map<User>((json) => User.fromJson(json)).toList();
    });
    return _users;
  }
  @override
  initState(){
    super.initState();
    getData();
    //_users.add(User('Luquinhas', '5678'));
    //_users.add(User('Marcelo', '1234'));
  }

  checkIfValidUser(){
    for(int i=0;i<_users.length;i++){
      if(_name.text == _users[i].name && _password.text == _users[i].password) return true;
    }
    return false;
  }
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              controller: _name,
              
            ),
            TextField(
              controller: _password,
            ),
            RaisedButton(
              child: Text("Entrar"),
              onPressed: (){
                if(checkIfValidUser()){
                  Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => HomeScreen()
                  ));
                }else{
                  print('no such user');
                } 

              },
            )
          ],
        ),
    );
  }
}