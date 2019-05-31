import 'dart:async';

import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lpdm_proj/models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lpdm_proj/custom_route.dart';

class ProjectItem extends StatefulWidget {
  final String _placeid;
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
      this._placeid,
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

  String get placeid => _placeid;

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
                          CustomRoute(builder: (context) {
                            return ProjectDetail(
                                widget._placeid,
                                widget._name,
                                widget._detail,
                                widget._imageList,
                                widget._projectId,
                                user.checkSubscription);
                          }),
                        );
                      },
                      child: Row(
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
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Nome: " + widget._name),
                                  widget._numero != ""
                                      ? Text("Numero: " + widget._numero)
                                      : Container(),
                                  widget._rua != ""
                                      ? Text("Rua: " + widget._rua)
                                      : Container(),
                                  widget._bairro != ""
                                      ? Text("Bairro: " + widget._bairro)
                                      : Container(),
                                  widget._cidade != ""
                                      ? Text("Cidade: " + widget._cidade)
                                      : Container(),
                                  widget._estado != ""
                                      ? Text("Estado: " + widget._estado)
                                      : Container(),
                                  widget._pais != ""
                                      ? Text("Pais: " + widget._pais)
                                      : Container(),
                                ],
                              ),
                            ),
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
  final String _placeid;
  final String _name;
  final String _detail;
  final String _projectId;
  final List<String> _imageList;
  final Function _checkUserSubscription;

  ProjectDetail(this._placeid, this._name, this._detail, this._imageList,
      this._projectId, this._checkUserSubscription);

  @override
  _ProjectDetailState createState() => new _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> with TickerProviderStateMixin{
  bool subscribed = false;
  AnimationController _controle;

  @override
  void initState() {
    super.initState();
    checkSubscription(widget._checkUserSubscription);
    //initGoogleMap();
    _controle = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
  }

  checkSubscription(checkUserSubscription) {
    checkUserSubscription(widget._projectId).then((onValue) {
      subscribed = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, user) => Scaffold(
          body: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget._name),
                    background: ListView(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            child: widget._imageList == null ||
                                widget._imageList.length == 0
                                ? Center(
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'assets/default.jpg',
                                          )
                                      )
                                  ),
                                )
                            )
                                : SizedBox(
                              height: 250,
                              width: 350,
                              child:
                              ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget._imageList.length,
                                itemBuilder: (BuildContext context, int index) =>
                                    FlatButton(
                                        child: Container(
                                          width: 350,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(
                                                    widget._imageList[
                                                    index],
                                                  )
                                              )
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CustomRoute(
                                              builder: (context) => Container(
                                                child: PhotoView(
                                                  imageProvider:
                                                  AdvancedNetworkImage(
                                                      widget._imageList[
                                                      index],
                                                      useDiskCache: true
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                              ),
                            ),
                          )
                        ]
                    )
                )
            ),
            SliverList(delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Text(
                  widget._detail,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Center(
                child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      "Ver no mapa",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CustomRoute(builder: (context) {
                          return GoogleMapView(
                            widget._placeid,
                          );
                        }),
                      );
                    }
                ),
              ),
            ],),)
          ]),
          floatingActionButton: _customFloatingActionButton(),
        )
    );
  }

  //botao para inscrever-se no projeto
  Widget _customFloatingActionButton() {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, user) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container (
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition(
                      scale: CurvedAnimation(
                          parent: _controle,
                          curve: Interval(0.0, 1.0, curve: Curves.easeOut)
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).cardColor,
                        heroTag: 'extra',
                        mini: true,
                        onPressed: () {},
                        child: Icon(Icons.clear, color: Colors.black),
                      )
                  )
              ),

              Container (
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition (
                    scale: CurvedAnimation(
                        parent: _controle,
                        curve: Interval(0.0, 0.5, curve: Curves.easeOut)
                    ),
                    child: FloatingActionButton(
                        backgroundColor: Theme.of(context).cardColor,
                        heroTag: 'inscricao',
                        mini: true,
                        onPressed: () {///*
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
//*/
                        },
                        child: Icon(
                            subscribed
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red)
                    ),
                  )
              ),
              Container (
                  child: FloatingActionButton(
                      heroTag: 'opcoes',
                      onPressed: () {
                        if (_controle.isDismissed) {
                          _controle.forward();
                        } else {
                          _controle.reverse();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _controle,
                        builder: (BuildContext context, Widget child) {
                          return Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.rotationZ(_controle.value * 0.5 * math.pi),
                              child: Icon(_controle.isDismissed ? Icons.more_vert : Icons.close)
                          );
                        },
                      )
                  )
              )
            ]
        )
    );
  }
}

class GoogleMapView extends StatefulWidget {
  final String _placeid;

  GoogleMapView(this._placeid);

  @override
  State<StatefulWidget> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  static const kGoogleApiKey = "AIzaSyCe-T7VrbtVqCLBNrgt1A0kxeTwnqFFKNA";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  Completer<GoogleMapController> _controller = Completer();
  LatLng position;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0, 0));
  Set<Marker> markerSet;

  void initGoogleMap() async {
    markerSet = new Set<Marker>();
    var addressDetail = await _places.getDetailsByPlaceId(widget._placeid);
    position = LatLng(addressDetail.result.geometry.location.lat,
        addressDetail.result.geometry.location.lng);

    _cameraPosition = CameraPosition(
      target: position,
      zoom: 16.0,
    );

    markerSet.add(
      Marker(markerId: MarkerId('0'), position: position),
    );

    setState(() => markerSet = Set.from(markerSet));

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      body: GoogleMap(
        markers: markerSet,
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          initGoogleMap();
        },
      ),
    );
  }
}
