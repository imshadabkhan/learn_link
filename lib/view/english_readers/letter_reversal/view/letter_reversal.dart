import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/english_readers/letter_reversal/controller/controller.dart';

class LetterQuizScreen extends StatelessWidget {
  final controller = Get.put(LetterController());
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Letter/Digit Reversal Quiz')),
      body: Obx(() {
        if (controller.showInstructions.value) {
          return _buildInstructionView();
        }

        final item = controller.currentItem;
        return _buildQuizView(item);
      }),
    );
  }

// 📌 Instruction UI
  Widget _buildInstructionView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Texts.textBold(
              "📢 Instructions",
            ),
          ),
          Widgets.heightSpaceH2,
          Texts.textNormal("You will hear a sound of a letter or a digit.",
              textAlign: TextAlign.start, size: 16),
          Widgets.heightSpaceH1,
          Texts.textNormal("Select the correct option from the given choices.",
              textAlign: TextAlign.start, size: 16),
          Widgets.heightSpaceH1,
          Texts.textNormal("You can replay the sound if needed.",
              textAlign: TextAlign.start, size: 16),
          Widgets.heightSpaceH1,
          Texts.textNormal("Once selected, the answer cannot be changed.",
              textAlign: TextAlign.start, size: 16),
          Widgets.heightSpaceH1,
          Texts.textNormal("At the end, your score will be displayed.",
              textAlign: TextAlign.start, size: 16),
          Widgets.heightSpaceH1,
          Widgets.heightSpaceH3,
          Center(
            child: ElevatedButton(
              onPressed: () {
                controller.showInstructions.value = false;
                controller.playCurrentSound();
              },
              child: Texts.textNormal("OK, Start Quiz",
                  textAlign: TextAlign.start),
            ),
          ),
        ],
      ),
    );
  }

// 📌 Quiz UI (Your existing code moved here)
  Widget _buildQuizView(QuizItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Which sound did you hear?',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 16,
            children: item.options.map((option) {
              final isSelected = controller.selectedAnswer.value == option;
              return GestureDetector(
                onTap: controller.isOptionDisabled.value
                    ? null
                    : () => controller.selectAnswer(option),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (controller.isCorrect.value == null
                              ? Colors.grey
                              : controller.isCorrect.value!
                                  ? Colors.green
                                  : Colors.red)
                          : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      option.toUpperCase(),
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          if (controller.isCorrect.value != null)
            Text(
              controller.isCorrect.value! ? 'Correct! 🎉' : 'Wrong ❌',
              style: TextStyle(
                fontSize: 24,
                color: controller.isCorrect.value! ? Colors.green : Colors.red,
              ),
            ),
          SizedBox(height: 20),
          Obx(
            () => controller.quizCompleted.value != true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.playCurrentSound,
                        icon: Icon(Icons.volume_up),
                        label: Text('Play Sound Again'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            controller.isOptionDisabled.value
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onPressed: controller.nextQuestion,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        label: Texts.textNormal(
                          'Next',
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  )
                : CustomButton(
                    onTap: () async {
                      await controller.userController.saveScore(
                          letterReversalScore: controller.finalResult.value);
                      Get.toNamed(AppRoutes.speakingModule);
                    },
                    label: "Next Module",
                    backgroundColor: Colors.green,
                  ),
          ),
        ],
      ),
    );
  }
}
