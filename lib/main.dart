import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/view/attention/attention_screen.dart';
import 'package:learn_link/view/auth/signup/signup.dart';
import 'package:learn_link/view/letter_reversal/view/letter_reversal.dart';
import 'package:learn_link/view/memory_pattern/memory_pattern_ui.dart';
import 'package:learn_link/view/number_sequence/number_sequence_game.dart';
import 'package:learn_link/view/speaking/speaking_screen.dart';
import 'package:learn_link/view/splash/splash_screen.dart';
import 'controller/connectivity_check_controller.dart';
import 'view/guardian_view.dart';



void main() {
  Get.put(ConnectivityController());
  Get.put(UserController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return GetMaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
          getPages: AppRoutes.routes,
          initialRoute: '/',

        );
      },
      child:AttentionModule(),

    );
  }
}