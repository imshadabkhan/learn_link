import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';

class UserHomeScreen extends StatelessWidget {
  final UserController controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Texts.textNormal(
          '👋 Hello, ${controller.userName}!',
        ),
      ),
      // Gradient background to keep it soft and pleasant
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets.heightSpaceH1,
            Texts.textBold('Welcome to LexiScan', size: 18),
            Widgets.heightSpaceH1,
            Texts.textNormal(
              'Your friendly app to help you spot and overcome reading challenges. Interactive, fun, and made just for you!',
              size: 16,
              textAlign: TextAlign.start,
            ),
            Widgets.heightSpaceH5,
            Card(
              elevation: .5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Texts.textNormal(
                  '✨ LexiScan offers you interactive tests designed to help identify dyslexia early, improve reading skills, and boost your confidence!',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Widgets.heightSpaceH3,
            Texts.textNormal(
              '“Every great reader started just like you!”',
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomButton(
              onTap:(){
                Get.toNamed(AppRoutes.letterReversal);
              },
              label: "Start Test",
              textColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            Widgets.heightSpaceH5,
          ],
        ),
      ),
    );
  }
}
