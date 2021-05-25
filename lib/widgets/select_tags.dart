import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/tag.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SelectTags extends StatefulWidget {

  final bool hide;
  final Function onChanged;

  SelectTags({this.hide = false, this.onChanged(List<Tag> data)});

  @override
  _SelectTagsState createState() => _SelectTagsState();
}

class _SelectTagsState extends State<SelectTags> {
  @override
  Widget build(BuildContext context) {

    List<Tag> friends = Provider.of<List<Tag>>(context);

    List selectedPeople = [];

    return widget.hide ? SizedBox(height: 0, width: 0,) : MultiSelectDialogField(
      title: Text("Select Tags"),
      buttonText: Text("Select Tags"),
      items: friends.map((e) => MultiSelectItem(e, e.name)).toList(),
      listType: MultiSelectListType.CHIP,
      onConfirm: (values) {
        selectedPeople = values;
        widget.onChanged(selectedPeople);
      },
    );

  }
}
