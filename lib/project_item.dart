import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/my_draggable.dart';

class ProjectItem extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _state;
  final String _city;
  final File _image;
  bool checked = false;
  bool canDelete = false;

  ProjectItem(this._name, this._detail, this._state, this._city, this._image);

  bool isChecked() => checked;

  String get name => _name;

  String get detail => _detail;

  File get image => _image;

  String get city => _city;

  String get state => _state;

  @override
  State<StatefulWidget> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetail(widget._detail, widget._image)),
                  );
                },
                child: //Padding(
                  Row(
                    children: <Widget>[
                      widget._image == null
                          ? Icon(Icons.image, size: 80)
                          : Image.file(
                              widget._image,
                              width: 80,
                              height: 80,
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Column(
                        children: <Widget>[
                          Text("Nome: " + widget._name),
                          Text("Cidade: " + widget._city),
                          Text("Estado: " + widget._state),
                        ],
                      ),
                    ],
                  ),
                //),
              ),
            ),
            /*Checkbox(
              value: widget.checked,
              onChanged: (bool change) {
                _checkBoxChange(change);
              },
              checkColor: Colors.white,
              activeColor: Theme.of(context).buttonColor,
            ),*/
          ],
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
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.keyboard_arrow_left),
        ),
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
                    fit: BoxFit.fitWidth,
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
