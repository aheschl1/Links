
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class FilterSearch extends StatefulWidget {

  final DateTime startDate;
  final DateTime endDate;
  final GeoFirePoint position;
  final double radius;

  FilterSearch({this.startDate, this.endDate, this.position, this.radius});

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {

  final kGoogleApiKey = "AIzaSyDavOnmlKHv2dKYcPmxoNCMnl9foHeKftY";
  DateTime newStartDate;
  DateTime newEndDate;
  GeoFirePoint newPosition;
  double newRadius;

  String address;

  searchLocation() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(kGoogleApiKey)
    ));

    // Handle the result in your way
    setState(() {
      address = result.formattedAddress;
      newPosition = Geoflutterfire().point(latitude: result.latLng.latitude, longitude:  result.latLng.longitude);
    });

  }

  selectDateRange()async{
    DateTimeRange range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
    if(range != null){
      setState(() {
        newStartDate = range.start;
        newEndDate = range.end;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    DateFormat formattedDate = DateFormat.yMMMEd();

    String startDateShow = formattedDate.format(newStartDate == null ? widget.startDate : newStartDate);
    String endDateShow = formattedDate.format(newEndDate == null ? widget.endDate : newEndDate);

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextButton.icon(
            label: Flexible(
              child: Text(
                address == null ? "Change search location" : "Filter events near $address",
                style: TextStyle(
                  color: Colors.white
                ),
              )
            ),
            icon: Icon(Icons.map),
            onPressed: ()=>searchLocation(),
          ),
          Divider(height: 20,),
          Text(
              "Search radius: ${newRadius == null ? widget.radius : newRadius} km"
          ),
          Slider(
            min: 1,
            max: 100,
            value: newRadius == null ? widget.radius : newRadius,
            onChanged: (value){
              setState(() {
                newRadius = double.parse(value.toStringAsFixed(1));
              });
            }
          ),
          Divider(height: 20,),
          TextButton.icon(
            label: Flexible(
              child: Text(
                "Filter events between the dates $startDateShow and $endDateShow",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            icon: Icon(Icons.date_range),
            onPressed:(){
              selectDateRange();
            }
          ),
          Expanded(child: SizedBox(),),
          ElevatedButton.icon(
            label: Text("Apply Filters"),
            icon: Icon(Icons.check),
            onPressed: (){
              Navigator.of(context).pop(
                {
                  'position': address == null ? widget.position : newPosition,
                  'startDate': newStartDate == null ? widget.startDate : newStartDate,
                  'endDate' : newEndDate == null ? widget.endDate : newEndDate,
                  'radius' : newRadius == null ? widget.radius : newRadius,
                  'address': address
                }
              );
            },
          )
        ],
      ),
    );
  }
}
