import 'package:flutter/material.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/constants/group.dart';

class EnterNameAndDescription extends StatefulWidget {

  final Function(Group?) finished;
  final Group? group;

  EnterNameAndDescription({required this.finished, this.group});

  @override
  _EnterNameAndDescriptionState createState() => _EnterNameAndDescriptionState();
}

class _EnterNameAndDescriptionState extends State<EnterNameAndDescription> {

  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";

  done(){
    if(_formKey.currentState!.validate()){
      widget.group!.description = description;
      widget.group!.name = title;
      widget.finished(widget.group);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Create a new group",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    validator: (val){
                      if(val!.length <= 20 && val.length >= 3){
                        return null;
                      }else if(val.length > 20){
                        return "Must be shorter then 21 characters";
                      }else{
                        return "Must be at least 3 characters";
                      }
                    },
                    decoration: Decorations(context: context).getTextInputCreate("Group name"),
                    onChanged: (val){
                      setState(() {
                        title = val;
                      });
                    },
                  ),
                  SizedBox(height: 14,),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    maxLines: 5,
                    minLines: 5,
                    validator: (val){
                      if(val!.length <= 100 && val.length >= 10){
                        return null;
                      }else if(val.length > 100){
                        return "Must be shorter then 100 characters";
                      }else{
                        return "Must be at least 10 characters";
                      }
                    },
                    decoration: Decorations(context: context).getTextInputCreate("Group description"),
                    onChanged: (val){
                      setState(() {
                        description = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            ElevatedButton.icon(
                onPressed: (){
                  done();
                },
                icon: Icon(Icons.navigate_next),
                label: Text("Next")
            )
          ],
        )
    );
  }
}
