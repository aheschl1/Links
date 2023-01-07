
class Message{

  String content;
  String? senderDisplayName;
  String? senderUid;
  int timeStamp;

  Message({required this.content, this.senderDisplayName, this.senderUid, required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      "content" : content,
      "senderDisplayName" : senderDisplayName,
      "senderUid" : senderUid,
      "timeStamp" : timeStamp,
    };
  }

  static Message fromMap(Map? data) {
    return Message(
      content: data!['content'],
      senderDisplayName: data['senderDisplayName'],
      senderUid: data['senderUid'],
      timeStamp: data['timeStamp'],
    );
  }

}