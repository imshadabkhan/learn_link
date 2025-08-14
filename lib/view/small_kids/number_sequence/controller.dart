import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';

class NumberSequenceController extends GetxController {
  final userController=Get.find<UserController>();
  RxList<int> numbers = <int>[].obs;
  RxInt currentNumber = 1.obs;
  RxInt wrongAttempts = 0.obs;
  Rx<Duration> currentTime = Duration.zero.obs;
  RxBool gameOver = false.obs;
  RxBool showInstructions = true.obs;
  late Stopwatch stopwatch;
  RxInt currentScore=0.obs;
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
      currentScore.value++;
      currentNumber.value++;

      if (currentNumber.value > 9) {
        saveScore();
        gameOver.value = true;
        stopwatch.stop();
        timer?.cancel();
      }
    } else {
      wrongAttempts.value++;
    }
  }

  void saveScore()async{
    await userController.SaveKidsScore(numberSequenceErrors: wrongAttempts.value,numberSequenceScore: currentScore.value.toInt(),numberSequenceTime:currentTime.value.inSeconds.toDouble());

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
