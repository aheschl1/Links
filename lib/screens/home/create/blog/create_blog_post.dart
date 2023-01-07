import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:links/constants/blog_post.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/services/database_service.dart';

class CreateBlog extends StatefulWidget {

  final Group group;

  CreateBlog({required this.group});

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  FriendData? me;
  DateTime dateTime = DateTime.now();

  save() async {
    if(_formKey.currentState!.validate()){
      String format = DateFormat.yMMMEd().format(dateTime);
      BlogPost blogPost = BlogPost(
        title: title,
        content: content,
        ownerName: me!.name,
        owner: FirebaseAuth.instance.currentUser!.uid,
        date: format,
      );
      String? result = await DatabaseService().createBlogPost(widget.group, blogPost);
      final snackBar = SnackBar(
        content: Text(result != null ? "Blog posted" : "Something went wrong"),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    getMe();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Blog'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20,),
              TextFormField(
                style: TextStyle(color: Colors.black),
                validator: (text){
                  if(text!.length == 0){
                    return 'Enter a title';
                  }
                  return null;
                },
                onChanged: (val){
                  setState(() {
                    title = val;
                  });
                },
                decoration: Decorations(context: context).getTitleInput("Title"),
              ),
              SizedBox(height: 3,),
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  minLines: 100,
                  maxLines: 100,
                  validator: (text){
                    if(text!.length < 30){
                      return 'Enter at least 30 characters';
                    }
                    return null;
                  },
                  decoration: Decorations(context: context).getTitleInput("Content"),
                  onChanged: (val){
                    setState(() {
                      content = val;
                    });
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: ()=>save(),
                icon: Icon(Icons.check),
                label: Text("Post"),
              )
            ],
          ),
        ),
      ),

    );

  }
}
