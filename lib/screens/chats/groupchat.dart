import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/message.dart';
import 'package:links/screens/loading.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/message_view.dart';

class Groupchat extends StatefulWidget {

  @override
  _GroupchatState createState() => _GroupchatState();
}

class _GroupchatState extends State<Groupchat> {

  Event event;
  Group group;
  TextEditingController messageController = TextEditingController();
  FriendData me;

  sendMessage() async {
    String content = messageController.text;
    Message message = Message(
      content: content,
      senderDisplayName: me.name,
      senderUid: me.userId,
      timeStamp: DateTime.now().millisecondsSinceEpoch
    );
    bool sent = await DatabaseService().sendMessageToGroupChat(
      message: message,
      groupchatId: event == null ? group.groupchatId : event.groupChatEnabledID
    );

    if(!sent){
      final snackBar = SnackBar(content: Text("Something went wrong"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      messageController.text = "";
    }

  }

  getMyUserData() async {
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser.uid));
    me.userId = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {

    getMyUserData();
    try{
      event = ModalRoute.of(context).settings.arguments as Event;
    }catch(e){
      group = ModalRoute.of(context).settings.arguments as Group;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().streamGroupchat(event == null ? group.groupchatId : event.groupChatEnabledID),
      builder: (context,  AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("Something went wrong");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("${event == null ? group.name : event.title} group chat"),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    Message message = Message.fromMap(snapshot.data.docs[index].data());
                    return MessageView(message: message,);
                  },
                ),
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(0.0),
                    ),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.white, width: 0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(0.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon:Icon(Icons.send),
                    onPressed: ()=>sendMessage(),
                    color: Colors.black,
                  ),
                ),
                controller: messageController,
              )
            ],
          ),
        );

      }
    );
  }
}
