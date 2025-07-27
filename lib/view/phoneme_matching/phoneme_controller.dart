import 'package:get/get.dart';
import 'package:learn_link/view/phoneme_matching/model.dart';


class PhonemeMatchingController extends GetxController {
  RxInt currentQuestionIndex = 0.obs;
  RxInt score = 0.obs;
  RxInt errors = 0.obs;
  RxInt timeTaken = 0.obs; // in seconds
  RxBool isFinished = false.obs;

  final List<PhonemeQuestion> questions = [
    PhonemeQuestion(
      soundAsset: 'assets/sounds/b.mp3',
      options: ['b', 'd', 'p'],
      correctAnswer: 'b',
    ),
    PhonemeQuestion(
      soundAsset: 'assets/sounds/k.mp3',
      options: ['g', 't', 'k'],
      correctAnswer: 'k',
    ),
    // Add more...
  ];

  void checkAnswer(String selected) {
    if (isFinished.value) return;

    final correct = questions[currentQuestionIndex.value].correctAnswer;
    if (selected == correct) {
      score.value += 1;
    } else {
      errors.value += 1;
    }

    nextQuestion();
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex++;
    } else {
      isFinished.value = true;
    }
  }

  void restart() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    errors.value = 0;
    timeTaken.value = 0;
    isFinished.value = false;
  }

  void incrementTime() {
    if (!isFinished.value) timeTaken++;
  }
}
