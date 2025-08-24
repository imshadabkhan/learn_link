
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/auth/signup/controller.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/entry_field.dart';

import '../../../../core/widgets/text_widgets.dart';
import '../../../../core/widgets/widgets.dart';

class ChangePassword extends StatelessWidget {
  AuthenticationController authenticationController=Get.put(AuthenticationController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Widgets.heightSpaceH5,


              Widgets.heightSpaceH2,
              formSection(),


              Widgets.heightSpaceH2,
            ],
          ),
        ),
      ),
    );
  }

  formSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Texts.textBold("Change Password",
            color: Colors.white, size: 20),

        Widgets.heightSpaceH1,
        Obx(
              () => EntryField(
            label: "New Password",
            fillColor: Colors.transparent,
            controller: passwordController,
            // prefixIcon: Assets.lockIcon,
            hint: "**************",
            obscureText: authenticationController.obscured.value,

            suffixIcon: authenticationController.obscured.value == false
                ? CupertinoIcons.eye_slash
                : Icons.remove_red_eye_outlined,
            onTrailingTap: () {
              authenticationController.toggleObscured();
            },
          ),
        ),
        Widgets.heightSpaceH1,




        Widgets.heightSpaceH3,
        CustomButton(
          label: "Update",
          textColor: Colors.white,
          backgroundColor: Colors.teal,
          radius: 10,
          onTap: () {

            if (passwordController.text.isEmpty) {
              Widgets.showSnackBar(
                  "Incomplete Form", "Please enter a password");
            } else if (passwordController.text.length < 6) {
              Widgets.showSnackBar("Invalid Password",
                  "Please enter password min length 6 characters");
            } else {
              authenticationController.resetForgotPassword(passwordController.text.toString());

            }

          },
        ),
        Widgets.heightSpaceH2,

        CustomButton(
          label: "Cancel",
          textColor: Colors.black,
        borderColor: Colors.black,

          radius: 10,
          onTap: () {

            // if (!GetUtils.isEmail(emailController.text)) {
            //   Widgets.showSnackBar(
            //       "Incomplete Form", "Please enter valid email");
            // } else if (passwordController.text.length < 6) {
            //   Widgets.showSnackBar("Incomplete Form",
            //       "Please enter password min length 6 characters");
            // } else {
            //   authenticationController.loginUser(
            //       emailController.text.toString(),
            //       passwordController.text.toString());
            // }
            // Get.toNamed(AppRoutes.subscriptionView);
          },
        ),

        Widgets.heightSpaceH2,

      ],
    );
  }
}
