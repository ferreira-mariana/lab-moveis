import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _state;
  final String _city;
  final File _image;

  ProjectItem(this._name, this._detail, this._state, this._city, this._image);

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
                        builder: (context) => ProjectDetail(
                            widget._name, widget._detail, widget._image)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//tela dos detalhes de um projeto
class ProjectDetail extends StatefulWidget {
  final String _name;
  final String _detail;
  final File _image;

  ProjectDetail(this._name, this._detail, this._image);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {

  final Set _projSaved = Set(); //conjunto de projetos salvos/inscritos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._name),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(),
            ),
            child: widget._image == null
                ? Icon(
                    Icons.image,
                    size: 240,
                  )
                : FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Container(
                                child: PhotoView(
                                  imageProvider: FileImage(widget._image),
                                ),
                              ),
                        ),
                      );
                    },
                    child: Image.file(
                      widget._image,
                      height: 240,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Text(
              widget._detail,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Center(
            child: _subscribeButton(),
          ),
        ],
      ),
    );
  }

  //botao para inscrever-se no projeto
  Widget _subscribeButton() {
    final bool alreadySaved = _projSaved.contains(widget._name);

    //salvar Projeto
    _saveProj() {
      if(alreadySaved) {
        _projSaved.remove(widget._name); //remove o projeto dos inscritos
        //TODO: muda o botao para inscreva-se
      } else {
        _projSaved.add(widget._name); //adiciona o projeto aos inscritos
        //TODO: muda o botao para inscrito
      }
    }

    return RaisedButton(
      //botao para se inscrever no projeto
      onPressed: _saveProj, //vai para a funcao de salvar o projeto
      color: Colors.blue,
      textColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
      child: Text(
        'INSCREVA-SE',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  } //_subscribeButton

}
