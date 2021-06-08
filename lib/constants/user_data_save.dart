
class UserData{

  List following = [];
  List notInterested = [];
  List myEventsJoined = [];
  List awaitingRequest = [];
  List subscribedTags = [];
  List groupsIn = [];
  List awaitingGroupRequests = [];
  List awaitingRequestGroupEvent = [];
  String paypalKey = "";

  UserData({this.paypalKey = "", this.myEventsJoined, this.notInterested, this.following, this.awaitingRequest, this.subscribedTags, this.groupsIn, this.awaitingGroupRequests, this.awaitingRequestGroupEvent});

  Map<String, dynamic> toMap() {
    return {
      "following" : following,
      "notInterested" : notInterested,
      "myEventsJoined" : myEventsJoined,
      "awaitingRequest" : awaitingRequest,
      'subscribedTags' : subscribedTags,
      'groupsIn' : groupsIn,
      'awaitingGroupRequests' : awaitingGroupRequests,
      'awaitingRequestGroupEvent' : awaitingRequestGroupEvent,
      'paypalKey' : paypalKey

    };
  }

  static UserData fromMap(Map data) {
    return UserData(
        following: data['following'],
        notInterested: data['notInterested'],
        myEventsJoined: data['myEventsJoined'],
        awaitingRequest: data['awaitingRequest'],
        subscribedTags : data['subscribedTags'],
        groupsIn : data['groupsIn'],
        awaitingGroupRequests: data['awaitingGroupRequests'],
        awaitingRequestGroupEvent : data['awaitingRequestGroupEvent'],
        paypalKey : data['paypalKey']

    );
  }

}