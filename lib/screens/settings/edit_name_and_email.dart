import 'package:flutter/material.dart';
import 'package:links/services/database_service.dart';

class EditNameAndEmail extends StatelessWidget {

  final String nameOg;
  final String emailOg;
  final String bioOg;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  EditNameAndEmail({this.nameOg, this.emailOg, this.bioOg});

  @override
  Widget build(BuildContext context) {

    save()async{
      if(_formKey.currentState.validate()){
        String newName = nameController.text;
        String newBio = bioController.text;
        String result = await DatabaseService().editNameAndBio(newName, newBio);
        final snackBar = SnackBar(content: Text(result));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if(result != "Something went wrong"){
          Navigator.of(context).pop();
        }
      }
    }

    nameController.text = nameOg;
    bioController.text = bioOg;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Edit name and bio",
            style: TextStyle(
              letterSpacing: 1,
              fontSize: 20,
              color: Colors.white
            ),
          ),
          Divider(height: 40, color: Colors.black45,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (val){
                    if(val.length > 2){
                      return null;
                    }else{
                      return "Add at least 3 characters";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter new name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: bioController,
                  minLines: 5,
                  maxLines: 6,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter bio",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Save"),
                  onPressed: ()=>save(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
