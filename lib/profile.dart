import 'package:flutter/material.dart';
import 'models.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
            appBar: AppBar(
              title: Text('Perfil'),
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        'Nome',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20.0),
                      )),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: CircleAvatar(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Infos',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          RichText(
                          text: TextSpan(
                            text: 'Email ',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                            children: <TextSpan>[
                             TextSpan(
                                 text: user.username,
                                 style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]) 
                              ),
                             ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          RichText(
                          text: TextSpan(
                            text: 'Bio ',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                            children: <TextSpan>[
                             TextSpan(
                                 text: "olá, eu sou fulana",
                                 style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
                             ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          RichText(
                          text: TextSpan(
                            text: 'Projetos inscritos ',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                            children: <TextSpan>[
                             TextSpan(
                                 text: user.userProjects.length.toString(),
                                 style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
                             ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
