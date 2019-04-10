import 'package:flutter/material.dart';
import 'project_item.dart';

class DeleteProjectsScreen extends StatefulWidget {
  List<ProjectItem> list;
  Function updateMainList;

  DeleteProjectsScreen(this.list, this.updateMainList);

  @override
  State<StatefulWidget> createState() => _DeleteProjectsScreen();
}

class _DeleteProjectsScreen extends State<DeleteProjectsScreen>{
  List<ProjectItemWithCheckbox> _list = new List<ProjectItemWithCheckbox>();
  @override
  void initState() {
    for (ProjectItem proj in widget.list){
      _list.add(ProjectItemWithCheckbox(proj));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.delete),
            onPressed: (){
              for (ProjectItemWithCheckbox proj in _list){
                if(proj.isChecked()) widget.list.remove(proj.item);
              }
              widget.updateMainList();
              Navigator.of(context).pop();
            },
          )
        ],
        title: Text("Deletar Projetos"),
      ),
      body: ListView(
        children: _list,
      ),
    );
  }
}

class ProjectItemWithCheckbox extends StatefulWidget{
  ProjectItem item;
  bool checked = false;

  ProjectItemWithCheckbox(this.item);

  bool isChecked() => checked;

  ProjectItem getItem() => item;

  @override
  State<StatefulWidget> createState() => _ProjectItemWithCheckboxState();
}

class _ProjectItemWithCheckboxState extends State<ProjectItemWithCheckbox>{
  void _checkBoxChange(bool change) {
    setState(() {
      widget.checked = change;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(child:
              widget.item,
            ),
            Checkbox(
              value: widget.checked,
              onChanged: (bool change) {
                _checkBoxChange(change);
              },
              checkColor: Colors.white,
              activeColor: Theme.of(context).buttonColor,
            ),
          ],
        ),
      ),
    );
  }

}
