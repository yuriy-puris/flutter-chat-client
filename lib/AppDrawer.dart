import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Model.dart';
import 'Connector.dart' as connector;


class AppDrawer extends StatelessWidget {

  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return Drawer(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/drawback01.png'))
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 15),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Center(
                          child: Text(
                            model.userName,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          model.currentRoomName, 
                          style: TextStyle(color: Colors.white, fontSize: 16)
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      //   child: ListTile(
                      //     leading: Icon(Icons.list),
                      //     title: Text('Lobby'),
                      //     onTap: () {
                      //       Navigator.of(inContext).pushNamedAndRemoveUntil('/Lobby', ModalRoute.withName('/'));
                      //       connector.listRooms((inRoomList) { model.setRoomList(inRoomList); });
                      //     },
                      //   ),
                      // )
                    ),
                  ),
                )
              ],
            )
          );
        }
      )
    );
  }

}