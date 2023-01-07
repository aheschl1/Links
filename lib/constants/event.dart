
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:links/services/database_service.dart';

class Event{

  String? groupId;
  String date; // date of event
  String time;
  String endTime;
  String? admissionPrice; // is it free
  bool? private; // is it available for the public, or only by invite
  String? groupChatEnabledID; // if groupchat is enabled, what is the id
  bool? requireConfirmation; // require owner confirmation of everyone who joins
  List<dynamic>? usersPermitted; // a list of all users who are permitted in this event
  String location; // the location of the event
  String title; // the title of the event
  String description; // description of the event
  String owner; // owner user id
  String? docId;
  GeoFirePoint? position;
  int? dateStamp;
  List<dynamic>? tags;
  List<dynamic>? usersIn; // document id to be set when the object is read from the database

  Event({
    required this.dateStamp,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.endTime,
    required this.location,
    required this.admissionPrice,
    this.private,
    required this.usersPermitted,
    required this.usersIn,
    required this.requireConfirmation,
    this.groupChatEnabledID,
    required this.owner,
    required this.tags,
    this.groupId
  });


  get liveUpdate {
    return DatabaseService().getEventStream(this);
  }

  Map<String, dynamic> toMap() {

    return {
      "groupId":groupId,
      "date" : date,
      "dateStamp": dateStamp,
      "admissionPrice" : admissionPrice,
      "private" : private,
      "groupChatEnabledID" : groupChatEnabledID,
      "requireConfirmation" : requireConfirmation,
      "usersPermitted" : usersPermitted,
      "location" : location,
      "time" : time,
      "title" : title,
      "description" : description,
      "owner" : owner,
      "usersIn" : usersIn,
      "endTime" : endTime,
      "position" : position == null ? null : position!.data,
      "tags" : tags
    };
  }

  static Event fromMap(Map data) {

    return Event(
        title: data['title'],
        date: data['date'],
        dateStamp: data['dateStamp'],
        admissionPrice: data['admissionPrice'],
        private: data['private'],
        groupChatEnabledID: data['groupChatEnabledID'],
        requireConfirmation: data['requireConfirmation'],
        usersPermitted: data['usersPermitted'],
        location: data['location'],
        time: data['time'],
        description: data['description'],
        owner: data['owner'],
        usersIn: data['usersIn'],
        endTime: data['endTime'],
        tags: data['tags'],
        groupId: data['groupId']
    );
  }

  static Event empty(){
    return new Event(dateStamp: null, title: '', description: '', date: '', time: '', endTime: '', location: '', admissionPrice: '', private: null, usersPermitted: [], usersIn: [], requireConfirmation: null, owner: '', tags: []);
  }

}