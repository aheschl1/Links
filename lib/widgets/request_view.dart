import 'package:flutter/material.dart';
import 'package:links/constants/request.dart';

class ViewRequest extends StatefulWidget {

  final Request request;
  final Function()? ok;

  ViewRequest({required this.request, required this.ok});

  @override
  _ViewRequestState createState() => _ViewRequestState();
}

class _ViewRequestState extends State<ViewRequest> {

  String? requestStatus;

  @override
  Widget build(BuildContext context) {

    switch(widget.request.decision){
      case Request.PENDING:
        requestStatus = "Pending";
        break;
      case Request.DECLINED:
        requestStatus = "Declined";
        break;
    }

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
              Text(widget.request.eventAttached!.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 5),
              Text(
                "Date: ${widget.request.eventAttached!.date}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Location: ${widget.request.eventAttached!.location}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    requestStatus??"",
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.request.decision == Request.PENDING ? Colors.green : Colors.red
                    ),
                  ),
                  IconButton(icon: Icon(Icons.remove_circle_outline_rounded), onPressed: ()=>widget.ok)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ViewRequestGroup extends StatefulWidget {

  final Request request;
  final Function()? ok;

  ViewRequestGroup({required this.request, required this.ok});

  @override
  _ViewRequestGroupState createState() => _ViewRequestGroupState();
}

class _ViewRequestGroupState extends State<ViewRequestGroup> {

  String? requestStatus;

  @override
  Widget build(BuildContext context) {

    switch(widget.request.decision){
      case Request.PENDING:
        requestStatus = "Pending";
        break;
      case Request.DECLINED:
        requestStatus = "Declined";
        break;
    }

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
              Text(widget.request.groupAttached!.name, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    requestStatus??"",
                    style: TextStyle(
                        fontSize: 15,
                        color: widget.request.decision == Request.PENDING ? Colors.green : Colors.red
                    ),
                  ),
                  IconButton(icon: Icon(Icons.remove_circle_outline_rounded), onPressed: ()=>widget.ok)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}