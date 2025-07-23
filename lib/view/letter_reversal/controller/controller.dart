import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:learn_link/controller/usercontroller.dart';

class QuizItem {
  final String correctAnswer;
  final List<String> options;
  final String soundPath;


  QuizItem({required this.correctAnswer, required this.options, required this.soundPath});
}

class LetterController extends GetxController {
  final UserController userController=Get.find<UserController>();
  final List<QuizItem> quizItems = [
    QuizItem(correctAnswer: 'b', options: ['q', 'd', 'p', 'b'], soundPath: 'sounds/letter_b.mp3'),
    QuizItem(correctAnswer: 'd', options: ['b', 'p', 'd', 'q'], soundPath: 'sounds/letter_d.mp3'),
    QuizItem(correctAnswer: 'p', options: ['b', 'd', 'q', 'p'], soundPath: 'sounds/letter_p.mp3'),
    QuizItem(correctAnswer: 'q', options: ['b', 'd', 'p', 'q'], soundPath: 'sounds/letter_q.mp3'),
    QuizItem(correctAnswer: '14', options: ['4', '41', '14', '44'], soundPath: 'sounds/digit_14.mp3'),
    QuizItem(correctAnswer: '41', options: ['14', '44', '11', '41'], soundPath: 'sounds/digit_41.mp3'),
  ];
  RxBool quizCompleted=false.obs;
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
    if (isOptionDisabled.value) return; // prevent reselecting
    selectedAnswer.value = answer;
    isCorrect.value = (answer == currentItem.correctAnswer);
    isOptionDisabled.value = true;
  }

  void nextQuestion() {
    if (currentIndex.value < quizItems.length - 1 ) {
      if(isOptionDisabled.value==true){
        currentIndex.value++;
        playCurrentSound();
      }else{
        Get.snackbar('No Value Selected!', 'Select the value!');

      }

      selectedAnswer.value = '';
      isCorrect.value = null;
      isOptionDisabled.value = false;

    } else {
      Get.snackbar('Done', 'You have completed the quiz!');
      quizCompleted.value=true;
    }
  }
}
