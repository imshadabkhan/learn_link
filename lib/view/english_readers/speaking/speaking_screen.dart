import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'controller.dart';


class SpeakingScreen extends StatelessWidget {
  final SpeakingController controller = Get.put(SpeakingController());
  final UserController userController = Get.put(UserController());

  SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.navBar);
            },
            child: Icon(Icons.arrow_back)),
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
                Text("Reading Fluency: ${controller.readingFluency.value.toStringAsFixed(1)}%",   style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Reading Comprehension: ${controller.readingComprehensionScore.value.toStringAsFixed(1)}%"  ,style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Sight Word Recognition: ${controller.sightWordRecognitionScore.value.toStringAsFixed(1)}%",  style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Phoneme Deletion: ${controller.phonemeDeletionScore.value.toStringAsFixed(1)}%",  style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Rhyming: ${controller.rhymingScore.value.toStringAsFixed(1)}%",  style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Syllable Segmentation: ${controller.syllableSegmentationScore.value.toStringAsFixed(1)}%",  style: const TextStyle(fontSize: 16, color: Colors.black),),
                Widgets.heightSpaceH05,
                Text("Non-Word Reading: ${controller.nonWordReadingScore.value.toStringAsFixed(1)}%",  style: const TextStyle(fontSize: 16, color: Colors.black),),

                const SizedBox(height: 20),

                // Start / Stop Buttons
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
                  Obx(
                        () => Text(
                      "Final Speaking Score: ${controller.finalScore.value.toStringAsFixed(2)} / 100",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        userController.saveScore(
                            readingScore:
                            controller.finalScore.value.toInt());
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

      floatingActionButton: Obx(() {
        bool isLast = controller.paragraphIndex.value ==
            controller.myParagraphs.length - 1;
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
              controller.hasSeenInstructions.value = true; // ✅ Mark as seen
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


