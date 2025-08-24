import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/signup/controller.dart';




class ForgotPassword extends StatelessWidget {
  AuthenticationController authController=Get.put(AuthenticationController());
  final TextEditingController emailController = TextEditingController();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
onTap: (){
  FocusScope.of(context).unfocus();
},
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        Texts.textBold("ForgotPassword",
            color: Colors.white, size: 20),
        Widgets.heightSpaceH3,
        EntryField(
            label: "Enter Your Email",
            fillColor: Colors.transparent,
            controller: emailController,
            // prefixIcon: Assets.lockIcon,
            hint: "example12@gmail.com",


                  suffixIcon: Icons.person_2_outlined
          ),






        Widgets.heightSpaceH5,

        CustomButton(
          label: "Continue",
          textColor: Colors.white,
          backgroundColor: Colors.teal,
          radius: 10,
          onTap: () {
            if(emailController.text.isNotEmpty){
              authController.requestForgotPassword(emailController.text.toString());


            }else{
              Get.snackbar("Validation Error", "Please enter a email");
            }
emailController.clear();


          },
        ),
        Widgets.heightSpaceH2,

        CustomButton(
          backgroundColor: Colors.red,
          label: "Cancel",
          textColor: Colors.white,
          borderColor: Colors.white,

          radius: 10,
          onTap: () {
Get.back();

          },
        ),

        Widgets.heightSpaceH2,

      ],
    );
  }
}
