import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/ad_ids.dart';
import 'package:links/constants/group.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/ad_widget.dart';
import 'package:links/widgets/group_widget.dart';

class FindGroups extends StatefulWidget {

  final Function notInterestedInGroup;
  final Function joinGroup;

  FindGroups({this.notInterestedInGroup, this.joinGroup});

  @override
  _FindGroupsState createState() => _FindGroupsState();
}

class _FindGroupsState extends State<FindGroups> {

  final key = GlobalKey<AnimatedListState>();
  int currentGroupIndex = 0;

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
      child: FutureBuilder<List<Group>>(
          future: DatabaseService().getPublicGroupsToDisplay(15),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){

              List<Group> groupsToDiaplsy = snapshot.data;
              List displayOutline = getDisplayOutline(groupsToDiaplsy);

              return Container(
                padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                child:
                groupsToDiaplsy.length == 0 ?  TextButton.icon(label: Text("There are no public groups to display"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                });},) :
                AnimatedList(
                  initialItemCount: displayOutline.length,
                  key: key,
                  itemBuilder: (context, int index, animation){
                    if(!displayOutline[index]){
                      Group group = groupsToDiaplsy[currentGroupIndex];
                      currentGroupIndex ++;
                      if (currentGroupIndex == groupsToDiaplsy.length)
                        currentGroupIndex = 0;
                      return Dismissible(

                        onDismissed: (direction){
                          if(direction == DismissDirection.endToStart){
                            widget.notInterestedInGroup(group);
                          }else{
                            widget.joinGroup(group);
                          }
                        },
                        direction: DismissDirection.horizontal,
                        key: UniqueKey(),

                        child: GroupWidget(
                          group: group,
                          join: (){
                            widget.joinGroup(group);
                            snapshot.data.removeAt(index);
                            key.currentState.removeItem(index, (context,animation)=>SizedBox());
                          },
                          notInterested: () {
                            widget.notInterestedInGroup(group);
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

                    }else{
                      return AdControl(adId: AdIds().publicGroupAdId,);
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
