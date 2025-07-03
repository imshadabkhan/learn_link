import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingController extends GetxController {
  RxInt paragraphIndex = 0.obs;
  RxDouble progress = 0.0.obs;
  RxString recognizedText = ''.obs;
  RxDouble pronunciationScore = 0.0.obs;
  RxDouble readingSpeed = 0.0.obs;
  RxBool isListening = false.obs;

  RxInt totalErrors = 0.obs;
  RxList<String> wrongWords = <String>[].obs;
  RxDouble totalScore = 0.0.obs;
  RxInt timeTaken = 0.obs;
  RxList<String> highlightedWords = <String>[].obs;

  RxList<String> myParagraphs = [
    "The dog is big. It runs fast. The dog likes to play.",
    "Sam has a toy. It is a red car. Sam plays with it every day. He loves his toy.",
    "Lily has a pet cat. The cat is small and soft. It likes to sleep in the sun. The cat purrs when Lily pets it.",
    "Ben and Mia go to the park. They run and jump on the swings. Ben likes to climb the big slide. Mia laughs when she slides down fast.",
    "The sun is shining in the sky. Birds are singing in the trees. The flowers are colorful and smell sweet. It is a beautiful day, and the children are happy playing outside.",
  ].obs;

  RxList<String> myParagraphImages = [
    "assets/images/paragraph_one_image.png",
    "assets/images/paragraph_two_image.jpg",
    "assets/images/paragraph_three_image.jpg",
    "assets/images/paragraph_four_image.jpg",
    "assets/images/paragraph_five_image.jpg"
  ].obs;

  late stt.SpeechToText _speech;
  late DateTime _startTime;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {},
      onError: (error) {
        print("Speech recognition error: $error");
      },
    );
    if (available) {
      isListening.value = true;
      recognizedText.value = '';
      highlightedWords.clear();
      _startTime = DateTime.now();
      _speech.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        onResult: (val) {
          recognizedText.value = val.recognizedWords;
        },
      );
    }
  }

  void stopListening() async {
    await _speech.stop();
    isListening.value = false;
    _analyzeSpeech();
  }

  void _analyzeSpeech() {
    final original = myParagraphs[paragraphIndex.value];
    final spoken = recognizedText.value;

    final originalWords = original.split(RegExp(r'\s+'));
    final spokenWords = spoken.split(RegExp(r'\s+'));

    int matches = 0;
    wrongWords.clear();
    highlightedWords.clear();

    for (int i = 0; i < originalWords.length; i++) {
      if (i < spokenWords.length && originalWords[i].toLowerCase() == spokenWords[i].toLowerCase()) {
        highlightedWords.add(originalWords[i]);
        matches++;
      } else {
        highlightedWords.add("*${originalWords[i]}*"); // marked for red highlight
        wrongWords.add(i < spokenWords.length ? spokenWords[i] : "(missed)");
      }
    }

    totalErrors.value = wrongWords.length;
    pronunciationScore.value = (matches / originalWords.length) * 100;

    final duration = DateTime.now().difference(_startTime).inSeconds;
    timeTaken.value = duration == 0 ? 1 : duration;
    readingSpeed.value = (spokenWords.length / timeTaken.value) * 60;

    totalScore.value = (pronunciationScore.value * 0.7) +
        ((readingSpeed.value > 120 ? 120 : readingSpeed.value) / 120 * 30);
  }

  void updateIndex() {
    if (paragraphIndex.value == myParagraphs.length -1) {
        Get.toNamed(AppRoutes.attentionModule);
        return ;
    }
    paragraphIndex.value++;
    progress.value = paragraphIndex.value / (myParagraphs.length - 1);
    resetFeedback();
  }

  void resetFeedback() {
    timeTaken.value=0;
    recognizedText.value = '';
    pronunciationScore.value = 0.0;
    readingSpeed.value = 0.0;
    totalScore.value = 0.0;
    totalErrors.value = 0;
    wrongWords.clear();
    highlightedWords.clear();
  }
}
