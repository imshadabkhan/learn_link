import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/custom_drop_down.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,scrolledUnderElevation: 0,backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
        child: ListView(children: [
          EntryField(label: "name",hint: 'Enter your name',),
          EntryField(label: "age",hint: "Enter your age",),

          CustomDropdown(
            onTap: () {},
            value: '',
            hint: 'Select role',
            label: 'role',
            color: Colors.transparent,
            iconColor: Colors.black,
          ),
          EntryField(label: "email",hint: "Enter your email",),
          EntryField(label: "password",hint: "Enter your password",),
          Widgets.heightSpaceH5,
          CustomButton(

            label: "Register",
            backgroundColor: Colors.red,
          ),
          Widgets.heightSpaceH2,
          Align(alignment: Alignment.center,child:  RichText(text: TextSpan(text: "Already have an account?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black),children: [
            TextSpan(
recognizer: TapGestureRecognizer()
              ..onTap = () {

                Get.to(
                        ()=>Login()
                );
      },
                text: " Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blue)),



          ]),),),




        ],),
      ),

    );
  }
}
