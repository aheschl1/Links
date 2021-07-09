
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:links/payments/screens/payment_1.dart';
import 'package:links/screens/chats/groupchat.dart';
import 'package:links/screens/chats/owner_inbox.dart';
import 'package:links/screens/chats/private_message.dart';
import 'package:links/screens/event_managment/event_managment.dart';
import 'package:links/screens/group_managment/group_managment.dart';
import 'package:links/screens/loading.dart';
import 'package:links/screens/settings/edit_name_and_email.dart';
import 'package:links/screens/settings/settings_main.dart';
import 'package:links/services/auth_service.dart';
import 'package:links/services/database_service.dart';
import 'package:links/services/notification_service.dart';
import 'package:links/services/shared_service.dart';
import 'package:links/wrapper.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:links/screens/friends/manage_friends.dart';
import 'package:links/screens/friends/view_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'constants/level_types.dart';

void main(){


  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Future<bool> initialzeApp() async {
    await Firebase.initializeApp();
    await MobileAds.initialize();
    AccountLevels level = await DatabaseService().getAccountLevel();
    await SharedPreferenceService.setAccountLevel(level);
    return true;
  }

  runApp(

    FutureBuilder(
      future: initialzeApp(),
      builder: (context, snapshot){

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){

          return StreamProvider<User>.value(
            initialData: null,
            value: AuthService( ).user,

            child: MaterialApp(
              theme: ThemeData(
                timePickerTheme: TimePickerThemeData(
                    backgroundColor: Colors.black
                ),
                fontFamily: 'Ubuntu',
                brightness: Brightness.dark,
                backgroundColor: Colors.black38,
                cardColor: Colors.deepPurpleAccent,
                bottomSheetTheme: BottomSheetThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                )
              ),
              routes: {
                '/': (context)=>Wrapper(),
                '/settings':(context)=>Settings(),
                '/view_event':(context)=>EventManagement(),
                '/view_group':(context)=>GroupManagement(),
                '/groupchat':(context)=>Groupchat(),
                '/private_message':(context)=>PrivateMessage(),
                '/inbox':(context)=>OwnerInbox(),
                '/payments':(context)=>PaymentMainPage(),
                '/friends' : (context)=>ManageFriends(),
                '/view_profile': (context)=>ViewFriend(),
                '/edit_info' : (context)=>EditNameAndEmail()

              },
              initialRoute: '/',
            ),

          );

        }else{
          return Loading();
        }
      },
    )

  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  if(message.data['unsubscribe'] != null){
    print(message.data['unsubscribe']);
    FirebaseMessaging.instance.unsubscribeFromTopic(message.data['unsubscribe']);
  }

  if(message.data['subscribe'] != null){
    print(message.data['subscribe']);
    FirebaseMessaging.instance.subscribeToTopic(message.data['subscribe']);
  }

  if(message.data['notify'] == 'true'){

    LatLng position = await SharedPreferenceService.getLocation();

    double distanceFromUser = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(message.data['latitude']), double.parse(message.data['longitude'])) / 1000.0;

    if(position != null && distanceFromUser <= 50){
      String title = message.data['title'];
      String body = message.data['body'];

      NotificationService notificationService = NotificationService(
          title: title,
          body: body
      );

      notificationService.showNotification();
    }

  }


}
