import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/constants/asset_constant.dart';
import 'package:learn_link/view/english_readers/writing.dart';

class AttentionModuleController extends GetxController {
  // Inside AttentionModuleController
  RxBool hasSeenInstructions = false.obs;

  final userController=Get.find<UserController>();
  RxInt currentIndex = 0.obs;
  RxInt totalMarks = 0.obs;
  RxnString selectedImage = RxnString();
  RxBool overlayVisible = false.obs;
  RxDouble opacity = 1.0.obs;

  final List<String> mainImages = [
    ImageConstants.mainImage1,
    ImageConstants.mainImageFrog,
    ImageConstants.mainImageDuck,
    ImageConstants.mainImageCroc,
  ];

  final List<List<String>> subImages = [
    [

      ImageConstants.sub_Image2,
      ImageConstants.sub_Image1,
      ImageConstants.sub_Image3,
      ImageConstants.sub_Image4,
    ],
    [

      ImageConstants.sub_ImageFrog2,
      ImageConstants.sub_ImageFrog3,
      ImageConstants.sub_ImageFrog4,
      ImageConstants.sub_ImageFrog1,
    ],
    [
      ImageConstants.sub_ImageDuck1,
      ImageConstants.sub_ImageDuck2,
      ImageConstants.sub_ImageDuck3,
      ImageConstants.sub_ImageDuck4,
    ],
    [

      ImageConstants.sub_ImageCroc2,
      ImageConstants.sub_ImageCroc3,
      ImageConstants.sub_ImageCroc1,
      ImageConstants.sub_ImageCroc4,
    ],
  ];

  void marksCounter() {
    if (selectedImage.value == null || selectedImage.value!.isEmpty) {
      debugPrint("⚠ No image selected yet.");
      Get.snackbar("Select Image", "⚠ Please select an image before proceeding.");
      return;
    }

    if (selectedImage.value == mainImages[currentIndex.value]) {
      totalMarks.value+=25;
      debugPrint("✔ Correct Answer!");
    } else {
      debugPrint("❌ Wrong Answer!");
    }

    debugPrint("Selected Image: ${selectedImage.value}");
    debugPrint("Correct Image: ${mainImages[currentIndex.value]}");

    if (currentIndex.value < mainImages.length - 1) {
      // Move to next question
      currentIndex.value++;
      selectedImage.value = null;

      overlayVisible.value = true;
      opacity.value = 1.0;

      Future.delayed(const Duration(seconds: 5), () {
        opacity.value = 0.0;
        Future.delayed(const Duration(seconds: 1), () {
          overlayVisible.value = false;
        });
      });
    } else {

      if (selectedImage.value == null || selectedImage.value!.isEmpty) {
        Get.snackbar("Select Image", "⚠ Please select an image before completing.");
        debugPrint("⚠ No image selected on last question.");
        return;
      }

      Get.to(()=>DyslexiaImageScanner());
      userController.saveScore(attentionScore: totalMarks.value);

      selectedImage.value = null;
      debugPrint("🎉 Quiz Completed!");
      debugPrint("final marks ${totalMarks.value.toString()}");
      Get.snackbar("Completed", "Attention Module Completed");
    }
  }


  void opacityAndVisibilityController() {
    overlayVisible.value = true;
    opacity.value = 1.0;

    Future.delayed(const Duration(seconds: 5), () {
      opacity.value = 0.0;

      Future.delayed(const Duration(seconds: 1), () {
        overlayVisible.value = false;
      });
    });
  }
}

