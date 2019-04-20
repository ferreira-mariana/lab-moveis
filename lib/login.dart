import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'database.dart';
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
  //List<User> _users;

  //Future<List<User>> getData() async{
    //var source = await rootBundle.loadString('assets/users.json');
    //print(source);
    //setState(() {
      //_users = source;
      //var data = json.decode(source);
      //var users = data["users"] as List;
      //print(_users);
      //_users = users.map<User>((json) => User.fromJson(json)).toList();
    //});
    //return _users;
  //}
  @override
  initState(){
    super.initState();
    
    //_users.add(User('Luquinhas', '5678'));
    //_users.add(User('Marcelo', '1234'));
  }

  checkIfValidUser(List<User> _users){
    for(int i=0;i<_users.length;i++){
      if(_name.text == _users[i].name && _password.text == _users[i].password) return _users[i];
    }
    return null;
  }
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  build(context){
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        ),
        body: FutureBuilder<List<User>>(
          future: DBProvider.db.getAllUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot){
              return ListView(
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
                        User usr = checkIfValidUser(snapshot.data);
                        if(usr != null){
                          user.username = usr.name;
                          Navigator.push(
                              context, 
                              MaterialPageRoute(
                              builder: (context) => HomeScreen()
                              ));
                        }else{
                          print(snapshot.data);
                        } 
                    },
                  ),
                  )
                   
                )
                
                      ],
                    )
                    
                  
                  )
              ],
            );
          }
        )
      )
    );
  }
}