import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:learn_link/controller/connectivity_check_controller.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/custom_drop_down.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/role_selection_widget.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [

                GifView.asset(
                  'assets/images/blue_logo.gif',
                  height: 100,
                  width: 100,
                  frameRate: 50,
                ),
                Widgets.heightSpaceH05,
                Texts.textBold("Create Your Account",size: 16),
                Widgets.heightSpaceH05,
                Texts.textNormal("Fill in the details below to create your account.",size: 16),
                Widgets.heightSpaceH1,                EntryField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Age is required';
                    final age = int.tryParse(value);
                    if (age == null) return 'Enter a valid number';
                    if (age < 3) return 'Age must be at least 3';
                    if (age > 120) return 'Age must be realistic (max 120)';
                    return null;
                  },
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
                    String ageText = ageController.text.trim();
                    String role = 'user'; // or get from dropdown

                    // Basic validation checks
                    if (name.isEmpty) {
                      Widgets.showSnackBar('Validation Error', 'Name is required');
                      return;
                    }

                    if (ageText.isEmpty) {
                      Widgets.showSnackBar('Validation Error', 'Age is required');
                      return;
                    }

                    // Age numeric + range validation
                    final age = int.tryParse(ageText);
                    if (age == null) {
                      Widgets.showSnackBar('Validation Error', 'Age must be a valid number');
                      return;
                    }
                    if (age < 3) {
                      Widgets.showSnackBar('Validation Error', 'Age must be at least 3');
                      return;
                    }
                    if (age > 120) {
                      Widgets.showSnackBar('Validation Error', 'Age must be realistic (max 120)');
                      return;
                    }

                    if (email.isEmpty) {
                      Widgets.showSnackBar('Validation Error', 'Email is required');
                      return;
                    }

                    if (!GetUtils.isEmail(email)) {
                      Widgets.showSnackBar('Validation Error', 'Please enter a valid email');
                      return;
                    }

                    if (password.isEmpty) {
                      Widgets.showSnackBar('Validation Error', 'Password is required');
                      return;
                    }

                    if (password.length < 6) {
                      Widgets.showSnackBar('Validation Error', 'Password must be at least 6 characters');
                      return;
                    }

                    // Check internet connectivity
                    if (!connectivity.isConnected.value) {
                      Widgets.showSnackBar("No Internet", "Please check your connection");
                      return;
                    }

                    // If all validations pass, call register API
                    Map<String, String> data = {
                      "name": name,
                      "email": email,
                      "password": password,
                      "age": ageText,
                      "role": role,
                    };

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
