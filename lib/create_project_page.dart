import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lpdm_proj/models.dart';
import 'package:scoped_model/scoped_model.dart';

import 'project_item.dart';

class CreateProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  String _nameText = '';
  String _descriptionText = '';
  String _cityText = '';
  String _stateText = '';
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void setNameText(String text) {
    _nameText = text;
  }

  void setDescriptionText(String text) {
    _descriptionText = text;
  }

  void setCityText(String text) {
    _cityText = text;
  }

  void setStateText(String text) {
    _stateText = text;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alerta"),
          content: new Text("Preencha todos os campos obrigatórios"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => Scaffold(
            appBar: AppBar(
              title: Text('Criação de Projeto'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _image == null
                          ? Icon(Icons.image, size: 80)
                          : Image.file(_image, width: 100, height: 100),
                      FlatButton(
                        child: Container(
                          color: Colors.deepPurple[50],
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.attach_file),
                              Text('Escolha uma Foto')
                            ],
                          ),
                        ),
                        onPressed: getImage,
                      )
                    ],
                  ),
                  CustomTextField(
                    lines: 1,
                    length: 30,
                    name: 'Nome (Obrigatório)',
                    function: setNameText,
                  ),
                  CustomTextField(
                    lines: 10,
                    length: 300,
                    name: 'Descrição (Obrigatório)',
                    function: setDescriptionText,
                  ),
                  CustomTextField(
                    lines: 1,
                    length: 30,
                    name: 'Cidade (Obrigatório)',
                    function: setCityText,
                  ),
                  CustomTextField(
                    lines: 1,
                    length: 30,
                    name: 'Estado (Obrigatório)',
                    function: setStateText,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      child: Text("Enviar"),
                      onPressed: () {
                        if (_nameText != '' &&
                            _descriptionText != '' &&
                            _stateText != '' &&
                            _cityText != '') {
                          var temp = new ProjectItem(_nameText,
                              _descriptionText, _stateText, _cityText, _image);
                          data.addToList(temp);
                          Navigator.of(context).pop();
                        } else {
                          _showDialog();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final int lines;
  final int length;
  final String name;
  final Function function;

  CustomTextField({this.lines, this.length, this.name, this.function});

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller = new TextEditingController();

  void updateText(String text) {
    widget.function(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: TextField(
            controller: _controller,
            onChanged: updateText,
            maxLines: widget.lines,
            maxLength: widget.length,
            decoration: InputDecoration(labelText: widget.name),
          ),
        ),
      ),
    );
  }
}