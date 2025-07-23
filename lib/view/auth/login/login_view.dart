import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/connectivity_check_controller.dart';

import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/signup/controller.dart';
import 'package:learn_link/view/auth/signup/signup.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final connectivity = Get.find<ConnectivityController>();
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: ListView(
            children: [
              EntryField(
                label: "Email",
                hint: 'Enter your email',
                controller: email,
              ),
              Obx(() => EntryField(
                    onTrailingTap: () {
                      controller.isLoginPasswordHidden.value =
                          !controller.isLoginPasswordHidden.value;
                    },
                    controller: password,
                    label: "Password",
                    hint: "Enter your password",
                    obscureText: controller.isLoginPasswordHidden.value,
                    suffixIcon: controller.isLoginPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  )),
              Widgets.heightSpaceH5,
              CustomButton(
                onTap: () async {
                  if (!connectivity.isConnected.value) {
                    Widgets.showSnackBar("No Internet", "Please check your connection");
                    return;
                  }
                  if (email.text.isEmpty || password.text.isEmpty) {
                    Widgets.showSnackBar(
                        "Error", "Please enter email and password");
                    return;
                  }

                  await controller.loginUser(
                    loginData: {
                      "email": email.text.toString().trim(),
                      "password": password.text.toString().trim(),
                    },
                  );
                  FocusScope.of(context).unfocus();
                  password.clear();
                  email.clear();
                },
                label: "Login",
                backgroundColor: Colors.red,
              ),
              Widgets.heightSpaceH2,
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => Signup());
                          },
                        text: "Register",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
