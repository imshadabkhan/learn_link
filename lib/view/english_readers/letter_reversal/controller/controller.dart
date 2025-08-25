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
  final RxBool showInstructions = true.obs;
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
  final RxInt finalResult = 0.obs;
  final currentIndex = 0.obs;
  final selectedAnswer = ''.obs;
  final isCorrect = RxnBool();
  final isOptionDisabled = false.obs;

  final RxInt totalErrors = 0.obs; // Track wrong answers
  final RxInt totalTimeTaken = 0.obs; // Track total time
  late Stopwatch _stopwatch;

  final player = AudioPlayer();

  QuizItem get currentItem => quizItems[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    userController.fetchUser();
    _stopwatch = Stopwatch()..start();
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
      if (totalScore.value > 100.0) totalScore.value = 100.0;
    } else {
      totalErrors.value++; // Increment errors
    }
  }

  void nextQuestion() {
    if (!isOptionDisabled.value) {
      Get.snackbar('No Value Selected!', 'Select the value!');
      return;
    }

    if (currentIndex.value < quizItems.length - 1) {
      // Move to next question
      currentIndex.value++;
      selectedAnswer.value = '';
      isCorrect.value = null;
      isOptionDisabled.value = false;
      playCurrentSound();
    } else {
      // Quiz Completed
      _stopwatch.stop();
      totalTimeTaken.value = _stopwatch.elapsed.inSeconds;

      quizCompleted.value = true;
      finalResult.value = totalScore.value.round();

      // Save the Letter Quiz results in UserController
      userController.saveScore(
        letterReversalScore: finalResult.value,
        letterReversalTime: totalTimeTaken.value,
        letterReversalErrorCount: totalErrors.value,
      );

      print('Letter Quiz Completed:');
      print('Score: ${finalResult.value}');
      print('Time Taken: ${totalTimeTaken.value} sec');
      print('Total Errors: ${totalErrors.value}');

      Get.snackbar(
        'Quiz Completed',
        'Score: ${finalResult.value} / 100\nTime: ${totalTimeTaken.value}s\nErrors: ${totalErrors.value}',
      );
    }
  }
}
