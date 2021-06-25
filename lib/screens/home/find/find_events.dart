import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:links/constants/ad_ids.dart';
import 'package:links/constants/event.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/ad_widget.dart';
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
  int currentEventIndex = 0;

   List<bool> getDisplayOutline(events){
     List<bool> outline = [];
     int eventsPlaced = 0;
     for(int index = 0; eventsPlaced < events.length; index ++){
       if((index + 1) % 3 == 0){
         outline.add(true);
       }else{
         outline.add(false);
         eventsPlaced ++;
       }
     }
     return outline;
   }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Event>>(
          future: widget.currentPosition == null ? DatabaseService().getPublicEventsToDisplay(8, range: DateTimeRange(start: widget.startDate, end: widget.endDate)) :DatabaseService().getPublicEventsToDisplayLocationFiltered(8, widget.currentPosition, radius: widget.radius, range: DateTimeRange(start: widget.startDate, end: widget.endDate)),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              List<Event> eventsToDisplay = snapshot.data;
              List displayOutline = getDisplayOutline(eventsToDisplay);
              return Container(
                padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                child: eventsToDisplay.length == 0 ?  TextButton.icon(label: Text("There are no public events to display"), icon: Icon(Icons.refresh), onPressed: (){setState(() {});},) :
                AnimatedList(
                  initialItemCount: displayOutline.length,
                  key: key,
                  itemBuilder: (context, int index, animation){
                    if(!displayOutline[index]) {
                      Event item = eventsToDisplay[currentEventIndex];
                      currentEventIndex ++;
                      if (currentEventIndex == eventsToDisplay.length)
                        currentEventIndex = 0;
                      return Dismissible(
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            widget.notInterestedInEvent(item);
                          } else {
                            widget.joinEvent(item);
                          }
                        },
                        direction: DismissDirection.horizontal,
                        key: UniqueKey(),

                        child: EventWidget(
                          event: item,
                          join: () {
                            widget.joinEvent(item);
                            snapshot.data.removeAt(index);
                            key.currentState.removeItem(
                                index, (context, animation) => SizedBox());
                          },
                          notInterested: () {
                            widget.notInterestedInEvent(item);
                            snapshot.data.removeAt(index);
                            key.currentState.removeItem(
                                index, (context, animation) => SizedBox());
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
                    }else{
                      return AdControl(adId: AdIds().publicEventAdId,);
                    }
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
