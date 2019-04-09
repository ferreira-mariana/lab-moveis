import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget{
  build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações")
      ),
      body: Center(
        child: RaisedButton(
          onPressed: (){},
          child: Text("botao"),
        ),
      ),
    );
  }
}