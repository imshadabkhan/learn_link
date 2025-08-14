import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'controller.dart';

class DyslexiaProfileScreen extends StatelessWidget {
  DyslexiaProfileScreen({super.key});
  final TextEditingController dobController = TextEditingController();
  UserController controller=Get.find<UserController>();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Texts.textBold("Your Profile", size: 18),
              Widgets.heightSpaceH05,
              Texts.textNormal(
                "Your personal information!.",
                textAlign: TextAlign.start,
                size: 12,
              ),
              Widgets.heightSpaceH2,
              Widgets.heightSpaceH1,
              Obx(()=>EntryField(
                label: "Name",
                hint:controller.userName.value.toString(),
              ),),

              Widgets.heightSpaceH05,
              Obx(()=>  EntryField(
                label: "role",
                hint:controller.role.value.toString(),
              ),),


              Widgets.heightSpaceH3,
              Widgets.heightSpaceH3,
              Widgets.heightSpaceH3,
              Texts.textNormal(
                "Logout from your account safely. You can log back in anytime.",
                size: 12,
                textAlign: TextAlign.start,
              ),
              Widgets.heightSpaceH2,
              CustomButton(
                label: "Logout",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                onTap: () {
          controller.logOutUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
