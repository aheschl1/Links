
class FriendData{
  String userId;
  String name;
  String email;
  String bio;

  FriendData({this.bio, this.userId, this.name, this.email});

  Map<String, dynamic> toMap() {
    return {
      "userId" : userId,
      "name" : name,
      "email" : email,
      'bio' : bio
    };
  }

  static FriendData fromMap(Map data) {
    return FriendData(
        userId: data['userId'],
        name: data['name'],
        email: data['email'],
        bio: data['bio']
    );
  }
}
