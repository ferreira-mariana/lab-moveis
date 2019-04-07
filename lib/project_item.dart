import 'dart:io';

import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  final String _name;
  final String _detail;
  final String _state;
  final String _city;
  final File _image;

  ProjectItem(this._name, this._detail, this._image, this._state, this._city);

  String get name => _name;

  String get detail => _detail;

  File get image => _image;

  String get city => _city;

  String get state => _state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectDetail(_detail, _image)),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              _image == null
                  ? Icon(Icons.image, size: 80)
                  : Image.file(
                _image,
                width: 80,
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              Column(
                children: <Widget>[
                  Text("Nome: " + _name),
                  Text("Cidade: " + _city),
                  Text("Estado: " + _state),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectDetail extends StatelessWidget {
  final String _detail;
  final File _image;

  ProjectDetail(this._detail, this._image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Descrição do Projeto"),
        leading: FlatButton(
          color: Colors.deepPurpleAccent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.keyboard_arrow_left),
        ),
        //child: Icon(Icons.keyboard_arrow_left)),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(),
            ),
            child: _image == null
                ? Icon(
              Icons.image,
              size: 240,
            )
                : Image.file(
              _image,
              height: 240,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                _detail,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
