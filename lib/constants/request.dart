
import 'package:links/constants/event.dart';
import 'package:links/constants/group.dart';

class Request{

  static const int ALLOWED = 0;
  static const int DECLINED = 1;
  static const int PENDING = 2;

  int decision;
  String userId;
  String? userName;
  String? userEmail;
  Event? eventAttached;
  Group? groupAttached;
  String? docId;

  Request({required this.userId, required this.decision, required this.userName, required this.userEmail});

  Map<String, dynamic> toMap() {
    return {
      "decision" : decision,
      "userId" : userId,
      "userName" : userName,
      "userEmail" : userEmail,
    };
  }

  static Request fromMap(Map data) {
    return Request(
        userId: data['userId'],
        decision: data['decision'],
        userName: data['userName'],
        userEmail: data['userEmail']

    );
  }

}