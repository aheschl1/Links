import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SelectFriends extends StatefulWidget {

  final bool hide;
  final Function onChanged;

  SelectFriends({this.hide = false, this.onChanged(List<FriendData> data)});

  @override
  _SelectFriendsState createState() => _SelectFriendsState();
}

class _SelectFriendsState extends State<SelectFriends> {
  @override
  Widget build(BuildContext context) {

    List<FriendData> friends = Provider.of<List<FriendData>>(context);

    List selectedPeople = [];

    return widget.hide ? SizedBox(height: 0, width: 0,) : MultiSelectDialogField(
      title: Text("Select Friends"),
      buttonText: Text("Select Friends"),
      items: friends.map((e) => MultiSelectItem(e, e.name)).toList(),
      listType: MultiSelectListType.CHIP,
      onConfirm: (values) {
        selectedPeople = values;
        widget.onChanged(selectedPeople);
      },
    );

  }
}
