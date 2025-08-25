import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/auth/forgot_password/change_password_view.dart';
import 'package:learn_link/view/auth/forgot_password/otp_view.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';

import '../../../controller/usercontroller.dart';

class AuthenticationController {
  final selectedRole = ''.obs;

  final UserController userController=Get.find<UserController>();
  RxString resetToken=''.obs;
  final isPasswordHidden = true.obs;
  final isLoginPasswordHidden = true.obs;
  RxBool isCheck = false.obs;
  RxBool is18Check = false.obs;
  RxBool obscured = false.obs;
  String? email;

  RxBool checkboxValue=false.obs;

  void toggleCheckBox(){
    checkboxValue.value=!checkboxValue.value;

  }
  void toggleObscured() {
    obscured.value = !obscured.value;
  }

  RxBool isHostSelected = false.obs;
  toggleButton() {
    isHostSelected.value = !isHostSelected.value;
  }
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
      Widgets.showSnackBar('Message', message);
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
      debugPrint("Login data entered by user: ${loginData.toString()}");
      Widgets.hideLoader();

      if (response != null && response['token'] != null) {
        final user = response['user'];
        await userController.saveUser(
          userToken: response['token'],
          userId: user['id'],
          userName: user['name'],
          userRole: user['role'],
        );

        Widgets.showSnackBar('Login Successful', "Welcome ${user['name']}!");

        final isGuardian = user['role'] == 'guardian';

        if (isGuardian) {
          Get.offAllNamed(AppRoutes.navBar); // example route for guardian
        } else {
          Get.offAllNamed(AppRoutes.navBar); // example route for user
        }
      } else {
        Widgets.showSnackBar("Login Failed", response?['message'] ?? "Unknown error");
      }
    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar('Error', 'Failed to login user! ${e.toString()}');
    }
  }




  requestForgotPassword(String emailString) async {
    try {
      Widgets.showLoader("Loading.. ");

      var payload = {"email": emailString};

      var response = await ApiService.postData(
        endpoint: Endpoints.requestForgotPassword,
        data: payload,
      );

      Widgets.hideLoader();
      print(response.toString());

      if (response['status'] == 200) {
        email = emailString;

        Widgets.showSnackBar("Success", response['message'] ?? "");
        Get.to(() => OtpView(email: emailString,));
      } else {
        Widgets.showSnackBar("Error", response['message'] ?? "Invalid Email");
      }
    } catch (e) {
      Widgets.hideLoader();
      debugPrint("Error $e");
      Widgets.showSnackBar("Error", "Something went Wrong");
    }
  }



  resendForgotOtp(String emailString) async {
    try {
      Widgets.showLoader("Loading.. ");

      var payload = {"email": emailString};

      var response =
          await ApiService.postData(endpoint:Endpoints.resendOtp, data:payload);

      Widgets.hideLoader();
print(response);
      if (response["status"] == 200) {
        email = emailString;

        Widgets.showSnackBar("Success", response["message"] ?? "");
        Get.to(()=>ChangePassword());
      } else {
        Widgets.showSnackBar("Error", "Invalid Email");
      }
    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar("Error", "Something went Wrong");
    }
  }

  // resendMailOtp(String email) async {
  //   // try {
  //   //   Widgets.showLoader("Loading.. ");
  //   //
  //   //   var payload = {"email": email};
  //   //
  //   //   var response = await ApiService.postData(Endpoints.sendMailOtp, payload);
  //   //
  //   //   Widgets.hideLoader();
  //   //   update();
  //   //   if (response.status == true) {
  //   //     Widgets.showSnackBar("Success", response.message ?? "");
  //   //   } else {
  //   //     Widgets.showSnackBar(
  //   //         "Error", response.message ?? "Something went wrong");
  //   //   }
  //   // } catch (e) {
  //   //   Widgets.hideLoader();
  //   //   Widgets.showSnackBar("Error", "Something went Wrong");
  //   // } finally {
  //   //   Widgets.hideLoader();
  //   // }
  // }

  // verifyOTP(String userId, String otpCode) async {
  //   Widgets.showLoader("Verifying OTP");
  //   try {
  //     var payload = {"user_id": userId, "otp": otpCode};
  //     var response = await ApiService.postData(endpoint:Endpoints.verifyOtp, data: payload);
  //     // Widgets.hideLoader();
  //     if (response.status == true) {
  //       // UserModel userModel = UserModel.fromJson(response.data['user']);
  //       // userController.saveUser(userModel, response.data['access_token']);
  //       userController.fetchUser();
  //
  //       // if (userModel.role == 1) {
  //       //   Get.offAll(() => TravellerNavScreen());
  //       // } else {
  //       //   Get.offAll(() => HostNavScreen());
  //       // }
  //     } else {
  //       Widgets.showSnackBar("Error", response.message ?? "Invalid Code");
  //     }
  //   } catch (e) {
  //     Widgets.hideLoader();
  //     Widgets.showSnackBar("Error", e.toString());
  //   }
  // }

  verifyForgotOTP({required String otpCode}) async {
    print("$otpCode $email");
    Widgets.showLoader("Verifying OTP");

    try {
      var payload = {"email": email, "otp": otpCode};
      var response =
          await ApiService.postData(endpoint:Endpoints.verifyOtp,data:  payload);
      debugPrint(response.toString());

      Widgets.hideLoader();
      if (response["status"] == 200) {
       email = email;
       resetToken.value=response["resetToken"].toString();
       Get.snackbar("Success", '${response["message"]}');
         Get.off(() => ChangePassword());
      } else {
        Widgets.showSnackBar("Error", response['message'] ?? "Invalid Code");
      }
    } catch (e) {
      Widgets.hideLoader();
      Widgets.showSnackBar("Error", e.toString());
    }
  }

  resetForgotPassword(
      String password,
      ) async {
      Widgets.showLoader("Loading..");
      try {
        var payload = {
          "newPassword": password,
        };
        var response =
            await ApiService.postData(endpoint:Endpoints.resetPassword, data:payload,
              resetToken: resetToken.value,
              useResetToken: true,
            );
        debugPrint(response.toString());

        Widgets.hideLoader();
        if (response['status'] == 200) {
          email = null;

          Widgets.showSnackBar("Success", response['message'].toString());
          Get.offAll(()=>Login());

        } else {
          Widgets.showSnackBar("Error", response['message'].toString());
        }
      } catch (e) {
        Widgets.hideLoader();
        Widgets.showSnackBar("Error", e.toString());
      }
    }


}
