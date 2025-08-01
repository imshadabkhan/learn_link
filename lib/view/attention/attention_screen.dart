import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/view/attention/controller.dart';

import '../number_sequence/number_sequence_game.dart';


class AttentionModule extends StatelessWidget {
  final AttentionModuleController attentionModuleController = Get.put(AttentionModuleController());

  AttentionModule({super.key});

  @override
  Widget build(BuildContext context) {
    attentionModuleController.opacityAndVisibilityController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Learn Link"),
            // Obx(() => Text("${attentionModuleController.totalMarks.value}/4")),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: attentionModuleController.marksCounter,
      //   child: const Icon(Icons.arrow_forward),
      // ),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: attentionModuleController
                          .subImages[attentionModuleController.currentIndex.value].length,
                      itemBuilder: (context, index) {
                        final image = attentionModuleController
                            .subImages[attentionModuleController.currentIndex.value][index];
                        return GestureDetector(
                          onTap: () {
                            attentionModuleController.selectedImage.value = image;
                          },
                          child: Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: attentionModuleController.selectedImage.value == image
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
                  SizedBox(height: 20,),
                   Obx(()=> CustomButton(
                     onTap: (){

                       attentionModuleController.currentIndex<attentionModuleController.mainImages.length ?attentionModuleController.marksCounter():Get.to(()=>NumberSequenceGame());


                       },
                     label: attentionModuleController.currentIndex<attentionModuleController.mainImages.length -1 ?"Next":"Next Module",backgroundColor: Colors.teal,textColor: Colors.white,),),

                ],
              ),
            ),
          ),
          Obx(() => attentionModuleController.overlayVisible.value
              ? Positioned.fill(
            child: AnimatedOpacity(
              opacity: attentionModuleController.opacity.value,
              duration: const Duration(seconds: 1),
              child: Image.asset(
                attentionModuleController
                    .mainImages[attentionModuleController.currentIndex.value],
                fit: BoxFit.fitWidth,
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
