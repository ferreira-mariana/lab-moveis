import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _state;
  final String _city;
  final List<File> _imageList;
  final File _miniatureImage;

  ProjectItem(this._name, this._detail, this._state, this._city,
      this._imageList, this._miniatureImage);

  

  String get name => _name;

  String get detail => _detail;

  List<File> get imageList => _imageList;

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
                            widget._name, widget._detail, widget._imageList)),
                  );
                },
                child: //Padding(
                    Row(
                  children: <Widget>[
                    widget._miniatureImage == null
                        ? Icon(Icons.image, size: 80)
                        : Image.file(
                            widget._miniatureImage,
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
  final List<File> _imageList;

  ProjectDetail(this._name, this._detail, this._imageList);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  final Set<String> _projSaved =
      Set<String>(); //conjunto de projetos salvos/inscritos
  String _buttonName = 'INSCREVA-SE';
  Color _buttonColor = Colors.blue;
  Color _buttonTextColor = Colors.white;

  //para mudar o botao quando clica

  //salvar Projeto
  _saveProj(bool alreadySaved) {
    setState(() {
      if (alreadySaved) {
        _projSaved.remove(widget._name); //remove o projeto dos inscritos
        _buttonName = 'INSCREVA-SE';
        _buttonColor = Colors.blue;
        _buttonTextColor = Colors.white;
      } else {
        _projSaved.add(widget._name); //adiciona o projeto aos inscritos
        _buttonName = 'INSCRITO';
        _buttonColor = Colors.grey;
        _buttonTextColor = Colors.grey[700];
      }
    });
  }

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
            child: widget._imageList == null || widget._imageList.length == 0
                ? Icon(
                    Icons.image,
                    size: 240,
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget._imageList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          FlatButton(
                              child: Image(
                                image: FileImage(widget._imageList[index]),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Container(
                                          child: PhotoView(
                                            imageProvider: FileImage(
                                                widget._imageList[index]),
                                          ),
                                        ),
                                  ),
                                );
                              }),
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
    bool alreadySaved = _projSaved.contains(widget._name);

    return RaisedButton(
      onPressed: () {_saveProj(alreadySaved);}, //vai para a funcao de salvar o projeto
      color: _buttonColor,
      textColor: _buttonTextColor,
      padding: const EdgeInsets.all(15.0),
      child: Text(
        _buttonName,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  } //_subscribeButton

}
