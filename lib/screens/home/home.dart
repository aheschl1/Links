import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/notification.dart';
import 'package:links/screens/home/create/create_wrapper.dart';
import 'package:links/screens/home/create/event/create.dart';
import 'file:///C:/Users/Andrew/AndroidStudioProjects/links/lib/screens/home/find/find.dart';
import 'package:links/screens/home/mine/mine.dart';
import 'package:links/screens/home/mine/mine_wrapper.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/widgets/show_notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool newNotifications = false;

  PageController _pageController;
  int selectedScreenIndex = 0;

  changeIndex(int i){
    setState(() {
      selectedScreenIndex = i;
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut
      );
    });
  }

  void showNotifications() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => ShowNotifications()
    );

    setState(() {
      newNotifications = false;
    });

  }

  getNewNotification() async {
    int notifs = await DatabaseService().amountOfNotifs();
    if(notifs > 0){
      setState(() {
        newNotifications = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getNewNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');

      if(message.data['unsubscribe'] != null){
        print(message.data['unsubscribe']);
        FirebaseMessaging.instance.unsubscribeFromTopic(message.data['unsubscribe']);
      }

      if(message.data['subscribe'] != null){
        print(message.data['subscribe']);
        FirebaseMessaging.instance.subscribeToTopic(message.data['subscribe']);
      }

      setState(() {
        newNotifications = true;
      });
    });
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.fromLTRB(40, 2, 0, 2),
              iconSize: selectedScreenIndex == 0 ? 29 : 24,
              tooltip: "Find",
              icon: Icon(
                Icons.search,
                color: selectedScreenIndex == 0 ? Theme.of(context).cardColor : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  selectedScreenIndex = 0;
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut
                  );
                });
              },
            ),
            IconButton(
              padding: const EdgeInsets.fromLTRB(0, 2, 40, 2),
              tooltip: "My Links",
              iconSize: selectedScreenIndex == 2 ? 29 : 24,
              icon: Icon(
                Icons.menu,
                color: selectedScreenIndex == 2 ? Theme.of(context).cardColor : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  selectedScreenIndex = 2;
                  _pageController.animateToPage(2,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut
                  );
                });
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Links"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icon(Icons.account_circle, color: Colors.white,),
          ),
          Stack(
            children: [
              Center(
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: ()=>showNotifications(),
                ),
              ),
              newNotifications ? Positioned(
                child: Icon(Icons.circle, color: Colors.red, size: 10,),
                top: 8,
                right: 15,
              ) : SizedBox()
            ],
          )
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index){
            setState(() {
              selectedScreenIndex = index;
            });
          },
          children: [
            Find(),
            CreateWrapper(changeIndex: changeIndex),
            MineWrapper()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: selectedScreenIndex == 1 ? 29 : 24,
          color: selectedScreenIndex == 1 ? Theme.of(context).cardColor : Colors.black,
        ),
        onPressed: (){
          setState(() {
            selectedScreenIndex = 1;
            _pageController.animateToPage(1,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut
            );
          });
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      resizeToAvoidBottomInset: false,

    );
  }

}

