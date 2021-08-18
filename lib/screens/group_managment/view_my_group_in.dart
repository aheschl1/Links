
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/blog_post.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/request.dart';
import 'package:links/screens/group_managment/view_users.dart';
import 'package:links/screens/home/create/blog/create_blog_post.dart';
import 'package:links/screens/home/create/event/create.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/blog_widget.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/widgets/expandable_fab.dart';
import 'package:links/widgets/group_widget.dart';
import 'package:links/widgets/request_view.dart';
import 'package:links/widgets/view_blog.dart';

class ViewMyGroupIn extends StatefulWidget {

  final Group group;

  ViewMyGroupIn({this.group});

  @override
  _ViewMyGroupInState createState() => _ViewMyGroupInState();
}

class _ViewMyGroupInState extends State<ViewMyGroupIn> {
  FriendData me;
  final key = GlobalKey<AnimatedListState>();
  viewFriendProfile(FriendData friendData){
    Navigator.of(context).pushNamed('/view_profile', arguments: friendData);
  }

  createNewEvent() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context)=>Scaffold(

          appBar: AppBar(
            title: Text("Create event for group"),
          ),
          body: Create(group: widget.group,),
        )
    ).then((value) {
      setState(() {

      });
    });
  }


  createNewBlogPost() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context)=>CreateBlog(group: widget.group,),

    ).then((value) {
      setState(() {

      });
    });
  }

  viewPeople(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return ViewUsers(
            group: widget.group,
            onTap: viewFriendProfile,
          );
        }
    );
  }

  openGroupchat(){
    Navigator.of(context).pushNamed('/groupchat', arguments: widget.group);
  }

  notInterestedInEvent(Event event) async{
    String result = await DatabaseService().notInterested(event);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }


  openEvent(Event event){
    Navigator.of(context).pushNamed("/view_event", arguments:  event);
  }

  deleteEvent(Event event) async {
    bool delete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to delete this event?'),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true);// dismisses only the dialog and returns true
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if(delete){
      String result = await DatabaseService().deleteEventInGroup(event, widget.group);
      if(result == "Deleted successfully"){
        if(event.groupChatEnabledID != null){
          FirebaseMessaging.instance.unsubscribeFromTopic(event.groupChatEnabledID);
        }
      }
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }

  }

  leaveEvent(Event event) async {
    bool leave = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to leave this event?'),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true);// dismisses only the dialog and returns true
              },
              child: Text('Leave'),
            ),
          ],
        );
      },
    );

    if(leave){
      String result = await DatabaseService().leaveEventInGroup(event.docId, widget.group);
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }
  }



  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser.uid));
  }

  joinEvent(Event event) async {
    String result;

    if(double.parse(event.admissionPrice) > 0){
      Navigator.of(context).pushNamed("/payments", arguments: event);
    }else{
      if(!event.requireConfirmation){
        result = await DatabaseService().joinGroupEvent(event, widget.group);
      }else{
        Request request = Request(userId: FirebaseAuth.instance.currentUser.uid, decision: Request.PENDING, userEmail: me.email, userName: me.name);
        result = await DatabaseService().requestToJoinGroupEvent(event, request, widget.group);
      }

      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,

      );

    }

  }

  dismissRequest(Request request) async {
    String result = await DatabaseService().agknoledgeRequestDecisionGE(request);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {

    });
  }

  viewBlog(BlogPost post){
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return ViewBlog(blog: post,);
        }
    );
  }

  deleteBlog(BlogPost blog) async {
    String result = await DatabaseService().deleteBlogPost(widget.group, blog);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {

    getMe();

    return Scaffold(
      appBar: AppBar(
        title: Text('Viewing ${widget.group.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: ()=>viewPeople(),
            tooltip: "View People",
          )
        ],
      ),
      floatingActionButton: widget.group.anyoneCanPost ? ExpandableFab(
        distance: 112.0,
        initialOpen: false,
        children: [
          ActionButton(
            icon: Icon(Icons.event),
            onPressed: ()=>createNewEvent(),
          ),
          ActionButton(
            icon: Icon(Icons.description_outlined),
            onPressed: ()=>createNewBlogPost(),
          )
        ],
      ) : null,
      body: Column(
        children: [
          GroupMyPage(widget.group),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.group),
                label: Text("Group chat"),
                onPressed: widget.group.groupchatId == null ? null : (){openGroupchat();},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    return Colors.blueGrey;
                  },),
                )
              ),
            ),
          ),
          ExpansionTile(
              leading: Icon(Icons.event),
              title: Text("Upcoming events"),
              children: [
                FutureBuilder<List<Event>>(
                  future: DatabaseService().getEventsInGroup(widget.group),
                  builder: (context, snapshot){
                    if(snapshot.connectionState != ConnectionState.done){
                      return SizedBox(height: 100, child: SpinKitFoldingCube(color: Colors.white,),);
                    }

                    if(snapshot.data.length == 0){
                      return TextButton.icon(label: Text("There are no upcoming events in this group"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                      });},);
                    }

                    print(snapshot.data);

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          Event event = snapshot.data[index];
                          User user = FirebaseAuth.instance.currentUser;
                          if(event.owner == user.uid){
                            return MyEventWidget(event: event, more: ()=> openEvent(event), deleteEvent: ()=> deleteEvent(event),);
                          }else if(!(event.usersIn == null) && event.usersIn.contains(user.uid)){
                            return MyEventIn(
                              event: event,
                              more: ()=>openEvent(event),
                              leaveEvent: ()=>leaveEvent(event),
                            );
                          }else{
                            return EventWidget(
                              event: event,
                              notInterested: ()=>notInterestedInEvent(event),
                              join: ()=>joinEvent(event),
                            );
                          }

                        },
                      ),
                    );

                  },
                )
              ]
          ),
          ExpansionTile(
              leading: Icon(Icons.timer),
              title: Text("Pending event requests"),
              children: [
                FutureBuilder<List<Request>>(
                  future: DatabaseService().getRequestsGEPending(widget.group),
                  builder: (context, snapshot){
                    if(snapshot.connectionState != ConnectionState.done){
                      return SizedBox(height: 100, child: SpinKitFoldingCube(color: Colors.white,),);
                    }

                    if(snapshot.data.length == 0){
                      return TextButton.icon(label: Text("There are no upcoming events in this group"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                      });},);
                    }

                    print(snapshot.data);

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          Request request = snapshot.data[index];
                          return ViewRequest(
                            ok: ()=>dismissRequest(request),
                            request: request,
                          );

                        },
                      ),
                    );

                  },
                )
              ]
          ),
          ExpansionTile(
              leading: Icon(Icons.description_outlined),
              title: Text("Blog posts"),
              children: [
                FutureBuilder<List<BlogPost>>(
                  future: DatabaseService().getBlogPosts(widget.group),
                  builder: (context, snapshot){
                    if(snapshot.connectionState != ConnectionState.done){
                      return SizedBox(height: 100, child: SpinKitFoldingCube(color: Colors.white,),);
                    }

                    if(snapshot.data.length == 0){
                      return TextButton.icon(label: Text("There are no blog posts in this group"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                      });},);
                    }

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          BlogPost blog = snapshot.data[index];
                          return BlogWidget(
                            blog: blog,
                            more: ()=>viewBlog(blog),
                            delete: ()=>deleteBlog(blog),
                          );
                        },
                      ),
                    );

                  },
                )
              ]
          )

        ],
      ),
    );
  }
}
