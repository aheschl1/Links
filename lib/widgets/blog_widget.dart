import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/blog_post.dart';

class BlogWidget extends StatefulWidget {

  final BlogPost blog;
  final Function more;
  final Function delete;

  BlogWidget({this.blog, this.more, this.delete});

  @override
  _BlogWidgetState createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.blog.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                '${widget.blog.content.substring(0, 30)}...',
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Posted on ${widget.blog.date}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Posted by ${widget.blog.ownerName}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.more,
                    icon: Icon(Icons.add),
                    label: Text(
                       'See more'
                    ),
                  ),
                  widget.blog.owner == FirebaseAuth.instance.currentUser.uid ? TextButton.icon(
                    onPressed: widget.delete,
                    icon: Icon(Icons.event_busy_rounded),
                    label: Text("Delete"),
                  ) : SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatString(List x) {
    String formatted ='';
    for(var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length -2, formatted.length, '');
  }
}
