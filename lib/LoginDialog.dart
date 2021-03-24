import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Model.dart';
import 'Connector.dart' as connector;


class LoginDialog extends StatelessWidget {
  
  static final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String _userName;
  String _password;

  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model, 
      child: ScopedModelDescendant<FlutterChatModel>(
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
                    obscureText: true,
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
                    
                    model.setUserName(_userName);
                    model.setGreeting('Welcome to the server, $_userName');
                    Navigator.of(model.rootBuildContext).pop();
                    // connector.connectToServer(model.rootBuildContext, () {
                    //   connector.validate(
                    //     _userName,
                    //     _password,
                    //     (inStatus) async {
                    //       if (inStatus == 'ok') {
                    //         model.setUserName(_userName);
                    //         Navigator.of(model.rootBuildContext).pop();
                    //         model.setGreeting('Welcome back, $_userName');
                    //       } else if ( inStatus == 'fail' ) {
                    //         Scaffold.of(model.rootBuildContext).showSnackBar(
                    //           SnackBar(
                    //             backgroundColor: Colors.red,
                    //             duration: Duration(seconds: 2),
                    //             content: Text('Sorry, that username is already taken')
                    //           )
                    //         );
                    //       } else if ( inStatus == 'created') {
                    //         var credentialsFile = File(join(model.docsDir.path, 'credentials'));
                    //         await credentialsFile.writeAsString('$_userName============$_password');
                    //         model.setUserName(_userName);
                    //         Navigator.of(model.rootBuildContext).pop();
                    //         model.setGreeting('Welcome to the server, $_userName');
                    //       }
                    //     }
                    //   );
                    // });
                  }
                },
              )
            ],
          );
        }
      )
    );
  }

  void validateWithStoredCredentials(final String inUserName, final String inPassword) {
    model.setUserName(inUserName);
    model.setGreeting('Welcome back, $inUserName');
    // connector.connectToServer(model.rootBuildContext, () {
    //   connector.validate(inUserName, inPassword, (inStatus) {
    //     if ( inStatus == 'ok' || inStatus == 'created' ) {
    //       model.setUserName(inUserName);
    //       model.setGreeting('Welcome back, $inUserName');
    //     } else if ( inStatus == 'fail') {
    //       showDialog(
    //         context: model.rootBuildContext,
    //         barrierDismissible: false,
    //         builder: (final BuildContext inDialogContext) =>
    //           AlertDialog(
    //             title: Text('Validation failed'),
    //             content: Text(
    //               'It appears that the server has '
    //               'restarted and the username you last used '
    //               'was subsequently taken by someone else.'
    //               '\n\nPlease restart chat and choose '
    //               'a different name.'
    //             ),
    //             actions: [
    //               FlatButton(
    //                 child: Text('Ok'),
    //                 onPressed: () {
    //                   var credentialsFile = File(join(model.docsDir.path, 'credentials'));
    //                   credentialsFile.deleteSync();
    //                   exit(0);
    //                 },
    //               )
    //             ],
    //           )
    //       );
    //     }
    //   });
    // });
  }

}