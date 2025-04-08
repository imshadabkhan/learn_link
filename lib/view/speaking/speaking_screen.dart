import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/view/speaking/controller.dart';

class SpeakingScreen extends StatelessWidget {
  SpeakingController speakingController = Get.put(SpeakingController());

  SpeakingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        speakingController.updateIndex();
      }),
      appBar: AppBar(
        title: Text("Speaking Module"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => LinearProgressIndicator(
                  value: speakingController.progress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
            Obx(
              () => Text(
                speakingController
                    .myParagraphs[speakingController.paragraphIndex.value]
                    .toString(),
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),

            Obx(()=>   Image.asset(speakingController
                .myParagraphImages[speakingController.paragraphIndex.value]
                .toString()),),

          ],
        ),
      ),
    );
  }
}
