import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/auth/signup/controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/text_widgets.dart';
import '../../../core/widgets/widgets.dart';
import 'change_password_view.dart';

class OtpView extends StatefulWidget {
  OtpView({super.key, var email});
  var email;

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Widgets.heightSpaceH5,
              Widgets.heightSpaceH1,
              Texts.textBold('Verification', size: 22, color: Colors.black),
              Widgets.heightSpaceH2,
              Texts.textNormal(
                "An 6 Digit Code has been sent to your email address. Enter code to verify your email address",
                color: Colors.black,
                size: 13,
                textAlign: TextAlign.center,
              ),
              Widgets.heightSpaceH3,
              Row(
                children: [
                  Texts.textNormal(
                    "Enter 6 Digit Code",
                    color: Colors.black,
                    size: 13,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Widgets.heightSpaceH1,
              PinCodeTextField(
                controller: otpController,
                appContext: context,
                length: 6,
                autoDisposeControllers: true,
                animationType: AnimationType.fade,
                textStyle: TextStyle(color: Colors.black),
                pinTheme: PinTheme(
                    fieldWidth: .12.sw,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: .5,
                    selectedBorderWidth: .8,
                    activeBorderWidth: .5,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.white,
                    inactiveBorderWidth: .5,
                    selectedColor: Colors.black,
                    activeColor: Colors.black,
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.black),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  if (kDebugMode) {
                    print("Completed");
                  }
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  if (kDebugMode) {
                    print("Allowing to paste $text");
                  }
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              Widgets.heightSpaceH05,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Texts.textNormal("Didn’t receive? ",
                      color: Colors.black, size: 12),
                  GestureDetector(
                    onTap: () {
                      if (widget.email != null) {
                        authenticationController
                            .resendForgotOtp(widget.email.toString());
                      } else {
                        Get.snackbar("Validation Error", "Enter a valid email");
                      }
                    },
                    child: Texts.textNormal("Resend",
                        color: Colors.teal,
                        size: 12,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                color: Colors.teal,
                borderColor:
                    otpController.text.length != 6 ? Colors.black : Colors.teal,
                label: "Verify OTP",
                textColor: otpController.text.length != 6
                    ? Colors.black
                    : Colors.white,
                backgroundColor:
                    otpController.text.length != 6 ? Colors.white : Colors.teal,
                radius: 10,
                onTap: () {
                  if (otpController.text.length == 6) {
                    authenticationController.verifyForgotOTP(otpCode: otpController.text.toString());
                  } else {
                  Get.snackbar("Invalid Error",'Invalid OTP');
                  }
                },
              ),
              Widgets.heightSpaceH1,
              CustomButton(
                borderColor: Colors.black,
                label: "Back To Login",
                textColor: Colors.black,
                backgroundColor: Colors.transparent,
                radius: 10,
                onTap: () {
                  Get.to(() => Login());
                },
              ),
              Widgets.heightSpaceH1,
            ],
          ),
        ),
      ),
    );
  }
}
