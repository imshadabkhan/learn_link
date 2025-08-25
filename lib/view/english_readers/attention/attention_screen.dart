import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/view/english_readers/attention/controller.dart';
import 'package:learn_link/view/small_kids/number_sequence/number_sequence_game.dart';




class AttentionModule extends StatelessWidget {
  final AttentionModuleController attentionModuleController =
  Get.put(AttentionModuleController());

  AttentionModule({super.key});

  @override
  Widget build(BuildContext context) {
    // Show instructions before starting
    Future.microtask(() {
      if (!attentionModuleController.hasSeenInstructions.value) {
        _showInstructions(context);
      } else {
        attentionModuleController.opacityAndVisibilityController();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.navBar);
            },
            child: Icon(Icons.arrow_back)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Learn Link"),
            // Obx(() => Text("${attentionModuleController.totalMarks.value}/4")),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                        () => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: attentionModuleController
                          .subImages[
                      attentionModuleController.currentIndex.value]
                          .length,
                      itemBuilder: (context, index) {
                        final image = attentionModuleController
                            .subImages[
                        attentionModuleController.currentIndex.value][index];
                        return GestureDetector(
                          onTap: () {
                            attentionModuleController.selectedImage.value =
                                image;
                          },
                          child: Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: attentionModuleController
                                      .selectedImage.value ==
                                      image
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                        () => CustomButton(
                      onTap: () {
                        attentionModuleController.currentIndex <
                            attentionModuleController.mainImages.length
                            ? attentionModuleController.marksCounter()
                            : Get.toNamed(AppRoutes.audioQuizScreenForEnglishReaders);
                      },
                      label: attentionModuleController.currentIndex <
                          attentionModuleController.mainImages.length - 1
                          ? "Next"
                          : "Next Module",
                      backgroundColor: Colors.teal,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
                () => attentionModuleController.overlayVisible.value
                ? Positioned.fill(
              child: AnimatedOpacity(
                opacity: attentionModuleController.opacity.value,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  attentionModuleController.mainImages[
                  attentionModuleController.currentIndex.value],
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Attention Module Instructions",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
        ),
        content: const Text(
          "You will see a main image for a few seconds.\n\n"
              "After it disappears, select the exact same image from the options below.\n\n"
              "You get points for each correct match.\n\n"
              "Click 'Start' when you're ready to begin.",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              attentionModuleController.hasSeenInstructions.value = true;
              Get.back();
              attentionModuleController.opacityAndVisibilityController();
            },
            child: const Text("Start"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
