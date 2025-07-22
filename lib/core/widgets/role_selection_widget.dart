import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/auth/signup/controller.dart';

class RoleSelectionBottomSheet extends StatelessWidget {
  final List<String> roles = ['user', 'guardian'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: roles.map((role) {
        return ListTile(
          title: Text(role),
          onTap: () {
            final controller = Get.find<AuthenticationController>(); // Replace with actual controller
            controller.selectedRole.value = role;
            Get.back(); // Close bottom sheet
          },
        );
      }).toList(),
    );
  }
}
