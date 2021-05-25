import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:links/constants/message.dart';

class MessageView extends StatefulWidget {

  final Message message;
  MessageView({this.message});

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {

  String formatDate(DateTime dateTime){
    final DateFormat formatter = DateFormat('LLLL d H:m');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Divider(height: 20,),
          Text(
            formatDate(DateTime.fromMillisecondsSinceEpoch(widget.message.timeStamp)),
            style: TextStyle(
              color: Colors.grey
            ),
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.message.senderUid != FirebaseAuth.instance.currentUser.uid ? widget.message.senderDisplayName : "Me" } : " ,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 15,),
              Flexible(
                child: Text(
                  widget.message.content,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
