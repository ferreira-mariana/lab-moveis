import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lpdm_proj/models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<DisplayImage> _imageList = new List<DisplayImage>();

  addImage(File image) {
    if (_imageList.length < 5)
      _imageList.insert(
          _imageList.length, DisplayImage(_changeImageDialog, image));
  }

  removeImage(Widget item) {
    _imageList.remove(item);
    setState(() {
      _imageList = List.from(_imageList);
    });
  }

  changeImage(Widget item, image) {
    if (image == null) return;
    int i = _imageList.indexOf(item);
    _imageList.remove(item);
    _imageList.insert(i, DisplayImage(_changeImageDialog, image));
  }

  Future getImage(
      String select, bool isMiniature, bool isChanging, Widget item) async {
    var image;

    if (select == "Galeria") {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }

    setState(() {
      if (image != null) {
        if (isMiniature) {
          _image = image;
        } else if (isChanging) {
          changeImage(item, image);
        } else {
          addImage(image);
        }
      }
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

  void _showErrorDialog() {
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

  void _imageSourceSelectorDialog(
      bool isMiniature, bool isChanging, Widget item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Escolha"),
          actions: <Widget>[
            FlatButton(
              child: Text("Câmera"),
              onPressed: () {
                getImage("Camera", isMiniature, isChanging, item);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Galeria"),
              onPressed: () {
                getImage("Galeria", isMiniature, isChanging, item);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeImageDialog(bool isMiniature, Widget item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Escolha"),
            actions: <Widget>[
              FlatButton(
                child: Text("Mudar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _imageSourceSelectorDialog(isMiniature, true, item);
                },
              ),
              FlatButton(
                child: Text("Remover"),
                onPressed: () {
                  if (isMiniature)
                    setState(() {
                      _image = null;
                    });
                  else
                    removeImage(item);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _maxImagesErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            )
          ],
          title: Text("Erro"),
          content: Text("Número máximo de imagens atingido"),
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Selecione imagens para o projeto"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_imageList.length.toString() + "/5"),
                          NewImageButton(_imageSourceSelectorDialog, _imageList,
                              _maxImagesErrorDialog),
                        ],
                      ),
                      _imageList.length > 0
                          ? Container(
                              //decoration: BoxDecoration(border: Border.all()),
                              margin: EdgeInsets.all(5),
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          _imageList[index],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                  Column(
                    children: <Widget>[
                      Text("Selecione uma miniatura"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _image != null
                                ? Image(
                                    image: FileImage(_image),
                                    height: 80,
                                    width: 80,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 80,
                                  ),
                            FlatButton(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.add),
                                ),
                              ),
                              onPressed: () {
                                _image == null
                                    ? _imageSourceSelectorDialog(
                                        true, true, null)
                                    : _changeImageDialog(true, null);
                              },
                            ),
                          ],
                        ),
                      ),
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
                      color: Theme.of(context).primaryColor,
                      child: Text("Enviar", style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        if (_nameText != '' &&
                            _descriptionText != '' &&
                            _stateText != '' &&
                            _cityText != '') {
                          List<File> imageFileList = new List<File>();
                          for (DisplayImage image in _imageList) {
                            imageFileList.add(image.image);
                          }
                          data.addProject(_nameText, _cityText, _stateText, _descriptionText, _image, _imageList);
                          Navigator.of(context).pop();
                        } else {
                          _showErrorDialog();
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
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(20)),
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

class DisplayImage extends StatefulWidget {
  final Function changeImageDialog;
  final File _image;

  DisplayImage(this.changeImageDialog, this._image);

  File get image => _image;

  @override
  State<StatefulWidget> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => widget.changeImageDialog(false, widget),
      child: Image(
        image: FileImage(widget.image),
      ),
    );
  }
}

class NewImageButton extends StatelessWidget {
  final Function addImage;
  final Function errorDialog;
  final List<DisplayImage> list;

  NewImageButton(this.addImage, this.list, this.errorDialog);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (list.length < 5)
          addImage(false, false, null);
        else
          errorDialog();
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
