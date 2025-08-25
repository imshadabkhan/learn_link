import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'controller.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/widgets.dart';

class SpeakingScreen extends StatelessWidget {
  final SpeakingController controller = Get.put(SpeakingController());
  final UserController userController = Get.put(UserController());

  SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        bool isLast = controller.paragraphIndex.value == controller.myParagraphs.length - 1;
        if (controller.isFinished.value || isLast) return const SizedBox.shrink();
        return FloatingActionButton(
          elevation: 0.5,
          backgroundColor: controller.timeTaken.value > 0 ? Colors.green : Colors.grey.shade400,
          onPressed: controller.timeTaken.value > 0 ? controller.updateIndex : null,
          child: const Icon(Icons.arrow_forward),
        );
      }),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.navBar);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text("Speaking Module"),
        actions: [
          GifView.asset(
            'assets/images/readingg.gif',
            height: 100,
            width: 100,
            frameRate: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 20),
                // Paragraph display
                controller.highlightedWords.isEmpty
                    ? Text(
                  controller.myParagraphs[controller.paragraphIndex.value],
                  style:
                  const TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                )
                    : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: controller.highlightedWords.map((word) {
                      bool isWrong =
                          word.startsWith("*") && word.endsWith("*");
                      return TextSpan(
                        text: isWrong
                            ? word.replaceAll("*", "") + " "
                            : word + " ",
                        style: TextStyle(
                          fontSize: 18,
                          color: isWrong ? Colors.red : Colors.black,
                          fontWeight: isWrong
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  controller.myParagraphImages[controller.paragraphIndex.value],
                  height: 200,
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: controller.isListening.value,
                  child: const Text(
                    "🎤 Listening...",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Recognized: ${controller.recognizedText.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  "Pronunciation Accuracy: ${controller.pronunciationScore.value.toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "Reading Speed: ${controller.readingSpeed.value.toStringAsFixed(2)} WPM",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "Time Taken: ${controller.timeTaken.value} sec",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Widgets.heightSpaceH05,
                Text(
                  "Total Errors: ${controller.totalErrors.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Widgets.heightSpaceH05,
                Text(
                  "Wrong Words: ${controller.wrongWords.join(', ')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Widgets.heightSpaceH05,
                Text(
                  "Total Score: ${controller.totalScore.value.toStringAsFixed(2)} / 100",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "Reading Fluency: ${controller.readingFluency.value.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Widgets.heightSpaceH05,
                Widgets.heightSpaceH1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.isListening.value
                          ? null
                          : () {
                        if (!controller.hasSeenInstructions.value) {
                          _showInstructions(context);
                        } else {
                          controller.startListening();
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start Reading"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: controller.isListening.value
                          ? controller.stopListening
                          : null,
                      icon: const Icon(Icons.stop),
                      label: const Text("Stop"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (controller.isFinished.value) ...[
                  const Divider(height: 40, thickness: 2),
                           SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(

                      onPressed: () {
                        final result = controller.getSpeakingResults();
                        userController.saveScore(
                                                  speakingResults: result,
                        );
                        Get.toNamed(AppRoutes.attentionModule);
                      },
                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Next Module",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Speaking Module Instructions",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You will be shown a paragraph.\n\n"
              "Read it aloud clearly at a normal pace.\n\n"
              "The microphone will start listening when you click 'Begin'.\n\n"
              "You will be scored on pronunciation, speed, and accuracy.\n\n"
              "Good luck!",
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
              controller.hasSeenInstructions.value = true;
              Get.back();
              controller.startListening();
            },
            child: const Text("Begin"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
