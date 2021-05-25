import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/group.dart';
import 'package:links/screens/group_managment/view_my_group_in.dart';
import 'package:links/screens/group_managment/view_my_group_own.dart';

class GroupManagement extends StatefulWidget {

  @override
  _GroupManagementState createState() => _GroupManagementState();
}

class _GroupManagementState extends State<GroupManagement> {

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    Group group = ModalRoute.of(context).settings.arguments as Group;

    return group.owner == user.uid ? MyGroupOwn(group: group) : ViewMyGroupIn(group:group);
  }
}
