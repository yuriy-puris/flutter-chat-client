import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Model.dart';
import 'AppDrawer.dart';
import 'Connector.dart' as connector;


class Room extends StatefulWidget {
  Room({ Key key }): super(key: key);
  @override
  _Room createState() => _Room();
}

class _Room extends State {
  bool _expanded = false;
  String _postMessage;
  final ScrollController _controller = ScrollController();
  final TextEditingController _postEditingController = TextEditingController();

  Widget build(final BuildContext inContext) {
    return ScopedModel(
      model: model, 
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text(model.currentRoomName),
              actions: [
                PopupMenuButton(
                  onSelected: (inValue) {
                    if ( inValue == 'invite' ) {
                      _inviteOrKick(inContext, 'invite');
                    } else if ( inValue == 'leave' ) {
                      connector.leave(model)
                    }
                  },
                )
              ],
            ),
          );
        }
      )
    );
  }
}