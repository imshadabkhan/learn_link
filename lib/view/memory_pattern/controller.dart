import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

import 'package:learn_link/view/memory_pattern/memory_pattern_model.dart';

class PatternMemoryController extends GetxController {
  RxList<PatternColor> currentSequence = <PatternColor>[].obs;
  RxList<PatternColor> userInput = <PatternColor>[].obs;

  RxInt score = 0.obs;
  RxInt errors = 0.obs;
  RxInt time = 0.obs;
  RxBool isShowingPattern = false.obs;
  RxBool isFinished = false.obs;

  Timer? timer;

  final List<PatternColor> availableColors = [
    PatternColor.red,
    PatternColor.green,
    PatternColor.blue,
    PatternColor.yellow,
  ];

  @override
  void onInit() {
    super.onInit();
    startTimer();
    generateSequence();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isFinished.value) time++;
    });
  }

  void generateSequence() {
    userInput.clear();
    isShowingPattern.value = true;
    final random = Random();
    currentSequence.clear();
    int length = 3 + score.value; // sequence gets longer with score

    for (int i = 0; i < length; i++) {
      currentSequence.add(availableColors[random.nextInt(4)]);
    }

    Future.delayed(Duration(milliseconds: 700 * length), () {
      isShowingPattern.value = false;
    });
  }

  void handleUserTap(PatternColor color) {
    if (isShowingPattern.value || isFinished.value) return;

    userInput.add(color);

    int index = userInput.length - 1;
    if (userInput[index] != currentSequence[index]) {
      errors++;
      generateSequence();
    } else if (userInput.length == currentSequence.length) {
      score++;
      generateSequence();
    }
  }

  void endGame() {
    isFinished.value = true;
    timer?.cancel();
  }

  void restart() {
    score.value = 0;
    errors.value = 0;
    time.value = 0;
    isFinished.value = false;
    generateSequence();
    startTimer();
  }

  Map<String, dynamic> getResult() {
    return {
      "patternMemory": {
        "score": score.value,
        "time": time.value,
        "errors": errors.value
      }
    };
  }
}
