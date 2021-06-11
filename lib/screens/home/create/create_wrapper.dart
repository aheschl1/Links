import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:links/screens/home/create/event/create.dart';
import 'package:links/screens/home/create/group/create.dart';

class CreateWrapper extends StatefulWidget {

  final Function changeIndex;

  CreateWrapper({this.changeIndex});

  @override
  _CreateWrapperState createState() => _CreateWrapperState();
}

class _CreateWrapperState extends State<CreateWrapper>{

  static const int SELECT = 1;
  static const int EVENT = 0;
  static const int GROUP = 2;

  PageController controller =  PageController(
      initialPage: 1
  );

  int state = SELECT;

  Widget _selectView(){

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
       children: [
         Container(
           width: double.infinity,
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(20))
           ),
           child: TextButton.icon(
             icon: Icon(Icons.arrow_upward),
             label: Text("New Event"),
             onPressed: (){
               state = EVENT;
               controller.animateToPage(state,
                   duration: Duration(milliseconds: 500),
                   curve: Curves.easeOut
               );
             },
           ),
         ),
         Expanded(
           child: Center(
             child:DefaultTextStyle(
               style: const TextStyle(
                 fontSize: 20.0,
               ),
               child: AnimatedTextKit(
                 animatedTexts: [
                   TypewriterAnimatedText(
                       'What do you want to create?',
                        speed: const Duration(milliseconds: 50),
                     ),
                 ],
                 isRepeatingAnimation: false,
               ),
             )
           ),
         ),
         Container(
           width: double.infinity,
           decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(20))
           ),
           child: TextButton.icon(
             icon: Icon(Icons.arrow_downward),
             label: Text("New Group"),
             onPressed: (){
               state = GROUP;
               controller.animateToPage(state,
                   duration: Duration(milliseconds: 500),
                   curve: Curves.easeOut
               );
             },
           ),
         ),
         SizedBox(height: 30,)
       ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return PageView(
      scrollDirection: Axis.vertical,
      controller: controller,
      onPageChanged: (index){
        setState(() {
          state = index;
        });
      },
      children: [
        Create(changeIndex: widget.changeIndex,),
        _selectView(),
        CreateGroup(changeIndex: widget.changeIndex,)
      ],
    );


  }

}
