import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        SpinKitDoubleBounce(color: Colors.white,),
                        SizedBox(height: 10,),
                        Text("One moment",style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
                      ]),
                    )
                  ]));
        });
  }
}