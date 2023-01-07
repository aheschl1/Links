import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:intl/intl.dart';
import 'package:links/constants/event.dart';
import 'package:place_picker/place_picker.dart';

class EnterLocationAndDate extends StatefulWidget {

  final Function(Event) finished;
  final Event event;

  EnterLocationAndDate({required this.finished, required this.event});

  @override
  _EnterLocationAndDateState createState() => _EnterLocationAndDateState();
}

class _EnterLocationAndDateState extends State<EnterLocationAndDate> {
  
  TextEditingController textEditingController = TextEditingController(text: "");
  DateTime dateTime = DateTime.now();
  String currentTime = "12:00 PM";
  String currentEndTime = "1:00 PM";
  GeoFirePoint? point;

  final kGoogleApiKey = "AIzaSyDQsi3TnwIWsNl_IJs63sIzw__418mSlKE";
  final _formKey = GlobalKey<FormState>();

  done(){
    if(_formKey.currentState!.validate()){
      String format = DateFormat.yMMMEd().format(dateTime);
      widget.event.date = format;
      widget.event.dateStamp = dateTime.millisecondsSinceEpoch;
      widget.event.location = textEditingController.text;
      widget.event.time = currentTime;
      widget.event.endTime = currentEndTime;
      widget.event.position = point;
      widget.finished(widget.event);
    }
  }

  searchAndNavigate() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(kGoogleApiKey)
    ));

    // Handle the result in your way
    textEditingController.text = result.formattedAddress!;
    point = GeoFlutterFire().point(latitude: result.latLng!.latitude, longitude:  result.latLng!.longitude);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                validator: (val){
                  if(val!.isEmpty){
                    return "Select a location";
                  }else{
                    return null;
                  }
                },
                focusNode: AlwaysDisabledFocusNode(),
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Address, Click to open map",
                  filled:true,
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.search, color: Colors.black),
                ),
                onTap: (){
                  searchAndNavigate();
                },
              ),
            ),
          ),
          Column(
            children: [
              CalendarDatePicker(
                onDateChanged: (DateTime value) {
                  setState(() {
                    dateTime = value;
                  });
                },
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        currentTime = newTime!.format(context);
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black),
                        )
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          return Colors.white; // Use the component's default.
                        },
                      ),
                    ),
                    label: Text(currentTime, style: TextStyle(color: Colors.black),),
                    icon: Icon(Icons.timer, color: Colors.black),
                  ),
                  Text(" to "),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        currentEndTime = newTime!.format(context);
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        return Colors.white; // Use the component's default.
                      },
                      ),
                    ),
                    label: Text(currentEndTime, style: TextStyle(color: Colors.black),),
                    icon: Icon(Icons.timer, color: Colors.black),
                  ),
                ],
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon
              (
                onPressed: ()=>done(),
                icon: Icon(Icons.navigate_next),
                label: Text("Next"),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
