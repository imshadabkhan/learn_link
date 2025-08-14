import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';

class LetterRecognitionController extends GetxController {
  final userController = Get.find<UserController>();
  var allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  var targetLetter = ''.obs;
  var gridItems = <String>[].obs;
  var score = 0.obs;
  var errors = 0.obs;
  var feedback = ''.obs;
  var elapsedTime = 0.0.obs; // ⏱ reactive time
  var showInstructions = true.obs;
  var currentIndex = 0.obs;
  var isTestComplete = false.obs;

  final stopwatch = Stopwatch();
  final random = Random();
  Timer? _timer;

  final int totalRounds = 10; // limit test to 5 rounds

  void startTest() {
    showInstructions.value = false;
    score.value = 0;
    errors.value = 0;
    feedback.value = '';
    elapsedTime.value = 0;
    currentIndex.value = 0;
    isTestComplete.value = false;

    stopwatch.reset();
    stopwatch.start();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      elapsedTime.value = stopwatch.elapsedMilliseconds / 1000;
    });

    _generateNewRound();
  }

  void _generateNewRound() {
    if (currentIndex.value >= totalRounds) {
      _finishTest();
      return;
    }

    targetLetter.value = allLetters[random.nextInt(allLetters.length)];
    List<String> options = [targetLetter.value];

    while (options.length < 12) {
      String candidate = random.nextBool()
          ? allLetters[random.nextInt(allLetters.length)]
          : String.fromCharCode(random.nextInt(15) + 33);
      if (!options.contains(candidate)) {
        options.add(candidate);
      }
    }
    options.shuffle();
    gridItems.value = options;
  }

  void checkAnswer(String letter) {
    if (!isTestComplete.value) {
      if (letter == targetLetter.value) {
        score.value++;
        feedback.value = '';
      } else {
        errors.value++;
        feedback.value = '';
      }

      currentIndex.value++;

      if (currentIndex.value >= totalRounds) {
        _finishTest(); // Mark test as complete
      } else {
        _generateNewRound();
      }
    }
  }

  void _finishTest() {
    stopwatch.stop();
    _timer?.cancel();
    isTestComplete.value = true;
    feedback.value = '';
    userController.SaveKidsScore(
        letterRecognitionScore: score.value.toInt(),
        letterRecognitionTime: elapsedTime.value.toDouble(),
        letterRecognitionErrors: errors.value.toInt());
  }

  void restartTest() {
    startTest();
  }

  void submitTest() {
    print(
        "Test submitted. Score: ${score.value}, Errors: ${errors.value}, Time: ${elapsedTime.value}");
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
