
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/tag.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SelectTags extends StatefulWidget {

  final bool hide;
  final Function onChanged;
  final List currentlySelected;

  SelectTags({this.hide = false, this.onChanged(List<Tag> data), this.currentlySelected});

  @override
  _SelectTagsState createState() => _SelectTagsState();
}

class _SelectTagsState extends State<SelectTags> {
  @override
  Widget build(BuildContext context) {

    List<Tag> friends = Provider.of<List<Tag>>(context);
    List selectedPeople = [];

    if(friends.isNotEmpty){
      return widget.hide ? SizedBox(height: 0, width: 0,) : MultiSelectDialogField(
        title: Text("Select Tags"),
        buttonText: Text("Select Tags"),
        items: friends.map((e) => MultiSelectItem(e.id, e.name)).toList(),
        listType: MultiSelectListType.CHIP,
        initialValue: widget.currentlySelected != null ? friends.where((e){
          if(widget.currentlySelected.contains(e.name)){
            return true;
          }
          return false;
        }).map((e)=>e.id.toString()).toList() : [],
        onConfirm: (values) {
          selectedPeople = friends.where((e) => values.contains(e.id)).toList();
          widget.onChanged(selectedPeople);
        },
      );
    }else{
      return SpinKitCubeGrid(color: Colors.black,);
    }

  }
}
