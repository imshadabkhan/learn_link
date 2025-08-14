import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/small_kids/letter_recognition/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LetterRecognitionPage extends StatelessWidget {
  final LetterRecognitionController controller =
  Get.put(LetterRecognitionController());
  final userController=Get.find<UserController>();
  final Random random = Random();

  LetterRecognitionPage({super.key});

  Widget _styledLetterButton(String text) {
    double fontSize = random.nextDouble() * 30 + 20;
    Color color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    FontWeight weight =
    random.nextBool() ? FontWeight.bold : FontWeight.normal;
    double rotation = (random.nextDouble() * 60 - 30) * pi / 180;
    bool hideTop = random.nextBool();
    bool hideBottom = !hideTop && random.nextBool();

    return Transform.rotate(
      angle: rotation,
      child: ClipRect(
        child: Align(
          alignment: hideTop
              ? Alignment.bottomCenter
              : hideBottom
              ? Alignment.topCenter
              : Alignment.center,
          heightFactor: hideTop || hideBottom ? 0.6 : 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () => controller.checkAnswer(text),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: weight,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('🔤 Letter Recognition'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.showInstructions.value) {
          return _buildInstructions();
        } else {
          return _buildGame(context);
        }
      }),
    );
  }

  Widget _buildInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Letter Recognition!\n\n"
                  "You'll see a letter at the top. Your task is to find and tap "
                  "the matching letter from the grid.\n\n"
                  "Try to be quick and accurate. The timer will start when you tap 'Go'.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, padding: const EdgeInsets.all(16)),
              onPressed: controller.startTest,
              child: const Text(
                "Go",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGame(contex) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => controller.isTestComplete.value?Container():Text(
              "Find the letter: ${controller.targetLetter.value}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            )),
            const SizedBox(height: 20),

            // Feedback
            Obx(() => Text(
              controller.feedback.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: controller.feedback.value.contains('✅')
                    ? Colors.green
                    : Colors.red,
              ),
            )),
            const SizedBox(height: 20),

            // Grid of styled letter buttons (hide when test complete)
            Obx(() {
              if (controller.isTestComplete.value) {
                return const SizedBox();
              }
              return GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: controller.gridItems
                    .map((letter) => _styledLetterButton(letter))
                    .toList(),
              );
            }),
            const SizedBox(height: 16),

            // Score & Errors
            Obx(() => Text(
              'Score: ${controller.score.value}  |  Errors: ${controller.errors.value}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            )),
            const SizedBox(height: 8),

            // Stopwatch time
            Obx(() => Text(
              'Time: ${controller.elapsedTime.value.toStringAsFixed(0)} seconds',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            )),
            const SizedBox(height: 24),

            // Buttons section
            Obx(() {
              if (controller.isTestComplete.value) {
                return Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Submit Test'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(16)),
                      onPressed: (){
                        userController.showKidsSavedScores(context: contex);
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Restart Test'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.all(16)),
                      onPressed: controller.restartTest,
                    ),
                  ],
                );
              } else {
                return ElevatedButton.icon(
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Restart Test'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: controller.startTest,
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
