import 'package:flutter/material.dart';

class BasicDescription extends StatelessWidget {
  const BasicDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Basic Account',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              SizedBox(height: 10, width: double.infinity,),
              Text(
                'Basic accounts give you access to almost all features. A free account is enough for most users, especially if you just want to find things to do!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    ListTile(
                      title: Text('Create free events and groups'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Join events and groups'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Subscribe to notifications'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Use social features'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Create paid events'),
                      trailing: Icon(Icons.not_interested),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Ad free'),
                      trailing: Icon(Icons.not_interested),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Business tools'),
                      trailing: Icon(Icons.not_interested),
                      tileColor:Colors.black26,
                    ),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
