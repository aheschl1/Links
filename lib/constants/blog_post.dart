class BlogPost{

  String content;
  String owner;
  String ownerName;
  String date;
  String title;
  String docId;

  BlogPost({this.content, this.owner, this.ownerName, this.date, this.title});

  Map<String, dynamic> toMap() {

    return {
      "content" : content,
      "owner": owner,
      "date" : date,
      "title" : title,
      'ownerName' : ownerName
    };
  }

  static BlogPost fromMap(Map data) {

    return BlogPost(
        content: data['content'],
        date: data['date'],
        owner: data['owner'],
        title: data['title'],
        ownerName:data['ownerName']
    );
  }


}