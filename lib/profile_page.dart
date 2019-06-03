import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lpdm_proj/project_item.dart';
import 'models.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatefulWidget {
  List<ProjectItem> projects; //atributo

  ProfilePage(List<ProjectItem> p) {
    //construtor
    this.projects = p;
  }

  @override
  State<StatefulWidget> createState(){
    return new _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context) {
    String textProjsInscritos;
    String numberProjsInscritos = widget.projects.length.toString();
    if (widget.projects.length <= 1) {
      textProjsInscritos = "projeto inscrito";
      if (widget.projects.length == 0) numberProjsInscritos = "nenhum";
    } else {
      textProjsInscritos = "projetos inscritos";
    }

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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              numberProjsInscritos + " " + textProjsInscritos,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                              )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.imgUrl),
                          ),
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
