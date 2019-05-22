import 'package:flutter/material.dart';
import 'package:lpdm_proj/models.dart';
import 'package:scoped_model/scoped_model.dart';

class ConfigPage extends StatelessWidget {
  build(context) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, config) => Scaffold(
            appBar: AppBar(title: Text("Configurações")),
            body: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor))),
                  child: ListTile(
                    onTap: () {
                      config.changeBrightness();
                    },
                    title: Text("Modo noturno on/off"),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
