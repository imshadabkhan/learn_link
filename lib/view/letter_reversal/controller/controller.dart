import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizItem {
  final String correctAnswer;
  final List<String> options;
  final String soundPath;

  QuizItem({
    required this.correctAnswer,
    required this.options,
    required this.soundPath,
  });
}

class LetterController extends GetxController {
  final UserController userController = Get.find<UserController>();

  final List<QuizItem> quizItems = [
    QuizItem(correctAnswer: 'b', options: ['q', 'd', 'p', 'b'], soundPath: 'sounds/letter_b.mp3'),
    QuizItem(correctAnswer: 'd', options: ['b', 'p', 'd', 'q'], soundPath: 'sounds/letter_d.mp3'),
    QuizItem(correctAnswer: 'p', options: ['b', 'd', 'q', 'p'], soundPath: 'sounds/letter_p.mp3'),
    QuizItem(correctAnswer: 'q', options: ['b', 'd', 'p', 'q'], soundPath: 'sounds/letter_q.mp3'),
    QuizItem(correctAnswer: '14', options: ['4', '41', '14', '44'], soundPath: 'sounds/digit_14.mp3'),
    QuizItem(correctAnswer: '41', options: ['14', '44', '11', '41'], soundPath: 'sounds/digit_41.mp3'),
  ];

  final RxBool quizCompleted = false.obs;
  final RxDouble totalScore = 0.0.obs;
  final RxInt finalResult = 0.obs; // ✅ Final rounded score for use/display
  final currentIndex = 0.obs;
  final selectedAnswer = ''.obs;
  final isCorrect = RxnBool();
  final isOptionDisabled = false.obs;

  final player = AudioPlayer();

  QuizItem get currentItem => quizItems[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    userController.fetchUser();
    playCurrentSound();
  }

  void playCurrentSound() async {
    await player.stop();
    await player.play(AssetSource(currentItem.soundPath));
  }

  void selectAnswer(String answer) {
    if (isOptionDisabled.value) return;

    selectedAnswer.value = answer;
    isCorrect.value = (answer == currentItem.correctAnswer);
    isOptionDisabled.value = true;

    if (isCorrect.value == true) {
      totalScore.value += 16.66;
      totalScore.value = double.parse(totalScore.value.toStringAsFixed(2));

      if (totalScore.value > 100.0) {
        totalScore.value = 100.0;
      }
    }
  }

  void nextQuestion() {
    if (currentIndex.value < quizItems.length - 1) {
      if (isOptionDisabled.value == true) {
        currentIndex.value++;
        playCurrentSound();

        selectedAnswer.value = '';
        isCorrect.value = null;
        isOptionDisabled.value = false;
      } else {
        Get.snackbar('No Value Selected!', 'Select the value!');
      }
    } else {
      if (isOptionDisabled.value == true) {
        quizCompleted.value = true;

        // ✅ Final Score rounded to int
        finalResult.value = totalScore.value.round(); // Converts 99.96 to 100

        print('Final Score: ${finalResult.value}');

        Get.snackbar('Quiz Completed', 'Your score is ${finalResult.value} / 100');
      } else {
        Get.snackbar('No Value Selected!', 'Select the value!');
      }
    }
  }
}
