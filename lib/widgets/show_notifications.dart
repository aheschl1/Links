import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/notification.dart';
import 'package:links/services/database_service.dart';

class ShowNotifications extends StatefulWidget {
  @override
  _ShowNotificationsState createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<ShowNotifications> {

  void dismissNotification(NotificationData notification ) async {
    String result = await DatabaseService().deleteNotification(notification);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: StreamBuilder<List<NotificationData>>(
        stream: DatabaseService().streamNotifications(),
        builder: (context, snapshot){

          if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
            return SpinKitFoldingCube(color: Colors.white,);
          }
          if(snapshot.data.length == 0){
            return SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "No new notifications",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              NotificationData notificationData = snapshot.data[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red[400],
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.notifications_off_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction)=>dismissNotification(notificationData),
                  child: ListTile(
                    tileColor: Colors.white24,
                    title: Text(notificationData.title),
                    subtitle: Text(notificationData.body),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}

/*
*
*           StreamBuilder<List<NotificationData>>(
            stream: DatabaseService().streamNotifications(),
            builder: (context, snapshot){
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
                return IconButton(
                  icon: Icon(Icons.notifications),
                );
              }

              return PopupMenuButton<String>(
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.notifications),
                        ],
                      ),
                    ),
                  ),
                  itemBuilder: (context){
                    List<PopupMenuItem<String>> items = [];
                    for(NotificationData notif in snapshot.data){
                      items.add(
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notif.title),
                                    Text(notif.body),
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(Icons.not_interested_outlined),
                                    onPressed: ()=>dismissNotification(notif)
                                )
                              ],
                            ),
                            value: notif.id,
                          )
                      );
                    }
                    if(items.length == 0){
                      items.add(
                          PopupMenuItem(child: Text("No notifications"))
                      );
                    }
                    return items;
                  }
              );

            },
          )
*/
