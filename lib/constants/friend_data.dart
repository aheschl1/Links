
class FriendData{
  String? userId;
  String name;
  String email;
  String? bio;

  FriendData({this.bio, required this.name, required this.email});

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
        name: data['name'],
        email: data['email'],
        bio: data['bio']
    );
  }
}
