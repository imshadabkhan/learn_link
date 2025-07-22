import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/custom_drop_down.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/auth/signup/controller.dart';


class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthenticationController controller = Get.put(AuthenticationController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;

  final _formKey = GlobalKey<FormState>();

  final List<String> roles = ["user", "Guardian"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              EntryField(
                controller: nameController,
                label: "Name",
                hint: 'Enter your name',
                validator: (value) =>
                value == null || value.isEmpty ? 'Name is required' : null,
              ),
              EntryField(
                controller: ageController,
                label: "Age",
                hint: "Enter your age",
                textInputType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Age is required' : null,
              ),
              CustomDropdown(
                onTap: (){},
                value: selectedRole ?? '',
                hint: 'Select Role',
                label: 'Role',

              ),
              EntryField(
                controller: emailController,
                label: "Email",
                hint: "Enter your email",
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              EntryField(
                controller: passwordController,
                label: "Password",
                hint: "Enter your password",
                obscureText: true,
                validator: (value) =>
                value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              Widgets.heightSpaceH5,
              CustomButton(
                label: "Register",
                backgroundColor: Colors.red,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await controller.registerUser(
                     userName:  nameController.text.trim(),
                     userEmail:  emailController.text.trim(),
                     password:  passwordController.text.trim(),
                      age: ageController.text.trim(),
                      // Send lowercase value
                    );
                    if (result != null) {
                      Get.offAll(() => Login());
                    }
                  }
                },
              ),
              Widgets.heightSpaceH2,
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => Login());
                          },
                        text: " Login",
                        style: TextStyle(
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
