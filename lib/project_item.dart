import 'package:lpdm_proj/models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectItem extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _numero;
  final String _rua;
  final String _bairro;
  final String _cidade;
  final String _estado;
  final String _pais;
  final String _projectId;
  final List<String> _imageList;
  final String _miniatureImage;

  ProjectItem(this._name, this._detail, this._numero, this._rua, this._bairro,
      this._cidade, this._estado, this._pais, this._projectId, this._imageList,
      this._miniatureImage);

  String get name => _name;

  String get detail => _detail;

  String get numero => _numero;

  String get rua => _rua;

  String get bairro => _bairro;

  String get cidade => _cidade;

  String get estado => _estado;

  String get pais => _pais;

  String get projectId => _projectId;

  List<String> get imageList => _imageList;

  String get miniatureImage => _miniatureImage;

  @override
  State<StatefulWidget> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Container(
            child: Card(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ProjectDetail(
                                widget._name,
                                widget._detail,
                                widget._imageList,
                                widget._projectId,
                                user.checkSubscription);
                          }),
                        );
                      },
                      child: //Padding(
                          Row(
                        children: <Widget>[
                          widget._miniatureImage == null
                              ? Icon(Icons.image, size: 80)
                              : CachedNetworkImage(
                                imageUrl: widget._miniatureImage,
                                height: 80,
                                width: 80,
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          Column(
                            children: <Widget>[
                              Text("Nome: " + widget._name),
                              widget._numero != "" ? Text("Numero: " + widget._numero) : Container(),
                              widget._rua != "" ? Text("Rua: " + widget._rua) : Container(),
                              widget._bairro != "" ? Text("Bairro: " + widget._bairro) : Container(),
                              widget._cidade != "" ? Text("Cidade: " + widget._cidade) : Container(),
                              widget._estado != "" ? Text("Estado: " + widget._estado) : Container(),
                              widget._pais != "" ? Text("Pais: " + widget._pais) : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

//tela dos detalhes de um projeto
class ProjectDetail extends StatefulWidget {
  final String _name;
  final String _detail;
  final String _projectId;
  final List<String> _imageList;
  final Function _checkUserSubscription;

  ProjectDetail(this._name, this._detail, this._imageList, this._projectId,
      this._checkUserSubscription);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  String _buttonName = 'INSCREVA-SE';
  Color _buttonColor = Colors.blue;
  Color _buttonTextColor = Colors.white;
  Widget subscribeButton;
  bool subscribed;

  @override
  void initState() {
    super.initState();
    checkSubscription(widget._checkUserSubscription);
  }

  checkSubscription(checkUserSubscription) {
    setState(() {
      subscribeButton = CircularProgressIndicator(); 
    });
    checkUserSubscription(widget._projectId).then((onValue) {
      subscribed = onValue;
      setState(() {
        if (!subscribed) {
          _buttonName = 'INSCREVA-SE';
          _buttonColor = Colors.deepPurpleAccent;
          _buttonTextColor = Colors.white;
        } else {
          //adiciona o projeto aos inscritos
          _buttonName = 'INSCRITO';
          _buttonColor = Colors.grey;
          _buttonTextColor = Colors.grey[700];
        }
        subscribeButton = _subscribeButton();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
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
                  child: widget._imageList == null ||
                          widget._imageList.length == 0
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
                                    child: CachedNetworkImage(
                                      imageUrl: widget._imageList[index],//)//Image.network(
                                      //widget._imageList[index]
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Container(
                                                child: PhotoView(
                                                  imageProvider: AdvancedNetworkImage(widget._imageList[index], useDiskCache: true),
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
                  child: subscribeButton,
                ),
              ],
            ),
          ),
    );
  }

  //botao para inscrever-se no projeto
  Widget _subscribeButton() {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => RaisedButton(
            onPressed: () {
              setState(() {subscribeButton = CircularProgressIndicator();});
              if (!subscribed) {
                user.subscribeToProject(widget._projectId).then((onValue) {
                  checkSubscription(user.checkSubscription);
                });
              } else {
                List<String> temp = [widget._projectId];
                user.unsubscribeToProjects(temp).then((onValue) {
                  checkSubscription(user.checkSubscription);
                });
              }
            },
            color: _buttonColor,
            textColor: _buttonTextColor,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              _buttonName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
    );
  } //_subscribeButton

}
