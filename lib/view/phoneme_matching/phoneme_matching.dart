import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:learn_link/view/phoneme_matching/phoneme_controller.dart';


class PhonemeMatchingScreen extends StatelessWidget {
  final PhonemeMatchingController controller = Get.put(PhonemeMatchingController());
  final player = AudioPlayer();

  PhonemeMatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!controller.isFinished.value) {
        controller.incrementTime();
      } else {
        timer.cancel();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Phoneme Matching")),
      body: Obx(() {
        if (controller.isFinished.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("✅ Score: ${controller.score}"),
                Text("⏱️ Time: ${controller.timeTaken} seconds"),
                Text("❌ Errors: ${controller.errors}"),
                ElevatedButton(
                  onPressed: controller.restart,
                  child: const Text("Restart"),
                ),
              ],
            ),
          );
        }

        final question = controller.questions[controller.currentQuestionIndex.value];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  player.play(AssetSource(question.soundAsset));
                },
                child: const Text("🔊 Play Sound"),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: question.options.map((option) {
                  return ElevatedButton(
                    onPressed: () => controller.checkAnswer(option),
                    child: Text(option),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Text("Question ${controller.currentQuestionIndex.value + 1} / ${controller.questions.length}"),
              Text("Time: ${controller.timeTaken.value}s"),
            ],
          ),
        );
      }),
    );
  }
}
