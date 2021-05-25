class Group{

  List usersIn;
  String owner;
  bool private;
  String name;
  String description;
  String groupchatId;
  bool requireConfirmation;
  List usersPermitted;
  bool anyoneCanPost;
  String docId;


  Group({this.groupchatId, this.name, this.private, this.usersPermitted, this.owner, this.usersIn, this.requireConfirmation, this.description, this.anyoneCanPost});

  Map<String, dynamic> toMap() {

    return {
      "private" : private,
      "groupchatId" : groupchatId,
      "requireConfirmation" : requireConfirmation,
      "usersPermitted" : usersPermitted,
      "name" : name,
      "description" : description,
      "owner" : owner,
      "usersIn" : usersIn,
      "anyoneCanPost" : anyoneCanPost
    };
  }

  static Group fromMap(Map data) {

    return Group(
        name: data['name'],
        private: data['private'],
        groupchatId: data['groupchatId'],
        requireConfirmation: data['requireConfirmation'],
        usersPermitted: data['usersPermitted'],
        description: data['description'],
        owner: data['owner'],
        usersIn: data['usersIn'],
        anyoneCanPost: data['anyoneCanPost']
    );
  }

}