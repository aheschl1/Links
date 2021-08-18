import 'package:flutter/material.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/tag.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/select_tags.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key key}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Tag> tags;


  Event event;
  Event newEvent;

  saveChanges() async{
    bool result = await DatabaseService().editEvent(
        event.docId, 
        title: titleController.text, 
        description: descriptionController.text,
        tags: tags.map((e) => e.name).toList()
    );
    Navigator.of(context).pop(result);
  }

  @override
  void didChangeDependencies() {
    event = ModalRoute.of(context).settings.arguments as Event;
    tags = event.tags.map((e) => Tag(name: e)).toList();
    titleController.text = event.title;
    descriptionController.text = event.description;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: Column(
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
                    controller: titleController,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    maxLines: 5,
                    minLines: 2,
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
                    controller: descriptionController,
                  ),
                  SizedBox(height: 30,),
                  FutureProvider<List<Tag>>(
                    initialData: [],
                    create: (data)=>  DatabaseService().getTags(),
                    child: SelectTags(
                      currentlySelected: event.tags,
                      onChanged: (data){
                        setState(() {
                          tags = data;
                          print(tags.map((e) => e.name).toList());
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
                onPressed: ()=>saveChanges(),
                icon: Icon(Icons.done),
                label: Text('Save changes')
            )
          ],
        ),
      ),
    );
  }
}
