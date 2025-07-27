import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/view/memory_pattern/controller.dart';
import 'package:learn_link/view/memory_pattern/memory_pattern_model.dart';


class PatternMemoryScreen extends StatelessWidget {
  final controller = Get.put(PatternMemoryController());

  Color getColor(PatternColor color) {
    switch (color) {
      case PatternColor.red:
        return Colors.red;
      case PatternColor.green:
        return Colors.green;
      case PatternColor.blue:
        return Colors.blue;
      case PatternColor.yellow:
        return Colors.yellow;
    }
  }

  PatternMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧠 Pattern Memory")),
      body: Obx(() {
        if (controller.isFinished.value) {
          final result = controller.getResult();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Texts.textBold("✅ Score: ${result['patternMemory']['score']}",size: 12),
                Texts.textBold("⏱️ Time: ${result['patternMemory']['time']} sec",size: 12),
                Texts.textBold("❌ Errors: ${result['patternMemory']['errors']}",size: 12),
                ElevatedButton(
                  onPressed: controller.restart,
                  child:  Texts.textBold("Restart"),
                ),
              ],
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Repeat the color pattern", style: TextStyle(fontSize: 20,color: Colors.black)),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isShowingPattern.value) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.currentSequence
                      .map((color) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 50,
                    height: 50,
                    color: getColor(color),
                  ))
                      .toList(),
                );
              } else {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.availableColors.map((color) {
                    return GestureDetector(
                      onTap: () => controller.handleUserTap(color),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: getColor(color),
                      ),
                    );
                  }).toList(),
                );
              }
            }),
            const SizedBox(height: 30),
            Texts.textBold("Score: ${controller.score}  Time: ${controller.time.value}s"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.endGame,
              child:
              Texts.textBold("End Game"),
            )
          ],
        );
      }),
    );
  }
}
