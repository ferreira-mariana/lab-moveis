import 'main.dart';
import 'package:flutter/material.dart';

class User{
  String name;
  String password;
  User(name, password){
    this.name = name;
    this.password = password;
  }
}

class LoginPage extends StatefulWidget{
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  List<User> _users = List<User>();
  
  @override
  initState(){
    super.initState();
    _users.add(User('Luquinhas', '5678'));
    _users.add(User('Marcelo', '1234'));
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