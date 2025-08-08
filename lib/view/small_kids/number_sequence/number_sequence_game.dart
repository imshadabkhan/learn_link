import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';

import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/attention/attention_screen.dart';
import 'package:learn_link/view/small_kids/number_sequence/controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/small_kids/phoneme_matching/audio_quiz.dart';

class NumberSequenceGame extends StatelessWidget {
  final NumberSequenceController controller = Get.put(NumberSequenceController());

  NumberSequenceGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Number Sequence Game")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.showInstructions.value) {
            return buildInstructionsDialog(context);
          }

          return controller.gameOver.value
              ? buildGameReport()
              : buildGameUI();
        }),
      ),
    );
  }

  // ✅ Instruction Dialog
  Widget buildInstructionsDialog(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Texts.textBold("🧠 Number Sequence Instructions", size: 18),
            const SizedBox(height: 12),
            Texts.textNormal("• Tap numbers from 1 to 9 in order."),
            Texts.textNormal("• Try to be fast and accurate."),
            Texts.textNormal("• Your mistakes and time will be recorded."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.showInstructions.value = false;
                controller.resetGame();
              },
              child: const Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Game UI
  Widget buildGameUI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Texts.textNormal("⏱️ ${controller.currentTime.value.inSeconds}s"),
            Texts.textNormal("Next: ${controller.currentNumber}"),
            Texts.textNormal("Wrong: ${controller.wrongAttempts}"),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: controller.numbers.map((num) {
              return GestureDetector(
                onTap: () => controller.onNumberTap(num),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "$num",
                      style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ✅ Game Report UI
  Widget buildGameReport() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Texts.textBold("🎉 Game Over!", size: 20),
          const SizedBox(height: 10),
          Texts.textNormal("Time: ${controller.currentTime.value.inSeconds} seconds"),
          Texts.textNormal("Mistakes: ${controller.wrongAttempts}"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.showInstructions.value = true;
                  controller.resetGame();
                },
                child: const Text("Play Again"),
              ),

              ElevatedButton(
                onPressed: () {


                  Get.to(()=>AudioQuizScreen());
                },
                child: const Text("Next Module"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

