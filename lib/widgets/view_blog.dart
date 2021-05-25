import 'package:flutter/material.dart';
import 'package:links/constants/blog_post.dart';

class ViewBlog extends StatelessWidget {

  final BlogPost blog;

  ViewBlog({this.blog});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 40),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.black,
                      fontSize: 30
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).cardColor,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                    )
                  )
                ],
              ),
              Divider(height: 20, color: Theme.of(context).cardColor, thickness: 2,),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    blog.content,
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
