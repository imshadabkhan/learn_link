import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/view/letter_reversal/controller/controller.dart';

class LetterQuizScreen extends StatelessWidget {
  final controller = Get.put(LetterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Letter/Digit Reversal Quiz')),
      body: Obx(() {
        final item = controller.currentItem;
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    color:
                        controller.isCorrect.value! ? Colors.green : Colors.red,
                  ),
                ),
              SizedBox(height: 20),
             Obx(()=>   controller.quizCompleted.value!=true? Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 ElevatedButton.icon(
                   onPressed: controller.playCurrentSound,
                   icon: Icon(Icons.volume_up),
                   label: Text('Play Sound Again'),
                 ),
                 SizedBox(width: 20),
                 Obx(
                       () => ElevatedButton.icon(
                     style: ButtonStyle(
                         backgroundColor: WidgetStateProperty.all(
                             controller.isOptionDisabled.value == true
                                 ? Colors.green
                                 : Colors.red)),
                     onPressed: controller.nextQuestion,
                     icon: Icon(Icons.skip_next),
                     label: Text('Next'),
                   ),
                 ),
               ],
             ):CustomButton(
               onTap: (){
                 // Navigator.pushNamed(context, AppRoutes.letterReversal);
                 Get.toNamed(AppRoutes.speakingModule);
               },
               label: "Next Module",
               backgroundColor: Colors.green,
             ),),

            ],
          ),
        );
      }),
    );
  }
}
