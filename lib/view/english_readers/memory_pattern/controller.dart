import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_model.dart';


class PatternMemoryControllerForEnglishReaders extends GetxController {
  RxList<PatternColor> currentSequence = <PatternColor>[].obs;
  RxList<PatternColor> userInput = <PatternColor>[].obs;
  final userController = Get.find<UserController>();  RxBool hasStarted = false.obs;

  RxInt score = 0.obs;
  RxInt errors = 0.obs;
  RxInt time = 0.obs;
  RxBool isShowingPattern = false.obs;
  RxBool isFinished = false.obs;

  Timer? timer;
  int maxRounds = 5; // ✅ limit to 5 rounds
  RxInt currentRound = 0.obs;

  final List<PatternColor> availableColors = [
    PatternColor.red,
    PatternColor.green,
    PatternColor.blue,
    PatternColor.yellow,
  ];

  @override
  void onInit() {
    super.onInit();

    // Removed auto start here — game will start only when user presses Start
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isFinished.value) time++;
    });
  }

  void generateSequence() {
    if (currentRound.value >= maxRounds) {
      endGame();
      return;
    }

    currentRound++;
    userInput.clear();
    isShowingPattern.value = true;
    final random = Random();
    currentSequence.clear();

    int length = 3 + score.value; // harder as score increases
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

    userController.saveScore(
      memoryPatterScore: score.value,
      memoryPatterTime: time.value.toDouble(),
      memoryPatterErrors: errors.value,
    );
  }

  void restart() {
    score.value = 0;
    errors.value = 0;
    time.value = 0;
    currentRound.value = 0;
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

