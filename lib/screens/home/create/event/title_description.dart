import 'package:flutter/material.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/constants/event.dart';

class EnterTitleAndDescription extends StatefulWidget {

  final Function finished;
  final Event event;

  EnterTitleAndDescription({this.finished, this.event});

  @override
  _EnterTitleAndDescriptionState createState() => _EnterTitleAndDescriptionState();
}

class _EnterTitleAndDescriptionState extends State<EnterTitleAndDescription> {

  final _formKey = GlobalKey<FormState>();
  String title;
  String description;

  done(){
    if(_formKey.currentState.validate()){
      widget.event.description = description;
      widget.event.title = title;
      widget.finished(widget.event);
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
              "Create a new event",
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
                    if(val.length <= 20 && val.length >= 3){
                      return null;
                    }else if(val.length > 20){
                      return "Must be shorter then 21 characters";
                    }else{
                      return "Must be at least 3 characters";
                    }
                  },
                  decoration: Decorations(context: context).getTextInputCreate("Event title"),
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
                    if(val.length <= 100 && val.length >= 10){
                      return null;
                    }else if(val.length > 100){
                      return "Must be shorter then 100 characters";
                    }else{
                      return "Must be at least 10 characters";
                    }
                  },
                  decoration: Decorations(context: context).getTextInputCreate("Event description"),
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
