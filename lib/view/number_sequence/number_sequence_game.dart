import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';

import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/attention/attention_screen.dart';
import 'package:learn_link/view/number_sequence/controller.dart';

class NumberSequenceGame extends StatelessWidget {
  final controller = Get.put(NumberSequenceController());
  final userController=Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Dyslexia Screening - Number Order Test", style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => controller.gameOver.value
            ? buildGameReport()
            : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Texts.textNormal("⏱️ ${controller.currentTime.value.inSeconds}s"),
                Texts.textNormal("Next: ${controller.currentNumber}",),
                Texts.textNormal("Wrong: ${controller.wrongAttempts}",),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: controller.numbers.map((num) {
                  return GestureDetector(
                    onTap: () => controller.onNumberTap(num),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade300,
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
                          style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildGameReport() {
    int totalNumbers = 9;
    int correct = totalNumbers - controller.wrongAttempts.value;
    double accuracy = (correct / totalNumbers) * 100;



    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Texts.textNormal("🎉 Test Complete!"),
        SizedBox(height: 10),
        Texts.textNormal("⏱️ Time Taken: ${controller.currentTime.value.inSeconds} seconds",),
        Texts.textNormal("❌ Wrong Attempts: ${controller.wrongAttempts}",),
        Texts.textNormal("🎯 Accuracy: ${accuracy.toStringAsFixed(1)}%",),
        SizedBox(height: 20),
        // Text(screeningMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: controller.resetGame,
              icon: Icon(Icons.replay),
              label: Text("Try Again"),
            ),
            Widgets.widthSpaceW1,
            GestureDetector(
              onTap: (){
                userController.saveScore(numberSequenceAccuracy:accuracy.toDouble());
                Get.to(()=>AttentionModule());
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(8)),
                width: 150,
                height: 40,
                child: Center(child: Text('Next Module')),
              ),
            ),
          ],
        )
      ],
    );
  }
}
