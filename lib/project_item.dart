import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lpdm_proj/models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectItem extends StatefulWidget {
  final String _placeId;
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

  ProjectItem(
      this._placeId,
      this._name,
      this._detail,
      this._numero,
      this._rua,
      this._bairro,
      this._cidade,
      this._estado,
      this._pais,
      this._projectId,
      this._imageList,
      this._miniatureImage);

  String get name => _name;

  String get detail => _detail;

  String get numero => _numero;

  String get rua => _rua;

  String get bairro => _bairro;

  String get cidade => _cidade;

  String get estado => _estado;

  String get pais => _pais;

  String get placeid => _placeId;

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
                                widget._placeId,
                                widget._name,
                                widget._detail,
                                widget._imageList,
                                widget._projectId,
                                user.checkSubscription,
                                user.checkCreation);
                          }),
                        );
                      },
                      child: SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            widget._miniatureImage == null
                                ? Icon(Icons.image, size: 80)
                                : CachedNetworkImage(
                                    placeholder: (context, string) =>
                                        CircularProgressIndicator(),
                                    fadeInDuration: Duration(seconds: 3),
                                    fadeOutDuration: Duration(seconds: 2),
                                    imageUrl: widget._miniatureImage,
                                    height: 80,
                                    width: 80,
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Nome: " + widget._name,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                      widget._numero != ""
                                          ? Text(
                                              "Numero: " + widget._numero,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                      widget._rua != ""
                                          ? Text(
                                              "Rua: " + widget._rua,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                      widget._bairro != ""
                                          ? Text(
                                              "Bairro: " + widget._bairro,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                      widget._cidade != ""
                                          ? Text(
                                              "Cidade: " + widget._cidade,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                      widget._estado != ""
                                          ? Text(
                                              "Estado: " + widget._estado,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                      widget._pais != ""
                                          ? Text(
                                              "Pais: " + widget._pais,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
  final String _placeId;
  final String _name;
  final String _detail;
  final String _projectId;
  final List<String> _imageList;
  final Function _checkUserSubscription;
  final Function _checkUserCreation;

  ProjectDetail(this._placeId, this._name, this._detail, this._imageList,
      this._projectId, this._checkUserSubscription, this._checkUserCreation);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  static const kGoogleApiKey = "AIzaSyCe-T7VrbtVqCLBNrgt1A0kxeTwnqFFKNA";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  String _buttonName = 'INSCREVA-SE';
  Color _buttonColor = Colors.blue;
  Color _buttonTextColor = Colors.white;
  Widget subscribeButton;
  bool subscribed;
  bool creator = false;
  Completer<GoogleMapController> _controller = Completer();
  LatLng position;
  CameraPosition _cameraPosition;
  Set<Marker> markerSet;

  @override
  void initState() {
    super.initState();
    position = LatLng(0, 0);
    _cameraPosition = new CameraPosition(target: position);
    checkSubscription(widget._checkUserSubscription);
    checkCreation(widget._checkUserCreation);
    //initGoogleMap();
  }

  void initGoogleMap() async {
    markerSet = new Set<Marker>();
    var addressDetail = await _places.getDetailsByPlaceId(widget._placeId);
    position = LatLng(addressDetail.result.geometry.location.lat,
        addressDetail.result.geometry.location.lng);

    _cameraPosition = CameraPosition(
      target: position,
      zoom: 16.0,
    );

    markerSet.add(
      Marker(markerId: MarkerId('0'), position: position),
    );

    setState(() {
      markerSet = Set.from(markerSet);
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  checkCreation(checkUserCreation) {
    checkUserCreation(widget._projectId).then((onValue) {
      setState(() {
        creator = onValue;
      });
    });
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
      builder: (context, child, user) => ScopedModelDescendant<DataModel>(
      builder: (context, child, data) => Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                creator == true ? FlatButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Ok"),
                          )
                        ],
                        title: Text("Não implementado"),
                        content: Text("A exclusão de projetos ainda não funciona pois não sei como fazer deletar o projeto de todos os usuários inscritos"),
                      );
                    });
                    /*data.deleteProject(widget._projectId);
                    user.updateUserProjects();
                    Navigator.of(context).pop();*/
                  },
                ) : Container(),
              ],
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
                                    imageUrl: widget
                                        ._imageList[index], //)//Image.network(
                                    //widget._imageList[index]
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Container(
                                              child: PhotoView(
                                                imageProvider:
                                                    AdvancedNetworkImage(
                                                        widget
                                                            ._imageList[index],
                                                        useDiskCache: true),
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ),
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
                SizedBox(
                  width: 100,
                  height: 200,
                  child: GoogleMap(
                    markers: markerSet,
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      initGoogleMap();
                    },
                  ),
                ),
                Center(
                  child: subscribeButton,
                ),
              ],
            ),
          ),
      ),);
  }

  //botao para inscrever-se no projeto
  Widget _subscribeButton() {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => RaisedButton(
            onPressed: () {
              setState(() {
                subscribeButton = CircularProgressIndicator();
              });
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
