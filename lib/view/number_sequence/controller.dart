import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class NumberSequenceController extends GetxController {
  RxList<int> numbers = <int>[].obs;
  RxInt currentNumber = 1.obs;
  RxInt wrongAttempts = 0.obs;
  Rx<Duration> currentTime = Duration.zero.obs;
  RxBool gameOver = false.obs;

  late Stopwatch stopwatch;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    resetGame();
  }

  void generateNumbers() {
    numbers.value = List.generate(9, (index) => index + 1)..shuffle(Random());
  }

  void startTimer() {
    stopwatch = Stopwatch()..start();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      currentTime.value = stopwatch.elapsed;
    });
  }

  void onNumberTap(int tappedNumber) {
    if (gameOver.value) return;

    if (tappedNumber == currentNumber.value) {
      numbers.remove(tappedNumber);
      currentNumber.value++;

      if (currentNumber.value > 9) {
        gameOver.value = true;
        stopwatch.stop();
        timer?.cancel();
      }
    } else {
      wrongAttempts.value++;
    }
  }

  void resetGame() {
    currentNumber.value = 1;
    wrongAttempts.value = 0;
    currentTime.value = Duration.zero;
    gameOver.value = false;
    generateNumbers();
    startTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    stopwatch.stop();
    super.onClose();
  }
}
