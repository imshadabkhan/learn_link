import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';

import '../../../controller/usercontroller.dart';

class AuthenticationController {
  UserController userController = Get.put<UserController>(UserController());

  Future<String?> registerUser(
      {String? userName,
      String? userEmail,
      String? password,
      String? role,
      String? age}) async {
    Widgets.showLoader('Creating account...');
    try {
      final response = await ApiService.postData(
          endpoint: Endpoints.register,
          data: {
            "name": userName,
            "email": userEmail,
            "password": password,
            "age":age,
            "role": role
          });
      Widgets.hideLoader();
      if (response != null &&
          response['message'] == "User registered successfully!") {
        Widgets.showSnackBar(
            'User Registered', "User registered successfully!");
        Get.to(() => Login());
      } else {
        Widgets.hideLoader();
        Widgets.showSnackBar('Error', "unexpected response from server");

        return null;
      }
    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar('Error', "Failed to register user!");
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
