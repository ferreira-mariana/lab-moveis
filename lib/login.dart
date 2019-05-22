import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lpdm_proj/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

class LoginPage extends StatefulWidget {
  final UserModel user;

  LoginPage(this.user);

  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _googleSignIn.signInSilently().whenComplete(() {
      widget.user.username = _googleSignIn.currentUser.displayName;
      widget.user.uid = _googleSignIn.currentUser.id;
      widget.user.createUserDocument();
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  initLogin() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        widget.user.username = account.displayName;
        widget.user.uid = account.id;
        widget.user.createUserDocument();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else {
        // user NOT logged
      }
    });
  }

  doLogin() async {
    await _googleSignIn.signIn();
    widget.user.username = _googleSignIn.currentUser.displayName;
    widget.user.uid = _googleSignIn.currentUser.id;
    widget.user.createUserDocument();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  build(context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 400,
                  padding: EdgeInsets.all(20),
                  height: 300,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(32),
                        elevation: 5,
                        child: MaterialButton(
                          child: Text("Entrar com Gmail"),
                          onPressed: () {
                            doLogin();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
