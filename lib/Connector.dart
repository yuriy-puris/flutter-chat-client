import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:socket_io/socket_io.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_socket_io/socket_io_manager.dart';

import 'Model.dart';

String serverURL = 'http://127.0.0.1:3000';

SocketIO _io;

// Socket socket;
// var io = new Server();

void showPleaseWait() {
  showDialog(
    context: model.rootBuildContext,
    barrierDismissible: false,
    builder: (BuildContext inDialogContext) {
      return Dialog(
        child: Container(
          width: 150,
          height: 150,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(color: Colors.blue[200]),
        ),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              value: null,
              strokeWidth: 10,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Please wait, contacting server ...',
              style: new TextStyle(color: Colors.white)
            ),
          ),
        )
      ],
    )
  );
}

void hidePleaseWait() {
  Navigator.of(model.rootBuildContext).pop();
}

void connectToServer(final BuildContext inMainBuildContext, final Function inCallback) {
  _io = SocketIOManager().createSocketIO(
    serverURL,
    '/',
    query: '',
    socketStatusCallback: (inData) {
      if ( inData == 'connect' ) {
        _io.subscribe('newUser', newUser);
        _io.subscribe('created', created);
        _io.subscribe('closed', closed);
        _io.subscribe('joined', joined);
        _io.subscribe('left', left);
        _io.subscribe('kicked', kicked);
        _io.subscribe('invited', invited);
        _io.subscribe('posted', posted);
      }
    }
  );
  _io.init();
  _io.connect();
    // socket = io('http://127.0.0.1:3000', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    
    // // Connect to websocket
    // socket.connect();
}

void newUser(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  model.setUserList(payload);
}

void created(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  model.setRoomList(payload);
}

void closed(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  model.setRoomList(payload);
  if ( payload['roomName'] == model.currentRoomName ) {
    model.removeRoomInvite(payload['roomName']);
    model.setCurrentRoomUserList({});
    model.setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME);
    model.setCurrentRoomEnabled(false);
    model.setGreeting('The room you were in was closed by its creator.');
    Navigator.of(model.rootBuildContext).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
  }
}

void joined(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  if ( payload['roomName'] == model.currentRoomName ) {
    model.setCurrentRoomUserList(payload['users']);
  }
}

void left(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  if ( payload['roomName'] == model.currentRoomName ) {
    model.currentRoomUserList.remove(payload['users']);
  }
}

void kicked(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  model.setRoomList(payload);
  if ( payload['roomName'] == model.currentRoomName ) {
    model.removeRoomInvite(payload['roomName']);
    model.setCurrentRoomUserList({});
    model.setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME);
    model.setCurrentRoomEnabled(false);
    model.setGreeting('You have kicked from the room.');
    Navigator.of(model.rootBuildContext).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
  }
}
void invited(inData) async {
  Map<String, dynamic> payload = jsonDecode(inData);
  String roomName = payload['roomName'];
  String inviterName = payload['inviterName'];
  model.addRoomInvite(roomName);
  Scaffold.of(model.rootBuildContext).showSnackBar(
    SnackBar(
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 60),
      content: Text(
        "You've been invited to the room"
        "'$roomName' by user '$inviterName'. \n\n"
        "You can enter the room from the lobby."
      ),
      action: SnackBarAction(label: 'Ok', onPressed: () {}),
    )
  );
}

void join(final String inUserName, final String inRoomName, final Function inCallback) {

}

void create(final String inTitle, final String inDescription, int inMaxPeople, bool inPrivate, final String inUserName, final Function inCallback) {

}

void leave(final String inUserName, final String inRoomName, final Function inCallback) {

}

void posted(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  if ( payload['roomName'] == model.currentRoomName ) {
    model.addMessage(payload['userName'], payload['message']);
  }
}

void validate(final String inUserName, final String inPassword, final Function inCallback) {
  showPleaseWait();
  _io.sendMessage(
    'validate',
    "{ \"userName\": \"$inUserName\", "
    " \"password\": \"$inPassword\" }",
    (inData) {
      Map<String, dynamic> response = jsonDecode(inData);
      hidePleaseWait();
      inCallback(response['status']);
    }
  );
}

void listRooms(final Function inCallback) {
  showPleaseWait();
  _io.sendMessage(
    'listRooms',
    '{}',
    (inData) {
      Map<String, dynamic> response = jsonDecode(inData);
      hidePleaseWait();
      inCallback(response);
    }
  );
}

