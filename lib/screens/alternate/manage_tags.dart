import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:links/constants/tag.dart';
import 'package:links/services/database_service.dart';
import 'package:links/services/shared_service.dart';
import 'package:place_picker/place_picker.dart';

class ManageTagSubs extends StatefulWidget {
  @override
  _ManageTagSubsState createState() => _ManageTagSubsState();
}

class _ManageTagSubsState extends State<ManageTagSubs> {

  List<String> mySubbed = [];
  bool alreadyLoaded = false;

  getMySubs() async {
    List<String> tagsSubbed = await DatabaseService().getTagsSubbed();
    print(tagsSubbed);
    setState(() {
      mySubbed = tagsSubbed;
    });
  }

  subscribeToTag(Tag tag) async {

    if(await SharedPreferenceService.getLocation() == null){
      await _getCurrentLocation();
    }

    bool result = await DatabaseService().subToTag(tag);
    if(result){
      FirebaseMessaging.instance.subscribeToTopic(tag.name);
      final snackBar = SnackBar(
        content: Text('Subscribed to ${tag.name}'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      final snackBar = SnackBar(
        content: Text('Something went wrong'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        mySubbed.remove(tag.name);
      });
    }
  }

  unsubscribeFromTag(Tag tag) async {
    bool result = await DatabaseService().unSubFromTag(tag);
    if(result){
      FirebaseMessaging.instance.unsubscribeFromTopic(tag.name);
      final snackBar = SnackBar(
        content: Text('Unsubscribed from ${tag.name}'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      final snackBar = SnackBar(
        content: Text('Something went wrong'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        mySubbed.add(tag.name);
      });
    }
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      SharedPreferenceService.setLocation(LatLng(position.latitude, position.longitude));

    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    getMySubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tag>>(
      future: DatabaseService().getTags(),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done && alreadyLoaded == false){
          return SpinKitFoldingCube(color: Colors.white);
        }

        alreadyLoaded = true;

        return Column(
          children: [
            SizedBox(height: 10,),
            Text(
              "Manage tag subscriptions",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 20
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'You will only receive notifications for events with 50km of your location. You must temporarily turn your location to subscribe to new tags.',
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 12,
                    color: Colors.white54
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  Tag tag = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SwitchListTile(
                      tileColor: Theme.of(context).cardColor,
                      value: mySubbed != null && mySubbed.contains(tag.name),
                      title: Text(tag.name),
                      onChanged: (val){
                        if(val){
                          subscribeToTag(tag);
                          setState(() {
                            if(mySubbed == null){
                              mySubbed = [];
                            }
                            mySubbed.add(tag.name);
                          });
                        }else{
                          unsubscribeFromTag(tag);
                          setState(() {
                            mySubbed.remove(tag.name);
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );

      },
    );
  }
}
