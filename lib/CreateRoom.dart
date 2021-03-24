import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Model.dart';
import 'AppDrawer.dart';
import 'Connector.dart' as connector;


class CreateRoom extends StatefulWidget {
  CreateRoom({Key key}): super(key: key);
  @override
  _CreateRoom createState() => _CreateRoom();
}

class _CreateRoom extends State {
  String _title;
  String _description;
  bool _private = false;
  double _maxPeople = 25;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(title: Text('Create Room')),
            drawer: AppDrawer(),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        FocusScope.of(inContext).requestFocus(FocusNode());
                        Navigator.of(inContext).pop();
                      },
                    ),
                    Spacer(),
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () {
                        if ( !_formKey.currentState.validate() ) { return; }
                        _formKey.currentState.save();
                        int maxPeople = _maxPeople.truncate();
                        connector.create(_title, _description, maxPeople, _private, model.userName, (inStatus, inRoomList) {
                          if ( inStatus == 'created' ) {
                            model.setRoomList(inRoomList);
                            FocusScope.of(inContext).requestFocus(FocusNode());
                            Navigator.of(inContext).pop();
                          } else {
                            Scaffold.of(inContext).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text('Sorry, that room already exists'),
                            ));
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.subject),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: 'Name'),
                      validator: (String inValue) {
                        if ( inValue.length == 0 || inValue.length > 14 ) {
                          return 'Please enter a name no more than 14 characters long';
                        }
                        return null;
                      },
                      onSaved: (String inValue) {
                        setState(() {
                          _title = inValue;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: 'Description'),
                      onSaved: (String inValue) {
                        setState(() {
                          _description = inValue;
                        });
                      }
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text('Max\nPeople'),
                        Slider(
                          min: 0,
                          max: 99,
                          value: _maxPeople,
                          onChanged: (double inValue) {
                            setState(() {
                              _maxPeople = inValue;
                            });
                          },
                        )
                      ],
                    ),
                    trailing: Text(_maxPeople.toStringAsFixed(0)),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text('Private'),
                        Switch(
                          value: _private,
                          onChanged: (inValue) {
                            setState(() {
                              _private = inValue;
                            });
                          }
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}