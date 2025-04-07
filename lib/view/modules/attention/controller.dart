import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/constants/asset_constant.dart';

class AttentionModuleController extends GetxController {
  int currentIndex = 0;
  int totalMarks = 0;
  String? selectedImage;
 RxBool overlayVisible = false.obs;
  RxDouble opacity = 1.0.obs;


  final RxList<String> mainImages = [
    ImageConstants.mainImage1,
    ImageConstants.mainImageFrog,
    ImageConstants.mainImageDuck,
    ImageConstants.mainImageCroc,
  ].obs;

  final RxList<List<String>> subImages = [
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
  ].obs;

  void marksCounter() {
    if (selectedImage == null) {
      debugPrint("⚠ No image selected yet.");
      return;
    }

    if (selectedImage == mainImages[currentIndex]) {
      totalMarks++;
      debugPrint("✔ Correct Answer!");
    } else {
      debugPrint("❌ Wrong Answer!");
    }

    debugPrint("Selected Image: $selectedImage");
    debugPrint("Correct Image: ${mainImages[currentIndex]}");

    // Move to the next question
    if (currentIndex < mainImages.length - 1) {
      currentIndex++;
      selectedImage = null;
      overlayVisible.value = true;



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
    Future.delayed(const Duration(seconds: 5), () {
      opacity.value = 0.0;


      Future.delayed(const Duration(seconds: 1), () {
        overlayVisible.value = false;

      });
    });
  }


}
