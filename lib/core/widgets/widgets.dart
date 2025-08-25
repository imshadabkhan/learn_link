import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';


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








  static Widget buildStudentCard(Map<String, dynamic> student,UserController controller) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Label in same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Texts.textBold(
                      "Name: ",
                      size: 12

                  ),

                  Texts.textNormal(
                      student['name'] ?? 'Unnamed',
                      size: 12

                  ),
                ],),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Texts.textNormal(
                      student['label'] ?? 'N/A',
                      color: student['label']=="Dyslexic"?Colors.red:Colors.teal,
                      size: 12,
                      fontWeight: FontWeight.bold

                  ),
                ),
              ],
            ),


            // Age, Gender, Parent History
            Row(
              children: [
                Texts.textBold(
                    "age: ",
                    size: 14

                ),
                Texts.textNormal("${student['age'] ?? 'N/A'}",size: 14),

              ],
            ),
            Widgets.heightSpaceH1,
            Row(
              children: [


                Texts.textBold(
                    "gender: ",
                    size: 14

                ),
                Texts.textNormal("${student['gender'] ?? 'N/A'}",size: 14),
              ],
            ),
            Widgets.heightSpaceH1,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Texts.textBold("Dyslexic family history: ",size: 14),
                Texts.textNormal("${student['parent_history'].toString()}",size: 14),


              ],
            ),
            Widgets.heightSpaceH3,

            // Action Button
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(

                label: "Start Diagnosis",
                backgroundColor: Colors.teal,
                onTap: ()async{
                 await controller.saveCurrentStudentDetail(studentId:student['id'] ,studentAge:student['age'],familyHistoryDyslexic: student['parent_history_dyslexia']??false);

                  
                  
                  showDialog(
                    context: Get.context!,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Texts.textBold("Can the student read?",size: 16),
                        content: Texts.textNormal("Please confirm whether the student is able to read or not.",size: 14),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              // Navigate to screen for reading students
                              Get.toNamed(AppRoutes.letterReversal);
                            },
                            child: Texts.textBold("Yes",color: Colors.green,size: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog

                              Get.to(()=>PatternMemoryScreen());
                            },
                            child: Texts.textBold("No",color: Colors.red,size: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Just dismiss
                            },
                            child: Texts.textBold("Cancel",color: Colors.black,size: 14),
                          ),
                        ],
                      );
                    },
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }


}
