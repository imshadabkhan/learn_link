import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/view/english_readers/phoneme_matching/audio_quiz_controller.dart';

class AudioQuizScreenForEnglishReaders extends StatelessWidget {
  final controller = Get.put(AudioQuizScreenForEnglishReadersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎧 Audio Confusion Quiz"),
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.navBar);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        // Instructions before start
        if (!controller.started.value) {
          return _buildInstructions();
        }

        // Quiz finished
        if (controller.isFinished.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("✅ Quiz Completed!",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(
                    "Score: ${controller.score}/${controller.questions.length}",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    "⏱ Time: ${controller.elapsedTime.value.inSeconds}s",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    "❌ Errors: ${controller.errors}",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: () =>
                            Get.toNamed(AppRoutes.patternMemoryScreenForEnglishReaders),
                        child: Text(
                          "Next Module",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: controller.reset,
                        child: Text(
                          "Restart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        // Quiz questions in progress
        final Map<String, dynamic> question =
        controller.questions[controller.currentIndex.value]
        as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Score, time, errors row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("⏱ ${controller.elapsedTime.value.inSeconds}s",
                      style: TextStyle(color: Colors.black)),
                  Text("✅ ${controller.score}",
                      style: TextStyle(color: Colors.black)),
                  Text("❌ ${controller.errors}",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Question ${controller.currentIndex.value + 1} of ${controller.questions.length}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: controller.playCurrentAudio,
                label: Text(
                  "Play Sound",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
              SizedBox(height: 30),
              ...List.generate(question["options"]!.length, (i) {
                final option = question["options"]?[i];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () => controller.selectAnswer(option),
                    child: Text(option,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                );
              })
            ],
          ),
        );
      }),
    );
  }

  // Instructions before starting
  Widget _buildInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "📢 Instructions",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              "In this quiz, you'll hear a sound.\nYour task is to identify the correct word from the options.\nThe words will sound similar like 'pat' or 'bat'.\n\nGood luck!",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: controller.startQuiz, // Start timer & quiz
              child: Text("▶️ Start Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
