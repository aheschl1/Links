import 'package:flutter/material.dart';

class AddFriend extends StatelessWidget {

  final String name;
  final String email;
  final Function() add;

  AddFriend({required this.name, required this.email, required this.add});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name),
              Text(email),
              SizedBox(width: 18,),
              IconButton(icon: Icon(Icons.person_add), onPressed: add)
            ],
          ),
        ),
      ),
    );
  }
}
