import 'package:bubble/bubble.dart';
import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/helpers/firestore_helper.dart';
import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/chat/pages/friend_info_page.dart';
import 'package:chat_app/chat/pages/profile_page.dart';
import 'package:chat_app/chat/widgets/Circular__image_widget.dart';
import 'package:chat_app/chat/widgets/action_bar_button.dart';
import 'package:chat_app/chat/widgets/bubble_widget.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  static final routeName = 'chat';
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String message;
  bool isMe;
  String chatId;
  UserModel friend;
  String userId = AuthHelper.authHelper.getUserId();
  TextEditingController sendController = TextEditingController();
  ScrollController scrollController = ScrollController();

  sendMessageToFirebase() async {
    sendController.clear();
    FirestoreHelper.firestoreHelper.addMessagesToFirestore({
      'type': 'message',
      'dateTime': DateTime.now(),
      'content': this.message ?? ''
    }, chatId);
  }

  void initState() {
    super.initState();
    this.chatId = Provider.of<UserProvider>(context, listen: false).chatRoomID;
    this.friend = Provider.of<UserProvider>(context, listen: false).friend;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          toolbarHeight: height * 0.1,
          actions: [
            ActionButton(
              Icons.arrow_back_ios_new,
              Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  RouteHelper.routeHelper.goToPage(FriendInfo.routeName);
                },
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircularImageWidget(friend.imageUrl),
                    ),
                    Expanded(
                        child: Text(
                      friend.fName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            ActionButton(Icons.call),
          ],
        ),
        body: Consumer<UserProvider>(builder: (context, provider, x) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirestoreHelper.firestoreHelper
                          .getFirestoreStream(chatId),
                      builder: (context, datasnapshot) {
                        if (!datasnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        Future.delayed(Duration(milliseconds: 100))
                            .then((value) {
                          //offset : for what position will move
                          //curve : movement effect
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeInOut);
                        });
                        QuerySnapshot<Map<String, dynamic>> querySnapshot =
                            datasnapshot.data;
                        List<Map> messages =
                            querySnapshot.docs.map((e) => e.data()).toList();
                        messages.sort(
                            (a, b) => a['dateTime'].compareTo(b['dateTime']));
                        return ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            // reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, i) {
                              isMe = this.userId == messages[i]['userId'];
                              return isMe
                                  ? BubbleWidget(
                                      Colors.grey[200],
                                      messages[i]['type'],
                                      messages[i],
                                      Alignment.topLeft,
                                      BubbleNip.leftBottom,
                                    )
                                  : BubbleWidget(
                                      Colors.blue,
                                      messages[i]['type'],
                                      messages[i],
                                      Alignment.topRight,
                                      BubbleNip.rightBottom,
                                    );
                            });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: provider.isRecording
                                              ? Colors.white
                                              : Colors.black12,
                                          spreadRadius: 4)
                                    ],
                                    color: Colors.blue[200],
                                    shape: BoxShape.circle),
                                child: GestureDetector(
                                  onLongPress: () {
                                    provider.startRecord();
                                    // isRecording = true;
                                  },
                                  onLongPressEnd: (details) {
                                    provider.stopRecord();

                                    // isRecording = false;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.mic,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.sendImageToChat();
                                },
                                icon: Icon(Icons.attach_file),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: sendController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (x) {
                                    this.message = x;
                                    // sendController.text = ;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            sendMessageToFirebase();
                            // _scrollToBottom();
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
