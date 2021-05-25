import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No internet connection", style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(height: 10,),
            Text("Turn on wifi or mobile data to use Links", style: TextStyle(
                fontSize: 15
            ),),
          ],
        ),
      ),
    );
  }
}
