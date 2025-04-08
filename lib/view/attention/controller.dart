import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/constants/asset_constant.dart';

class AttentionModuleController extends GetxController {
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
      ImageConstants.sub_Image1,
      ImageConstants.sub_Image2,
      ImageConstants.sub_Image3,
      ImageConstants.sub_Image4,
    ],
    [
      ImageConstants.sub_ImageFrog1,
      ImageConstants.sub_ImageFrog2,
      ImageConstants.sub_ImageFrog3,
      ImageConstants.sub_ImageFrog4,
    ],
    [
      ImageConstants.sub_ImageDuck1,
      ImageConstants.sub_ImageDuck2,
      ImageConstants.sub_ImageDuck3,
      ImageConstants.sub_ImageDuck4,
    ],
    [
      ImageConstants.sub_ImageCroc1,
      ImageConstants.sub_ImageCroc2,
      ImageConstants.sub_ImageCroc3,
      ImageConstants.sub_ImageCroc4,
    ],
  ];

  void marksCounter() {
    if (selectedImage.value == null) {
      debugPrint("⚠ No image selected yet.");
      return;
    }

    if (selectedImage.value == mainImages[currentIndex.value]) {
      totalMarks.value++;
      debugPrint("✔ Correct Answer!");
    } else {
      debugPrint("❌ Wrong Answer!");
    }

    debugPrint("Selected Image: ${selectedImage.value}");
    debugPrint("Correct Image: ${mainImages[currentIndex.value]}");

    // Move to the next question
    if (currentIndex.value < mainImages.length - 1) {
      currentIndex.value++;
      selectedImage.value = '';

      overlayVisible.value = true;
      opacity.value = 1.0;

      Future.delayed(const Duration(seconds: 5), () {
        opacity.value = 0.0;

        Future.delayed(const Duration(seconds: 1), () {
          overlayVisible.value = false;
        });
      });
    } else {
      debugPrint("🎉 Quiz Completed!");
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
