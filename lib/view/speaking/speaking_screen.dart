import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SpeakingScreen extends StatelessWidget {
  final SpeakingController controller = Get.put(SpeakingController());

   SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speaking Module"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => LinearProgressIndicator(
                    value: controller.progress.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )),
              SizedBox(height: 20),
              Obx(() {
                if (controller.highlightedWords.isEmpty) {
                  return Text(
                    controller.myParagraphs[controller.paragraphIndex.value],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return RichText(
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
                            fontWeight:
                                isWrong ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              }),
              SizedBox(height: 20),
              Obx(() => Image.asset(
                    controller
                        .myParagraphImages[controller.paragraphIndex.value],
                    height: 200,
                  )),
              SizedBox(height: 20),
              Obx(() => Text(
                    "Recognized Text: ${controller.recognizedText.value}",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Pronunciation Accuracy: ${controller.pronunciationScore.value.toStringAsFixed(2)}%",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Reading Speed: ${controller.readingSpeed.value.toStringAsFixed(2)} WPM",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Time Taken: ${controller.timeTaken.value} sec",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Total Errors: ${controller.totalErrors.value}",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Wrong Words: ${controller.wrongWords.join(', ')}",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    "Total Score: ${controller.totalScore.value.toStringAsFixed(2)} / 100",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
              SizedBox(height: 20),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: controller.isListening.value
                            ? null
                            : controller.startListening,
                        child: Text("Start Reading"),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: controller.isListening.value
                            ? controller.stopListening
                            : null,
                        child: Text("Stop"),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          elevation: 0.5,
          backgroundColor: controller.timeTaken.value != 0
              ? Colors.green
              : Colors.transparent,
          onPressed: () {
            if (controller.timeTaken.value > 0) {
              controller.updateIndex();
            }

          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
