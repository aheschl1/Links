import 'package:flutter/material.dart';
import 'package:links/constants/level_types.dart';
import 'package:links/screens/settings/account_level_descriptions/basic_description.dart';
import 'package:links/screens/settings/account_level_descriptions/pro_desciption.dart';
import 'package:links/services/database_service.dart';

class AccountLevel extends StatefulWidget {
  final AccountLevels accountLevelCurrent;

  const AccountLevel({Key key, this.accountLevelCurrent}) : super(key: key);

  @override
  _AccountLevelState createState() => _AccountLevelState();
}

class _AccountLevelState extends State<AccountLevel> {

  AccountLevels accountLevelStatus;


  void basicLevelClicked(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_)=>BasicDescription()
        )
    );
  }

  void proLevelClicked() async {
    var success = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_)=>ProDescription()
        )
    );
    if(success == null){
      return;
    }
    if(success){
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: Text('You have successfully been upgraded to a pro account'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    }else{
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: Text('Something went wrong. If you were charged but have not been upgraded, contact support'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    }

  }

  void advertiserLevelClicked(){

  }

  void getAccountLevel() async {
    var level = await DatabaseService().getAccountLevel();
    setState(() {
      accountLevelStatus = level;
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accountLevelStatus = widget.accountLevelCurrent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: ()=>basicLevelClicked(),
            title: Text('Basic'),
            subtitle: Text('Free access to most features.'),
            tileColor: accountLevelStatus == AccountLevels.BASIC ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.BASIC ? Icon(Icons.star) : null,
          ),
          SizedBox(height: 10,),
          ListTile(
            onTap: ()=>proLevelClicked(),
            title: Text('Pro'),
            subtitle: Text('Access to all pro features. This includes creating paid events.'),
            isThreeLine: true,
            tileColor: accountLevelStatus == AccountLevels.PRO ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.PRO ? Icon(Icons.star) : null,
          ),
          SizedBox(height: 10,),
          ListTile(
            onTap: ()=>advertiserLevelClicked(),
            title: Text('Advertiser (Not yet available)'),
            subtitle: Text('Advertise your business on other peoples posts!'),
            tileColor: accountLevelStatus == AccountLevels.ADVERTISER ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.ADVERTISER ? Icon(Icons.star) : null,
          ),
        ],
      ),
    );
  }
}
