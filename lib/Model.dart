import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class FlutterChatModel extends Model {

  BuildContext rootBuildContext;
  Directory docsDir;
  String greeting;
  String userName;
  static final String DEFAULT_ROOM_NAME = 'Not currently in a room';
  String currentRoomName = DEFAULT_ROOM_NAME;
  List currentRoomUserList = [];
  bool currentRoomEnabled = false;
  List currentRoomMessages = [];
  List roomList = [];
  List userList = [];
  bool creatorFunctionsEnabled = false;
  Map roomInvites = {};

  void setGreeting(final String inGreeting) {
    greeting = inGreeting;
    notifyListeners();
  }

  void setUserName(final String inUserName) {
    userName = inUserName;
    notifyListeners();
  }

  void setCurrentRoomName(final String inCurrentRoomName) {
    currentRoomName = inCurrentRoomName;
    notifyListeners();
  }

  void setCurrentRoomEnabled(final bool inCurrentRoomEnabled) {
    currentRoomEnabled = inCurrentRoomEnabled;
    notifyListeners();
  }

  void setCreatorFunctionsEnabled(final bool inCreatorFunctionsEnabled) {
    creatorFunctionsEnabled = inCreatorFunctionsEnabled;
    notifyListeners();
  }

  void addMessage(final String inUserName, final String inMessage) {
    currentRoomMessages.add({
      'userName': inUserName,
      'message': inMessage
    });
    notifyListeners();
  }

  void setRoomList(final Map inRoomList) {
    List rooms = [];
    for (String roomName in inRoomList.keys) {
      Map room = inRoomList[roomName];
      rooms.add(room);
    }
    roomList = rooms;
    notifyListeners();
  }

  void setUserList(final Map inUserList) {
    List users = [];
    for (String userName in inUserList.keys) {
      Map user = inUserList[userName];
      users.add(user);
    }
    userList = users;
    notifyListeners();
  }

  void setCurrentRoomUserList(final Map inCurrentRoomUserList) {
    List list = [];
    for (String itemName in inCurrentRoomUserList.keys) {
      Map item = inCurrentRoomUserList[itemName];
      list.add(item);
    }
    currentRoomUserList = list;
    notifyListeners();
  }

  void addRoomInvite(final String inRoomName) {
    roomInvites[inRoomName] = true;
  }

  void removeRoomInvite(final String inRoomName) {
    roomInvites.remove(inRoomName);
  }

  void clearCurrentRoomMessages() {
    currentRoomMessages = [];
  }

}

FlutterChatModel model = FlutterChatModel();