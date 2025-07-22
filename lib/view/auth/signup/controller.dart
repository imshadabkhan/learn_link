import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';

import '../../../controller/usercontroller.dart';

class AuthenticationController {
  final selectedRole = ''.obs;

  UserController userController = Get.put<UserController>(UserController());
  final isPasswordHidden = true.obs;
  Future<String?> registerUser({required Map<String, String> data}) async {
    Widgets.showLoader('Creating account...');
    try {
      final response = await ApiService.postData(
        endpoint: Endpoints.register,
        data: data,
      );

      debugPrint("Register data sent by user: ${data.toString()}");
      Widgets.hideLoader();

      // Check if response is null or message is missing
      if (response == null || response['message'] == null) {
        Widgets.showSnackBar('Error', 'No response from server');
        return null;
      }

      final message = response['message'].toString();

      // Success case
      if (message == "User registered successfully!") {
        Widgets.showSnackBar('User Registered', message);
        Get.to(() => Login());
        return "success";
      }

      // Known error case
      if (message == "User already exists") {
        Widgets.showSnackBar('Registration Failed', 'This user already exists. Try logging in.');
        return null;
      }

      // Fallback: show any other message from server
      Widgets.showSnackBar('Error', message);
      return null;

    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar('Error', 'Failed to register user! ${e.toString()}');
      return null;
    }
  }



  Future<void> loginUser({required Map<String, dynamic> loginData}) async {
    Widgets.showLoader("Please wait");
    try {
      final response = await ApiService.postData(
        endpoint: Endpoints.login,
        data: loginData,
      );
      debugPrint("Login data enter by user ${loginData.toString()}");
       Widgets.hideLoader();
      if (response != null && response['token'] != null) {
        final user = response['token']['user'];
        await userController.saveUser(
          userToken: response['token'],
          userId: user['id'].toString(),
          userName: user['name'],
          userRole: user['role'],
          userAge: user['age']
        );
        Widgets.showSnackBar('Login Successful', "Welcome ${user['name']}!");
        Get.offAllNamed(AppRoutes.letterReversal);
      } else {
        Widgets.showSnackBar("Login Failed", "Invalid response from server");
      }
    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar("Error", "Login failed: ${e.toString()}");
      if (kDebugMode) {
        print("Login error: ${e.toString()}");
      }
    }
  }

}
