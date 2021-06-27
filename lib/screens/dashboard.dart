import 'package:covid_help/Quiz.dart';
import 'package:covid_help/main.dart';
import 'package:covid_help/profile_page.dart';
import 'package:covid_help/screens/bot_message.dart';
import 'package:covid_help/screens/camera.dart';
import 'package:covid_help/screens/home.dart';
import 'package:covid_help/screens/profile.dart';
import 'package:covid_help/utils/dialog_flow.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int currentIndex = 0;
  final List<Widget> children = [Home(), FlutterFactsChatBot(), UserProfilePage() ];
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: height * 0.02,
        iconSize: height * 0.035,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(fontFamily: 'MyFont'),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              title: Text("Chat", style: TextStyle(fontFamily: 'MyFont'))),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile", style: TextStyle(fontFamily: 'MyFont')))
        ],
      ),
      body: currentIndex == 0
          ? SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.white,
          body: ListView(
            children: <Widget>[
              MainImage(),
              SizedBox(height: height * 0.035),
              children[currentIndex]
            ],
          ),
        ),
      )
          : children[currentIndex],
    );
  }
}

class MainImage extends StatefulWidget {
  @override
  _MainImageState createState() => _MainImageState();
}

class _MainImageState extends State<MainImage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _animationController;

  toggleAnimation() {
    animation = Tween(begin: 0.0, end: 25.0).animate(_animationController);
    if (_animationController.isDismissed) {
      _animationController.forward().whenComplete(() => toggleAnimation());
    }
    if (_animationController.isCompleted) {
      _animationController.reverse().whenComplete(() => toggleAnimation());
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this)
      ..addListener(() => setState(() {}));
    toggleAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
    );
  }
}
