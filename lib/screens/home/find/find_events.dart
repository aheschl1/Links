import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:links/constants/event.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';

class FindEvents extends StatefulWidget {

  final GeoFirePoint currentPosition;
  final DateTime startDate;
  final DateTime endDate;
  final double radius;
  final Function notInterestedInEvent;
  final Function joinEvent;

  FindEvents({this.currentPosition, this.radius, this.startDate, this.endDate, this.notInterestedInEvent, this.joinEvent});

  @override
  _FindEventsState createState() => _FindEventsState();
}

class _FindEventsState extends State<FindEvents> {

  final key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Event>>(
          future: widget.currentPosition == null ? DatabaseService().getPublicEventsToDisplay(8, range: DateTimeRange(start: widget.startDate, end: widget.endDate)) :DatabaseService().getPublicEventsToDisplayLocationFiltered(8, widget.currentPosition, radius: widget.radius, range: DateTimeRange(start: widget.startDate, end: widget.endDate)),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              List<Event> eventsToDisplay = snapshot.data;
              return Container(
                padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                child:
                eventsToDisplay.length == 0 ?  TextButton.icon(label: Text("There are no public events to display"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                });},) :
                AnimatedList(
                  initialItemCount: eventsToDisplay.length,
                  key: key,
                  itemBuilder: (context, int index, animation){
                    Event event = eventsToDisplay[index];
                    return Dismissible(

                      onDismissed: (direction){
                        if(direction == DismissDirection.endToStart){
                          widget.notInterestedInEvent(event);
                        }else{
                          widget.joinEvent(event);
                        }
                      },
                      direction: DismissDirection.horizontal,
                      key: UniqueKey(),

                      child: EventWidget(
                        event: event,
                        join: (){
                          widget.joinEvent(event);
                          snapshot.data.removeAt(index);
                          key.currentState.removeItem(index, (context,animation)=>SizedBox());
                        },
                        notInterested: () {
                          widget.notInterestedInEvent(event);
                          snapshot.data.removeAt(index);
                          key.currentState.removeItem(index, (context,animation)=>SizedBox());
                        },
                      ),

                      background: Container(
                        color: Colors.green[400],
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Icon(
                            Icons.event_available_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      secondaryBackground: Container(
                        color: Colors.red[400],
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Icon(
                            Icons.event_busy_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    );
                  },
                ),
              );
            }else{
              return SpinKitFoldingCube(color: Colors.white);
            }
          }
      ),
    );

  }
}
