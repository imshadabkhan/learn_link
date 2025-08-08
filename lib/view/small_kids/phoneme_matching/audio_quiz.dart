import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/small_kids/phoneme_matching/audio_quiz_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/small_kids/phoneme_matching/audio_quiz_controller.dart';

class AudioQuizScreen extends StatelessWidget {
  final controller = Get.put(AudioQuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🎧 Audio Confusion Quiz")),
      body: Obx(() {
        // 👇 Show Instructions First
        if (!controller.started.value) {
          return _buildInstructions();
        }

        // 👇 After quiz finishes
        if (controller.isFinished.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("✅ Quiz Completed!", style: TextStyle(fontSize: 20, color: Colors.black)),
                Text(
                  "Score: ${controller.score}/${controller.questions.length}",
                  style: TextStyle(color: Colors.black),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: controller.reset,
                  child: Text("🔁 Restart"),
                ),
              ],
            ),
          );
        }

        // 👇 Quiz Questions
        final Map<String, dynamic> question =
        controller.questions[controller.currentIndex.value] as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Question ${controller.currentIndex.value + 1} of ${controller.questions.length}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: controller.playCurrentAudio,
                icon: Icon(Icons.play_arrow),
                label: Text("🔊 Play Sound"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              SizedBox(height: 30),
              ...List.generate(question["options"]!.length, (i) {
                final option = question["options"]?[i];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade300),
                    onPressed: () => controller.selectAnswer(option),
                    child: Text(option, style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                );
              })
            ],
          ),
        );
      }),
    );
  }

  // 👇 Instructions before starting
  Widget _buildInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "📢 Instructions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
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
              onPressed: () {
                controller.started.value = true;
              },
              child: Text("▶️ Start Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}

