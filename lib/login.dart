import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
//class User{
//  String name;
//  String password;
//  User(name, password){
//    this.name = name;
//    this.password = password;
//  }
//}

class LoginPage extends StatefulWidget{
  final VoidCallback logIn;

  LoginPage({this.logIn});
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  initState(){
    super.initState();

  }

  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  build(context){
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        ),
        body: ListView(
              children: <Widget>[
                Container(

                  margin: EdgeInsets.only(
                    top: 50
                    ),
                  width:400,
                  padding: EdgeInsets.all(20),
                  height:300,

                    child: ListView(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                          controller: _name,
                          autofocus: false,
                          decoration: InputDecoration(
                          hintText: "Usuário",

                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)

                            )
                          ),
                        ),
                          ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child:TextFormField(
                              controller: _password,
                              autofocus: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Senha",

                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)
                              )
                            ),
                          ),
                        ),



                Container(
                  margin: EdgeInsets.only(
                    left: 50,
                    right: 50
                  ),
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(32),
                    elevation: 5,
                    child: MaterialButton(
                      child: Text("Entrar"),
                      onPressed: (){
                        FirebaseAuth.instance.signInWithEmailAndPassword(email: _name.text, password: _password.text).then((userId) async {
                          if(userId.toString().length > 0 && userId != null){
                            /*await FirebaseAuth.instance.currentUser().then((onValue){
                              print(onValue.uid);
                            });*/
                            //await user.createUserDocument();
                            //await user.updateUserProjects();
                            widget.logIn();
                          }
                        });
                    },
                  ),
                  )

                )

                      ],
                    )


                  )
              ],
            )
      ),
    );
  }
}