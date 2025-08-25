import 'dart:async';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:learn_link/controller/usercontroller.dart';

class AudioQuizScreenForEnglishReadersController extends GetxController {
  final userController = Get.find<UserController>();
  final AudioPlayer player = AudioPlayer();

  final RxInt currentIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxInt errors = 0.obs;
  final RxBool isFinished = false.obs;
  final RxBool started = false.obs;

  final Rx<Duration> elapsedTime = Duration.zero.obs;

  late Stopwatch stopwatch;
  Timer? timer;

  final questions = [
    {
      "audio": "pronunciation_en_bat.mp3",
      "options": ["PAT", "BAT"],
      "answer": "BAT",
    },
    {
      "audio": "pronunciation_en_dog.mp3",
      "options": ["DOCK", "DOG"],
      "answer": "DOG",
    },
    {
      "audio": "pronunciation_en_sip.mp3",
      "options": ["SIP", "ZIP"],
      "answer": "SIP",
    },
    {
      "audio": "pronunciation_en_van.mp3",
      "options": ["VAN", "FAN"],
      "answer": "VAN",
    },
    {
      "audio": "pronunciation_en_thin.mp3",
      "options": ["FIN", "THIN"],
      "answer": "THIN",
    },
  ];

  void startQuiz() {
    started.value = true;
    score.value = 0;
    errors.value = 0;
    currentIndex.value = 0;
    isFinished.value = false;
    stopwatch = Stopwatch()..start();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime.value = stopwatch.elapsed;
    });

    playCurrentAudio();
  }

  void playCurrentAudio() async {
    await player.stop();
    await player.play(AssetSource('sounds/${questions[currentIndex.value]["audio"]}'));
  }

  void selectAnswer(String selected) {
    if (selected == questions[currentIndex.value]["answer"]) {
      score.value++;
    } else {
      errors.value++;
    }

    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      playCurrentAudio();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    stopwatch.stop();
    timer?.cancel();
    isFinished.value = true;

    // Save results
    userController.saveScore(
      phonemeMatchingScore: score.value,
      phonemeMatchingScoreTime: elapsedTime.value.inSeconds.toDouble(),
      phonemeMatchingErrors: errors.value,
    );
  }

  void reset() {
    stopwatch.stop();
    timer?.cancel();
    started.value = false;
    score.value = 0;
    errors.value = 0;
    elapsedTime.value = Duration.zero;
    currentIndex.value = 0;
    isFinished.value = false;
  }

  @override
  void onClose() {
    timer?.cancel();
    stopwatch.stop();
    super.onClose();
  }
}
