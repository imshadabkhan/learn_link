import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/view/small_kids/memory_pattern/controller.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_model.dart';


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

        if (!controller.hasStarted.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Texts.textBold("🧠 Pattern Memory Instructions", size: 18),
                      const SizedBox(height: 16),
                      Texts.textNormal("• Watch the color sequence.\n• Tap the colors in the same order.\n• Each correct round gets harder.\n• Try to get the highest score!"),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start Game"),
                        onPressed: () {
                          controller.hasStarted.value = true;
                          controller.startTimer();
                          controller.generateSequence();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (controller.isFinished.value) {
          final result = controller.getResult();
          return Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Texts.textBold("🎉 Game Over!", size: 20),
                    const SizedBox(height: 12),
                    Texts.textNormal("✅ Score: ${result['patternMemory']['score']}"),
                    Texts.textNormal("⏱️ Time: ${result['patternMemory']['time']} sec"),
                    Texts.textNormal("❌ Errors: ${result['patternMemory']['errors']}"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.restart,
                          icon: const Icon(Icons.replay),
                          label: const Text("Restart"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed(AppRoutes.numberSequence),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Texts.textBold("👀 Repeat the Color Pattern", size: 18),
              const SizedBox(height: 30),
              Obx(() {
                return controller.isShowingPattern.value
                    ? Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.currentSequence
                      .map((color) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: getColor(color),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2)),
                      ],
                    ),
                  ))
                      .toList(),
                )
                    : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.availableColors
                      .map((color) => GestureDetector(
                    onTap: () => controller.handleUserTap(color),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: getColor(color),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 4)),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                );
              }),
              const SizedBox(height: 30),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Texts.textNormal("⭐ Score: ${controller.score}"),
                  Texts.textNormal("⏱ Time: ${controller.time.value}s"),
                ],
              )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: controller.endGame,
                icon: const Icon(Icons.stop),
                label: const Text("End Game"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      }),

    );
  }
}
