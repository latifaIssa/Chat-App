import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/helpers/firestorage_helper.dart';
import 'package:chat_app/Auth/helpers/firestore_helper.dart';
import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class UserProvider extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  AuthProvider provider;
  UserModel user, friend;

  String myId;
  List<UserModel> users = [];
  List<UserModel> recentUsers = [];

  getUserFromFirebase() async {
    String userId = AuthHelper.authHelper.getUserId();
    user = await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
    notifyListeners();
  }

  getAllUsers() async {
    users = await FirestoreHelper.firestoreHelper.getAllUsersFromFirestore();
    users.removeWhere((e) => e.id == myId);
    recentUsers.removeWhere((e) => e.id == myId);
    notifyListeners();
  }

//for update profile page
  fillControllers() {
    firstNameController.text = user.fName;
    lastNameController.text = user.lName;
    cityController.text = user.city;
    countryNameController.text = user.country;
  }

  File updatedfile;
  captureUpdateProfileImage() async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.updatedfile = File(file.path);
    notifyListeners();
  }

  updateProfile() async {
    String imageUrl;
    if (updatedfile != null) {
      imageUrl = await FirebaseStorageHelper.firebaseStorageHelper
          .uploadImage(updatedfile);
    }
    UserModel userModel = imageUrl == null
        ? UserModel(
            city: cityController.text,
            country: countryNameController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id,
          )
        : UserModel(
            city: cityController.text,
            country: countryNameController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id,
            imageUrl: imageUrl);

    await FirestoreHelper.firestoreHelper.updateProfile(userModel);
    getUserFromFirebase();
    Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop();
  }

  checkLogin() {
    bool isLoggedIn = AuthHelper.authHelper.checkUserLogin();
    if (isLoggedIn) {
      myId = AuthHelper.authHelper.getUserId();
      getAllUsers();
      RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    } else {
      RouteHelper.routeHelper.goToPageWithReplacement(LoginPage.routeName);
    }
  }

  ///for single chat
  String chatRoomID = '';
  getRoomId(UserModel friend) async {
    String userID = myId;
    this.friend = friend;
    String anotherUserID = friend.id;
    // LOGIC TO SELECT DESIRED CHAT ROOM FROM COUD FIRESTORE
    if (userID.compareTo(anotherUserID) > 0) {
      chatRoomID = '$userID - $anotherUserID';
    } else {
      chatRoomID = '$anotherUserID - $userID';
    }
    notifyListeners();
  }

  //send photo to chat
  sendImageToChat([String message]) async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    String imageUrl = await FirebaseStorageHelper.firebaseStorageHelper
        .uploadImage(File(file.path), 'chats');
    FirestoreHelper.firestoreHelper.addMessagesToFirestore({
      'dateTime': DateTime.now(),
      'content': imageUrl ?? '',
      'type': 'image',
    }, chatRoomID);
  }

  ///////////////////////////////////////////for voice
  int i = 0;
  String recordFilePath;
  bool isPlayingMsg = false, isSending = false, isRecording = false;

  sendAudioMsg(String recordFilePath) async {
    String audioMsg = await FirebaseStorageHelper.firebaseStorageHelper
        .uploadAudio(recordFilePath);
    FirestoreHelper.firestoreHelper.addMessagesToFirestore({
      'type': 'audio',
      'dateTime': DateTime.now(),
      'content': audioMsg ?? '',
    }, chatRoomID);
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath, (type) {});
      isRecording = true;
    } else {
      print('no permission');
    }
    notifyListeners();
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      isSending = true;
      sendAudioMsg(recordFilePath);
      isPlayingMsg = false;
    }
    notifyListeners();
  }

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath,
        isLocal: true,
      );
    }
    notifyListeners();
  }

  Future loadFile(String url) async {
    Uri myUri = Uri.parse(url);
    final bytes = await readBytes(myUri);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      recordFilePath = file.path;
      isPlayingMsg = true;
      print(isPlayingMsg);
      notifyListeners();

      await play();

      isPlayingMsg = false;
    }
    notifyListeners();
  }
}
