import 'package:flutter/material.dart';
import 'package:links/constants/group.dart';

class MyGroupWidget extends StatefulWidget {

  final Function()? deleteEvent;
  final Group group;
  final Function()? more;

  MyGroupWidget({required this.group, required this.deleteEvent, required this.more});

  @override
  _MyGroupWidgetState createState() => _MyGroupWidgetState();
}

class _MyGroupWidgetState extends State<MyGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.group.name, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                widget.group.description,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Number of members: ${widget.group.usersIn != null ? widget.group.usersIn!.length.toString() : '0'}' ,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed:widget.deleteEvent,
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                  ),
                  TextButton.icon(
                    onPressed:widget.more,
                    icon: Icon(Icons.add),
                    label: Text("More"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GroupMyPage extends StatefulWidget {
  final Group group;
  GroupMyPage(this.group);

  @override
  _GroupMyPageState createState() => _GroupMyPageState();
}

class _GroupMyPageState extends State<GroupMyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Theme.of(context).cardColor,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize:  MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(widget.group.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )
            ),
          ),
          SizedBox(height: 10,),
          Text(
            widget.group.description,
            style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic
            ),
          ),

        ],
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


class MyGroupIn extends StatefulWidget {

  final Function()? leaveGroup;
  final Group group;
  final Function()? more;

  MyGroupIn({required this.group, required this.leaveGroup, required this.more});

  @override
  _MyGroupInState createState() => _MyGroupInState();
}

class _MyGroupInState extends State<MyGroupIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.group.name, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                widget.group.description,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.leaveGroup,
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Leave"),
                  ),
                  TextButton.icon(
                    onPressed: widget.more,
                    icon: Icon(Icons.add),
                    label: Text("More"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupWidget extends StatefulWidget {

  final Group group;
  final Function()? join;
  final Function()? notInterested;

  GroupWidget({required this.group, required this.join, required this.notInterested});

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.group.name, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                widget.group.description,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.join,
                    icon: Icon(Icons.event_available),
                    label: Text(
                        widget.group.requireConfirmation!? "Request" : "Join"
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.notInterested,
                    icon: Icon(Icons.event_busy_rounded),
                    label: Text("Not interested"),
                  )
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