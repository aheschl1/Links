class NotificationData{

  final String title;
  final String body;
  String id;

  NotificationData({this.title, this.body});

  Map<String, dynamic> toMap() {

    return {
      "title" : title,
      "body": body,
      "id": id,
    };
  }

  static NotificationData fromMap(Map data) {
    return NotificationData(
      title: data['title'],
      body: data['body'],
    );
  }

}