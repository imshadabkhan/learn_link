import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/modules/attention/controller.dart';


class AttentionModule extends StatelessWidget {
  AttentionModuleController attentionModuleController=Get.put(AttentionModuleController());

  AttentionModule({super.key});
  initState() {
    attentionModuleController.opacityAndVisibilityController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Learn Link"),
            Text("${attentionModuleController.totalMarks}/10")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: attentionModuleController.marksCounter,
        child: const Icon(Icons.arrow_forward),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: attentionModuleController
                    .subImages[attentionModuleController.currentIndex].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      attentionModuleController.selectedImage = attentionModuleController
                          .subImages[attentionModuleController.currentIndex][index];

                      debugPrint(
                          "Selected: ${attentionModuleController.subImages[attentionModuleController.currentIndex][index]}");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: attentionModuleController.selectedImage ==
                              attentionModuleController.subImages[
                              attentionModuleController.currentIndex][index]
                              ? Colors.green
                              : Colors.transparent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        attentionModuleController
                            .subImages[attentionModuleController.currentIndex][index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (attentionModuleController.overlayVisible.value)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: attentionModuleController.opacity.value,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                    attentionModuleController
                        .mainImages[attentionModuleController.currentIndex],
                    fit: BoxFit.fitWidth),
              ),
            ),
        ],
      ),
    );
  }
}
