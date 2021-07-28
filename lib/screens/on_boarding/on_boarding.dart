import 'package:flutter/material.dart';
import 'package:links/screens/on_boarding/stage_1.dart';
import 'package:links/screens/on_boarding/stage_two.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Links'), centerTitle: true,),
      body: PageView(
        controller: _controller,
        children: [
          StageOne(),
          StageTwo()
        ],
      ),
    );
  }
}
