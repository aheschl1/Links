import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/group.dart';
import 'package:links/services/database_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Group>>(
          future: DatabaseService().getPublicGroupsToDisplay(15),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              List<Group> groupsToDiaplsy = snapshot.data;
              return Container(
                padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                child:
                groupsToDiaplsy.length == 0 ?  TextButton.icon(label: Text("There are no public groups to display"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                });},) :
                AnimatedList(
                  initialItemCount: groupsToDiaplsy.length,
                  key: key,
                  itemBuilder: (context, int index, animation){
                    Group group = groupsToDiaplsy[index];
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
