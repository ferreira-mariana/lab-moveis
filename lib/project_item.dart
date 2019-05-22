import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lpdm_proj/models.dart';

class ProjectItem extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _state;
  final String _city;
  final File _image;
  int _inscrito; //1 = inscrito, 0 = não inscrito

  ProjectItem(this._name, this._detail, this._state, this._city, this._image, this._inscrito);

  String get name => _name;

  String get detail => _detail;

  File get image => _image;

  String get city => _city;

  String get state => _state;

  void changeInscrito(){
    if (_inscrito == 0) _inscrito = 1;
    else _inscrito = 0;
  }

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
                        builder: (context) => ProjectDetail(widget)),
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
  ProjectItem _atual;

  ProjectDetail(this._atual);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  Color defineButtonColor(){
    if (widget._atual._inscrito == 1) return Colors.grey;
    return Colors.blue;
  }

  Color defineTextColor(){
    if (widget._atual._inscrito == 1) return Colors.grey[700];
    return Colors.white;
  }

  String defineText(){
    if (widget._atual._inscrito == 1) return 'Inscrito';
    return 'Inscreva-se';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._atual._name),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: widget._atual._image == null
                ? Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/default.jpg',
                              )
                          )
                      ),
                    )
                  )
                : FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Container(
                                child: PhotoView(
                                  imageProvider: FileImage(widget._atual._image),
                                ),
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(widget._atual._image)
                        )
                      ),
                    )
                  ),
          ),
          Center (
            child: Container (
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.purple[100],
                  border: new Border.all(
                      color: Colors.white,
                      width: 5.0,
                      style: BorderStyle.solid
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0))
              ),
              child: Container (
                child: Column (
                  children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Center (
                            child: Text(
                              'Descrição',
                              style: TextStyle(fontSize: 30.0),
                            ),
                          )
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                            child: Center (
                              child: Text(
                                widget._atual._detail,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )
                        )
                  ],
                )
              )
            )
          ),

          Center (
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Center (
                    child: Container (
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            border: new Border.all(
                              color: Colors.white,
                              width: 5.0,
                              style: BorderStyle.solid
                            ),
                            borderRadius: new BorderRadius.all(new Radius.circular(20.0))
                        ),
                        child: Container (
                            child: Column (
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                    child: Text(
                                      'Estado',
                                      style: TextStyle(fontSize: 20.0)
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Text(
                                      widget._atual._state,
                                      style: TextStyle(fontSize: 13.0),
                                    )
                                )
                              ],
                            )
                        )
                    )
                ),
                Center (
                    child: Container (
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            border: new Border.all(
                                color: Colors.white,
                                width: 5.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: new BorderRadius.all(new Radius.circular(20.0))
                        ),
                        child: Container (
                            child: Column (
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                    child: Text(
                                      'Cidade',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Text(
                                      widget._atual._city,
                                      style: TextStyle(fontSize: 13.0),
                                    )
                                )
                              ],
                            )
                        )
                    )
                ),
              ]
            )
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
              child: Container(
                decoration: BoxDecoration(
                  border: new Border.all(
                    color: Colors.blue,
                    width: 3.0,
                    style: BorderStyle.solid
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0))
                ),
                child: _subscribeButton()
              )
            )
          ),
        ],
      )
    );
  }

  //botao para inscrever-se no projeto
  Widget _subscribeButton() {
    return ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => FlatButton(
        //botao para se inscrever no projeto
        onPressed: () {
          //_saveProj(widget._atual._inscrito);
          if (widget._atual._inscrito == 1) data.removeFromListSubscribed(widget._atual);
          else data.addToListSubscribed(widget._atual);
        }, //vai para a funcao de salvar o projeto
        color: defineButtonColor(),
        textColor: defineTextColor(),
        //padding: const EdgeInsets.all(15.0),
        child: Text(
          defineText(),
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      )
    );
  } //_subscribeButton

}
