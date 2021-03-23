import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Model.dart';
import 'AppDrawer.dart';


class Home extends StatelessWidget {

  Widget build(BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model, 
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(title: Text('FlatterChat')),
            body: Center(child: Text(model.greeting??'Hello')),
          );
        }
      )
    );
  }

}