import 'package:flutter/material.dart';
import 'project_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lpdm_proj/models.dart';

class DeleteProjectPage extends StatefulWidget {
  final List<ProjectItem> list;

  DeleteProjectPage(this.list);

  @override
  State<StatefulWidget> createState() => _DeleteProjectPage();
}

class _DeleteProjectPage extends State<DeleteProjectPage> {
  List<ProjectItemWithCheckbox> _list = new List<ProjectItemWithCheckbox>();

  @override
  void initState() {
    for (ProjectItem proj in widget.list) {
      _list.add(ProjectItemWithCheckbox(proj));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, user) => Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    List<String> temp = new List<String>();
                    for (ProjectItemWithCheckbox proj in _list) {
                      if (proj.isChecked()) temp.add(proj.item.projectId);
                    }
                    user.unsubscribeToProjects(temp);
                    Navigator.of(context).pop();
                  },
                )
              ],
              title: Text("Deletar Projetos"),
            ),
            body: ListView(
              children: _list,
            ),
          ),
    );
  }
}

class ProjectItemWithCheckbox extends StatefulWidget {
  final ProjectItem item;
  bool checked = false;

  ProjectItemWithCheckbox(this.item);

  bool isChecked() => checked;

  ProjectItem getItem() => item;

  @override
  State<StatefulWidget> createState() => _ProjectItemWithCheckboxState();
}

class _ProjectItemWithCheckboxState extends State<ProjectItemWithCheckbox> {
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
            Flexible(
              child: widget.item,
            ),
            Checkbox(
              value: widget.checked,
              onChanged: (bool change) {
                _checkBoxChange(change);
              },
              checkColor: Colors.white,
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
