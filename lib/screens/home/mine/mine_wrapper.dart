import 'package:flutter/material.dart';
import 'package:links/screens/home/mine/groups_mine.dart';
import 'package:links/screens/home/mine/mine.dart';

class MineWrapper extends StatefulWidget {
  @override
  _MineWrapperState createState() => _MineWrapperState();
}

class _MineWrapperState extends State<MineWrapper> {

  int index = 0;

  List screens = [
    Mine(),
    MineGroups()
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomAppBar(
          color: Colors.white,
          elevation: 5,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      index = 0;
                    });
                  },
                  child:Container(
                    padding: EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration:BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: index == 0 ?Theme.of(context).cardColor : Colors.white,
                          width: 1.0 , // Underline thickness
                        ))
                    ),
                    child: Text(
                      "Events",
                      style: TextStyle(
                        color: index == 0 ? Theme.of(context).cardColor : Colors.black,
                      ),
                    ),
                  )
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      index = 1;
                    });
                  },
                  child:Container(
                      padding: EdgeInsets.only(
                        bottom: 5, // Space between underline and text
                      ),
                      decoration:BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: index == 1 ? Theme.of(context).cardColor : Colors.white,
                            width: 1.0 , // Underline thickness
                          ))
                      ),
                      child: Text(
                        "Groups",
                        style: TextStyle(
                          color: index == 1 ? Theme.of(context).cardColor : Colors.black,
                        ),
                      ),
                    )
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: screens[index],
        )
      ],
    );
  }
}
