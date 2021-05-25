import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';

//show events not yet joined

class EventWidget extends StatefulWidget {

  final Event event;
  final Function join;
  final Function notInterested;

  EventWidget({this.event, this.join, this.notInterested});

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {

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
              Text(widget.event.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
              SizedBox(height: 10),
              Text(
                widget.event.description,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                    fontSize: 15,
                  fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Text(
                "From ${widget.event.time} to ${widget.event.endTime}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Date: ${widget.event.date} at ${widget.event.time}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Location: ${widget.event.location}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              widget.event.tags != null && widget.event.tags.length > 0 ? Text(
                "Tags: ${formatString(widget.event.tags)}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ) : SizedBox(),
              SizedBox(height: 10,),
              Row(
                children: [
                  TextButton.icon(
                      onPressed: widget.join,
                      icon: Icon(Icons.event_available),
                      label: Text(
                          widget.event.requireConfirmation? "Request" : double.parse(widget.event.admissionPrice) > 0 ? "Join ${widget.event.admissionPrice}\$" : "Join"
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

// Show event u created

class MyEventWidget extends StatefulWidget {

  final Function deleteEvent;
  final Event event;
  final Function more;

  MyEventWidget({this.event, this.deleteEvent, this.more});

  @override
  _MyEventWidgetState createState() => _MyEventWidgetState();
}

class _MyEventWidgetState extends State<MyEventWidget> {
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
              Text(widget.event.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                widget.event.description,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Date: ${widget.event.date}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "From ${widget.event.time} to ${widget.event.endTime}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Location: ${widget.event.location}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.deleteEvent,
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
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

//show event that you are in

class MyEventIn extends StatefulWidget {

  final Function leaveEvent;
  final Event event;
  final Function more;

  MyEventIn({this.event, this.leaveEvent, this.more});

  @override
  _MyEventInState createState() => _MyEventInState();
}

class _MyEventInState extends State<MyEventIn> {
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
              Text(widget.event.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Text(
                widget.event.description,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Date: ${widget.event.date}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "From ${widget.event.time} to ${widget.event.endTime}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Location: ${widget.event.location}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.leaveEvent,
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

class WidgetMyPage extends StatefulWidget {
  final Event event;
  WidgetMyPage(this.event);

  @override
  _WidgetMyPageState createState() => _WidgetMyPageState();
}

class _WidgetMyPageState extends State<WidgetMyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:  MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(widget.event.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )
            ),
          ),
          Divider(height: 20, color: Colors.black38),
          Text(
            widget.event.description,
            style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Date: ${widget.event.date}",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "From ${widget.event.time} to ${widget.event.endTime}",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Location: ${widget.event.location}",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          widget.event.tags != null && widget.event.tags.length > 0 ? Text(
            "Tags: ${formatString(widget.event.tags)}",
            style: TextStyle(
              fontSize: 15,
            ),
          ) : SizedBox(),
          SizedBox(height: 10),
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



