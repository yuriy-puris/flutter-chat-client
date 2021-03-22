import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Model.dart';
import 'Connector.dart' as connector;

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    model.docsDir = docsDir;
    var credentialsFile = File(join(model.docsDir.path, 'credentials'));
    var exists = await credentialsFile.exists();
    var credentials;
    if ( exists ) {
      credentials = await credentialsFile.readAsString();
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
    runApp(FlutterChat());
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
              "/Lobby": (screenContext) => Lobby(),
              "/Room": (screenContext) => Room(),
              "/UserList": (screenContext) => UserList(),
              "/CreateRoom": (screenContext) => CreateRoom(),
            },
            home: Home(),
          );
        }
      ),
    );
  }
}

class LoginDialog extends StatelessWidget {
  
  static final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String _userName;
  String _password;

  Widget build(final BuildContext inContext) {
    return ScopedModel(
      model: model, 
      child: ScopedModelDescendant(
        builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
          return AlertDialog(
            content: Container(
              height: 220,
              child: Form(
                key: _loginFormKey,
                child: Column(
                children: [
                  Text(
                    'Enter a username and password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(model.rootBuildContext).accentColor,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (String inValue) {
                      if ( inValue.length == 0 || inValue.length > 10 ) {
                        return 'Please enter a username no more than 10 characters long';
                      }
                      return null;
                    },
                    onSaved: (String inValue) { 
                      _userName = inValue;
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      labelText: 'Username'
                    ),
                  ),
                  TextFormField(
                    validator: (String inValue) {
                      if ( inValue.length == 0 ) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (String inValue) {
                      _password = inValue;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password'
                    ),
                  ),
                ],
              ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Log In'),
                onPressed: () {
                  if (_loginFormKey.currentState.validate()) {
                    _loginFormKey.currentState.save();
                    connector.connectToServer(model.rootBuildContext, () {
                      connector.validate(
                        _userName,
                        _password,
                        (inStatus) async {
                          if (inStatus == 'ok') {
                            model.setUserName(_userName);
                            Navigator.of(model.rootBuildContext).pop();
                            model.setGreeting('Welcome back, $_userName');
                          } else if ( inStatus == 'fail' ) {
                            Scaffold.of(model.rootBuildContext).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                content: Text('Sorry, that username is already taken')
                              )
                            );
                          } else if ( inStatus == 'created') {
                            var credentialsFile = File(join(model.docsDir.path, 'credentials'));
                            await credentialsFile.writeAsString('$_userName============$_password');
                            model.setUserName(_userName);
                            Navigator.of(model.rootBuildContext).pop();
                            model.setGreeting('Welcome to the server, $_userName');
                          }
                        }
                      );
                    });
                  }
                },
              )
            ],
          );
        }
      )
    );
  }

}