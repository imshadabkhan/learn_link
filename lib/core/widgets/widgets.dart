import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class Widgets {
  static var heightSpaceH05 = SizedBox(
    height: 2.h,
  );
  static var heightSpaceH1 = SizedBox(
    height: 5.h,
  );
  static var heightSpaceH2 = SizedBox(
    height: 10.h,
  );
  static var heightSpaceH3 = SizedBox(
    height: 15.h,
  );
  static var heightSpaceH4 = SizedBox(
    height: 20.h,
  );
  static var heightSpaceH5 = SizedBox(
    height: 25.h,
  );
  static var widthSpaceW05 = SizedBox(
    width: 2.w,
  );
  static var widthSpaceW1 = SizedBox(
    width: 7.w,
  );
  static var widthSpaceW2 = SizedBox(
    width: 10.w,
  );
  static var widthSpaceW3 = SizedBox(
    width: 15.w,
  );
  static var widthSpaceW4 = SizedBox(
    width: 20.w,
  );

  static void hideLoader() {
    EasyLoading.dismiss();
  }

  static void showLoader(String message) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black
      ..dismissOnTap = false;

    EasyLoading.show(
      maskType: EasyLoadingMaskType.none,
      indicator: CircularProgressIndicator(color: Colors.red),
      status: message,
    );
  }



  static void showSnackBar(String title, String message) {
    Get.snackbar(
      icon: Icon(
        title != "Success" ? Icons.info_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      title,
      borderColor: Colors.white,
      borderWidth: 5,
      message,
      backgroundColor: title != "Success" ? Colors.black87 : Colors.black87,
      colorText: Colors.white,
    );
  }











}
