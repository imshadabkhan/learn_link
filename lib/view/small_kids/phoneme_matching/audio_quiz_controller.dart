import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioQuizController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final RxInt currentIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxBool isFinished = false.obs;
  var started = false.obs;
  var isStarted = false.obs;

  final questions = [
    {
      "audio": "pronunciation_en_bat.mp3",
      "options": ["pat", "bat"],
      "answer": "bat",
    },
    {
      "audio": "pronunciation_en_dog.mp3",
      "options": ["dock", "dog"],
      "answer": "dog",
    },
    {
      "audio": "pronunciation_en_sip.mp3",
      "options": ["sip", "zip"],
      "answer": "sip",
    },
    {
      "audio": "pronunciation_en_van.mp3",
      "options": ["van", "fan"],
      "answer": "van",
    },
    {
      "audio": "pronunciation_en_thin.mp3",
      "options": ["fin", "thin"],
      "answer": "thin",
    },
  ];

  void playCurrentAudio() async {
    await player.stop();
    await player.play(AssetSource('sounds/${questions[currentIndex.value]["audio"]}'));
  }

  void selectAnswer(String selected) {
    if (selected == questions[currentIndex.value]["answer"]) {
      score.value++;
    }

    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      playCurrentAudio();
    } else {
      isFinished.value = true;
    }
  }

  void reset() {
    score.value = 0;
    currentIndex.value = 0;
    isFinished.value = false;
    isStarted.value = false;
  }


  @override
  void onInit() {
    super.onInit();
    playCurrentAudio();
  }
}
