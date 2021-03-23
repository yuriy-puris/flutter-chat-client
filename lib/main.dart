import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Model.dart';
import 'Connector.dart' as connector;
import 'Home.dart';
import 'LoginDialog.dart';

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory docsDir = await getApplicationDocumentsDirectory();
    model.docsDir = docsDir;

    runApp(FlutterChat());

    var credentialsFile = File(join(model.docsDir.path, 'credentials'));
    var exists = await credentialsFile.exists();
    var credentials;
    if ( exists ) {
      credentials = await credentialsFile.readAsString();
    } 
    
    if ( exists ) {
      List credParts = credentials.split('============');
      LoginDialog().validateWithStoredCredentials(credParts[0], credParts[1]);
    } else {
      await showDialog(
        context: model.rootBuildContext,
        barrierDismissible: false,
        builder: (BuildContext inDialogContext) {
          return LoginDialog();
        }
      );
    }
  }
  startMeUp();
}

class FlutterChat extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: FlutterChatMain())
    );
  }
}

class FlutterChatMain extends StatelessWidget {
  @override
  Widget build(final BuildContext inContext) {
    model.rootBuildContext = inContext;
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return MaterialApp(
            initialRoute: '/',
            routes: {
              // "/Lobby": (screenContext) => Lobby(),
              // "/Room": (screenContext) => Room(),
              // "/UserList": (screenContext) => UserList(),
              // "/CreateRoom": (screenContext) => CreateRoom(),
            },
            home: Home(),
          );
        }
      ),
    );
  }
}