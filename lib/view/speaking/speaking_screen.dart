import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/app_routes.dart';
import 'controller.dart';

class SpeakingScreen extends StatelessWidget {
  final SpeakingController controller = Get.put(SpeakingController());
  final UserController userController = Get.put(UserController());
  SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speaking Module"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 20),

                // Display paragraph
                controller.highlightedWords.isEmpty
                    ? Text(
                  controller.myParagraphs[controller.paragraphIndex.value],
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                )
                    : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: controller.highlightedWords.map((word) {
                      bool isWrong = word.startsWith("*") && word.endsWith("*");
                      return TextSpan(
                        text: isWrong ? word.replaceAll("*", "") + " " : word + " ",
                        style: TextStyle(
                          fontSize: 18,
                          color: isWrong ? Colors.red : Colors.black,
                          fontWeight: isWrong ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Image
                Image.asset(
                  controller.myParagraphImages[controller.paragraphIndex.value],
                  height: 200,
                ),
                const SizedBox(height: 20),

                // Listening indicator
                Visibility(
                  visible: controller.isListening.value,
                  child: const Text(
                    "🎤 Listening...",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),

                // Recognized Text
                Text(
                  "Recognized: ${controller.recognizedText.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 10),

                // Metrics
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
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                Widgets.heightSpaceH05,
                Text(
                  "Wrong Words: ${controller.wrongWords.join(', ')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                Widgets.heightSpaceH05,
                Text(
                  "Total Score: ${controller.totalScore.value.toStringAsFixed(2)} / 100",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Start / Stop Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.isListening.value
                          ? null
                          : controller.startListening,
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
          Obx(()=>Text(
            "Final Speaking Score: ${controller.finalScore.value.toStringAsFixed(2)} / 100",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // controller.updateIndex();

                         userController.saveScore(readingScore:controller.finalScore.value.toInt());
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
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),
                  ),
                ],


              ],
            ),
          );
        }),
      ),

      // Floating FAB to go to next paragraph (only if not finished or last)
      floatingActionButton: Obx(() {
        bool isLast = controller.paragraphIndex.value == controller.myParagraphs.length - 1;
        if (controller.isFinished.value || isLast) {
          return const SizedBox.shrink(); // Hide FAB
        }
        return FloatingActionButton(
          elevation: 0.5,
          backgroundColor: controller.timeTaken.value > 0
              ? Colors.green
              : Colors.grey.shade400,
          onPressed: controller.timeTaken.value > 0
              ? () {
            controller.updateIndex();
          }
              : null,
          child: const Icon(Icons.arrow_forward),
        );
      }),
    );
  }
}

