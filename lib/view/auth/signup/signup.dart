import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/connectivity_check_controller.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/custom_drop_down.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/role_selection_widget.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/auth/signup/controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final connectivity = Get.find<ConnectivityController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;

  final _formKey = GlobalKey<FormState>();

  final List<String> roles = ["user", "Guardian"];

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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                EntryField(
                  controller: nameController,
                  label: "Name",
                  hint: 'Enter your name',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                ),
                EntryField(
                  controller: ageController,
                  label: "Age",
                  hint: "Enter your age",
                  textInputType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Age is required' : null,
                ),
                Obx(() => CustomDropdown(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Get.bottomSheet(
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            child: RoleSelectionBottomSheet(),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      value: controller.selectedRole.value,
                      hint: 'Select Role',
                      label: 'Role',
                    )),
                EntryField(
                  controller: emailController,
                  label: "Email",
                  hint: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                Obx(() => EntryField(
                      onTrailingTap: () {
                        controller.isPasswordHidden.value =
                            !controller.isPasswordHidden.value;
                      },
                      controller: passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    )),
                Widgets.heightSpaceH5,
                CustomButton(
                  label: "Register",
                  backgroundColor: Colors.red,
                  onTap: () async {
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String age = ageController.text.trim();
                    String role = 'user'; // you can keep this fixed or update

                    if (name.isEmpty) {
                      Widgets.showSnackBar(
                          'Validation Error', 'Name is required');
                      return;
                    }

                    if (age.isEmpty) {
                      Widgets.showSnackBar(
                          'Validation Error', 'Age is required');
                      return;
                    }
                    if (email.isEmpty) {
                      Widgets.showSnackBar(
                          'Validation Error', 'Email is required');
                      return;
                    }
                    if (!GetUtils.isEmail(email)) {
                      Widgets.showSnackBar(
                          'Validation Error', 'Please enter a valid email');
                      return;
                    }
                    if (password.isEmpty) {
                      Widgets.showSnackBar(
                          'Validation Error', 'Password is required');
                      return;
                    }
                    if (password.length < 6) {
                      Widgets.showSnackBar('Validation Error',
                          'Password must be at least 6 characters');
                      return;
                    }

                    Map<String, String> data = {
                      "name": name,
                      "email": email,
                      "password": password,
                      "age": age,
                      "role": role,
                    };

                    //Checking network connectivity
                    if (!connectivity.isConnected.value) {
                      Widgets.showSnackBar(
                          "No Internet", "Please check your connection");
                      return;
                    }

                    // Call registerUser after validation passes
                    final result = await controller.registerUser(data: data);
                    if (result != null) {
                      nameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      ageController.clear();

                      Get.offAll(() => Login());
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
      ),
    );
  }
}
