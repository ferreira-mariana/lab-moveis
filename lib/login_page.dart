import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lpdm_proj/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final UserModel user;

  LoginPage(this.user);

  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = true;
    initUser();
  }

  initUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      widget.user.username = user.displayName;
      widget.user.uid = user.uid;
      widget.user.imgUrl = user.photoUrl;
      await widget.user.createUserDocument();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount == null) return;

    setState(() {
      loading = true;
    });

    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    widget.user.username = user.displayName;
    widget.user.uid = user.uid;
    widget.user.imgUrl = user.photoUrl;
    widget.user.createUserDocument();

    googleSignIn.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  build(context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => loading
          ? Scaffold(
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Carregando..."),
                    ]),
              ),
            )
          : Scaffold(
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
                              _signIn();
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
