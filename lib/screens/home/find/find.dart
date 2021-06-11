import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/request.dart';
import 'package:links/screens/home/find/find_events.dart';
import 'package:links/screens/home/find/find_groups.dart';
import 'package:links/services/database_service.dart';
import 'package:links/services/shared_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:links/widgets/build_filter.dart';
import 'package:place_picker/place_picker.dart';

class Find extends StatefulWidget {
  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find>{

  static const int EVENT = 0;
  static const int GROUP = 1;

  GeoFirePoint _currentPosition;
  String address;
  double radius = 40.0;

  var startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);

  FriendData me;

  int currentFinding = EVENT;

  joinEvent(Event event) async {
    String result;

    if(double.parse(event.admissionPrice) > 0){
      Navigator.of(context).pushNamed("/payments", arguments: event);
    }else{
      if(!event.requireConfirmation){
        result = await DatabaseService().joinEvent(event);
      }else{
        Request request = Request(userId: FirebaseAuth.instance.currentUser.uid, decision: Request.PENDING, userEmail: me.email, userName: me.name);
        result = await DatabaseService().requestToJoin(event, request);
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

  notInterestedInEvent(Event event) async{
    String result = await DatabaseService().notInterested(event);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  joinGroup(Group group) async {
    String result;


    if(!group.requireConfirmation){
      result = await DatabaseService().joinGroup(group);
    }else{
      Request request = Request(userId: FirebaseAuth.instance.currentUser.uid, decision: Request.PENDING, userEmail: me.email, userName: me.name);
      result = await DatabaseService().requestToJoinGroup(group, request);
    }

    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,

    );

  }

  notInterestedInGroup(Group group) async{
    String result = await DatabaseService().notInterestedInGroup(group);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser.uid));
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

          SharedPreferenceService.setLocation(LatLng(position.latitude, position.longitude));

          setState(() {
            _currentPosition = GeoFirePoint(position.latitude, position.longitude);
            address = "my location";
          });
    }).catchError((e) {
      print(e);
    });
  }

  openFilter(){
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterSearch(startDate: startDate, endDate: endDate, position: _currentPosition, radius: radius,)
      ).then(
        (value){
          if(value != null){
            print(value);
            setState(() {
              _currentPosition = value['position'] == null ? _currentPosition : value['position'];
              startDate = value['startDate'] == null ? startDate : value['startDate'];
              endDate = value['endDate'] == null ? endDate : value['endDate'];
              radius = value['radius'] == null ? radius : value['radius'];
              address = value['address'] == null ? address : value['address'];
            });
          }
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

    DateFormat formattedDate = DateFormat.yMMMEd();
    getMe();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu',
                letterSpacing: 1
              ),
              value: currentFinding,
              items: [EVENT, GROUP].map((e) => DropdownMenuItem(
                value: e,
                child: Text(e == EVENT ? "Public Events" : "Public Groups"),
              )).toList(),
              onChanged: (e){
                setState(() {
                  currentFinding = e;
                });
              },
            ),
            if(currentFinding == EVENT) TextButton.icon(
              onPressed: ()=>openFilter(),
              icon: Icon(Icons.filter_alt),
              label: Text("Filter")
            ),

          ],
        ),
        currentFinding == EVENT ? Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Viewing public events ${address == null ? "with no location filter" : "within $radius km of $address" } between ${formattedDate.format(startDate)} and ${formattedDate.format(endDate)}",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 12,
                color: Colors.white54
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ): Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Viewing all public groups. Join a group to see what events are going on! Groups are not filtered by location.",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 12,
                  color: Colors.white54
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Divider(height: 15,),
        ),
        //start content,
        currentFinding == EVENT ? FindEvents(
          radius: radius,
          currentPosition: _currentPosition,
          endDate: endDate,
          startDate: startDate,
          joinEvent: (e)=>joinEvent(e),
          notInterestedInEvent: (e)=>notInterestedInEvent(e),
        ) : FindGroups(
          joinGroup: (e)=>joinGroup(e),
          notInterestedInGroup: (e)=>notInterestedInGroup(e),
        )
      ],
    );
  }
}
