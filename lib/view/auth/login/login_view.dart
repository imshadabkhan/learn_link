import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/signup/signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,scrolledUnderElevation: 0,backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
        child: ListView(children: [
          EntryField(label: "email",hint: 'Enter your email',),
          EntryField(label: "password",hint: "Enter your password",),

          Widgets.heightSpaceH5,
          CustomButton(
            onTap: (){
              Navigator.pushNamed(context, AppRoutes.letterReversal);
            },
            label: "Login",
            backgroundColor: Colors.red,
          ),
          Widgets.heightSpaceH2,
          Align(alignment: Alignment.center,child:  RichText(text: TextSpan(text: "Don't have an account?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black),children: [
            TextSpan(
recognizer: TapGestureRecognizer()
                ..onTap=(){
  Get.to(()=>Signup());
          },
                text: " Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blue)),
          ]),),),




        ],),
      ),

    );
  }
}
