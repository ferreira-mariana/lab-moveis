import 'dart:io';

import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  String _name;
  String _detail;
  File _image;

  ProjectItem(this._name, this._detail, this._image);

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
              Text(
                _name,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectDetail extends StatelessWidget {
  String _detail;
  File _image;

  ProjectDetail(this._detail, this._image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Descrição do Projeto"),
        leading: FlatButton(
          color: Theme.of(context).accentColor,
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
                : Container(
                    height: 240,
                    child: Image.file(_image, fit: BoxFit.contain),
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
