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
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            user.username,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          RichText(
                            text: TextSpan(
                              text: user.projList.length.toString(),
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' projetos inscritos',
                                    style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: CircleAvatar(backgroundImage: NetworkImage(user.imgUrl),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Infos',
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
              ),
              ListTile(
                  leading:
                      Text('Email', style: TextStyle(color: Colors.grey[600])),
                  title: Text(user.username)),
              ListTile(
                  leading:
                      Text('Bio', style: TextStyle(color: Colors.grey[600])),
                  title: Text('ola, eu sou fulana')),
            ],
          )),
    );
  }
}
