import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(40.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Nome',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0),
                  ) 
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: CircleAvatar(),
                    ),
                  ),  
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}