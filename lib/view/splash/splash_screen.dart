import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:learn_link/view/bottom_bar/bottomnavbar.dart';
import 'dart:async';

import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/guardian/guardian_view.dart';

import '../../controller/usercontroller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final UserController userController = Get.find<UserController>();  // Find userController

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Fetch user token first, then decide navigation
    userController.fetchUser().then((_) {
      Timer(const Duration(seconds: 3), () {
        if (userController.token.value.isNotEmpty && userController.role.value=="user") {
          // User logged in, navigate to LetterReversal screen (replace with your actual screen)
          Get.offAll((GuardianNavBar()));
        }else if(userController.token.value.isNotEmpty && userController.role.value=="guardian"){
          Get.offAll( GuardianNavBar() );
        } else {
          // User not logged in, navigate to login
          Get.offAll(() => Login());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GifView.asset(
                'assets/images/blue_logo.gif',
                height: 150,
                width: 130,
                frameRate: 30,
              ),
              Widgets.heightSpaceH05,
              Texts.textBold(
                'LexiScan ',
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
