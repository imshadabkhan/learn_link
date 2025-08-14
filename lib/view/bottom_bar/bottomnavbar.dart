import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/view/guardian/guardian_view.dart';
import 'package:learn_link/view/bottom_bar/infoscreen.dart';
import 'package:learn_link/view/english_readers/user_homepage.dart';
import '../editprofile/edit_profile.dart';

class GuardianNavBar extends StatefulWidget {
  @override
  _GuardianNavBarState createState() => _GuardianNavBarState();
}

class _GuardianNavBarState extends State<GuardianNavBar> {
  int _currentIndex = 0;
  UserController userController = Get.put(UserController());

  final List<Widget> _screens = [
    GuardianDashboard(),
    DyslexiaInfoScreen(),
    DyslexiaProfileScreen(),
  ];
  final List<Widget> _userScreens = [
    StudentHomeScreen(),
    DyslexiaInfoScreen(),
    DyslexiaProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: userController.role.value == "guardian"
            ? _screens[_currentIndex]
            : _userScreens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'Info',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
