import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/add_friend.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {

  TextEditingController searchBar = TextEditingController();
  List<FriendData> friendsToDisplay = [];

  Widget noResultsText = Column(
    children: [
      SizedBox(height: 50,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "No search results. Note that searches are case sensitive.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
    ],
  );

  searchForFriends() async {


    if(searchBar.text.isNotEmpty){
      if(searchBar.text.contains("@")){
        FriendData? result = await DatabaseService().searchFriendsEmail(searchBar.text.trim());
        if(result != null){
          setState(() {
            friendsToDisplay = [result];
          });
        }
      }else{
        List<FriendData>? friends = await DatabaseService().searchFriendsName(searchBar.text.trim());
        if(friends != null){
          setState(() {
            friendsToDisplay = friends;
          });
        }
      }
    }
    searchBar.text = "";


  }

  addFriend(FriendData data) async {
    String result = await DatabaseService().addFriend(data.userId);
    final snackBar = SnackBar(content: Text(result),  behavior: SnackBarBehavior.floating,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if(result != "Something went wrong"){
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 100, 8, 8),
      child: Column(
        children: [
          TextField(
            style: TextStyle(color: Colors.black),
            controller: searchBar,
            decoration: InputDecoration(
              hintText: "Search names or emails",
              hintStyle: TextStyle(
                color: Colors.black45
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: (){searchForFriends();},
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(50.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: !friendsToDisplay.isNotEmpty ? noResultsText : ListView.builder(
              itemCount: friendsToDisplay.length,
              itemBuilder: (context, index){
                return AddFriend(
                  add: (){
                    addFriend(friendsToDisplay[index]);
                  },
                  email: friendsToDisplay[index].email,
                  name: friendsToDisplay[index].name,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
