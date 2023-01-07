class Tag{

  final String name;
  String? id;

  Tag({required this.name});


  Map<String, dynamic> toMap() {

    return {
      "name" : name,
    };
  }

  static Tag fromMap(Map data) {

    return Tag(
      name: data['name'],
    );
  }


}