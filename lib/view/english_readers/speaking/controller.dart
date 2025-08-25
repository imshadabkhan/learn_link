import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingController extends GetxController {

  var timeTaken = 0.obs;
  var wrongWords = <String>[].obs;
  var totalScore = 0.0.obs;

  RxDouble readingFluency = 0.0.obs;
  RxInt paragraphIndex = 0.obs;
  RxDouble progress = 0.0.obs;
  RxString recognizedText = ''.obs;
  RxDouble pronunciationScore = 0.0.obs;
  RxDouble readingSpeed = 0.0.obs;
  RxBool isListening = false.obs;
  RxBool isFinished = false.obs;
  RxDouble finalScore = 0.0.obs;
  RxInt totalErrors = 0.obs;
  RxList<String> highlightedWords = <String>[].obs;
  var hasSeenInstructions = false.obs;

  // TRACK SCORES FOR ALL PARAGRAPHS
  RxList<double> paragraphScores = <double>[].obs;
  RxList<int> paragraphErrors = <int>[].obs;
  RxList<double> paragraphPronunciation = <double>[].obs;
  RxList<double> paragraphReadingSpeed = <double>[].obs;
  RxList<double> paragraphFluency = <double>[].obs;
  RxList<int> paragraphTimeTaken = <int>[].obs;
  RxList<int> paragraphWrongWordsCount = <int>[].obs;

  RxList<String> myParagraphs = [
    "The dog is big. It runs fast. The dog likes to play.",
    "Sam has a toy. It is a red car. Sam plays with it every day",
    "The sun is shining in the sky. Birds are singing in the trees. The flowers are colorful and smell sweet.",
  ].obs;

  RxList<String> myParagraphImages = [
    "assets/images/paragraph_one_image.png",
    "assets/images/paragraph_two_image.jpg",
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
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          stopListening();
        }
      },
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

    // If last paragraph, calculate final metrics
    if (paragraphIndex.value >= myParagraphs.length - 1) {
      finalScore.value = getFinalSpeakingScore();
      isFinished.value = true;
      print("Final Speaking Score: $finalScore");
    }
  }

  void _analyzeSpeech() {
    final original = myParagraphs[paragraphIndex.value];
    final spoken = recognizedText.value;

    String clean(String text) => text.replaceAll(RegExp(r'[^\w\s]'), '');
    final originalWords = clean(original).split(RegExp(r'\s+'));
    final spokenWords = clean(spoken).split(RegExp(r'\s+'));

    Set<String> originalSet = originalWords.map((w) => w.toLowerCase()).toSet();
    Set<String> spokenSet = spokenWords.map((w) => w.toLowerCase()).toSet();

    int matches = spokenSet.intersection(originalSet).length;

    wrongWords.clear();
    highlightedWords.clear();
    int paragraphWrong = 0;

    for (String word in originalWords) {
      if (spokenSet.contains(word.toLowerCase())) {
        highlightedWords.add(word);
      } else {
        highlightedWords.add("*$word*");
        wrongWords.add(word);
        paragraphWrong++;
      }
    }

    totalErrors.value = paragraphWrong;
    pronunciationScore.value = (matches / originalWords.length) * 100;

    final duration = DateTime.now().difference(_startTime).inSeconds;
    timeTaken.value = duration == 0 ? 1 : duration;
    readingSpeed.value = (spokenWords.length / timeTaken.value) * 60;

    readingFluency.value = ((spokenWords.length / timeTaken.value) * 60 / 150) * 100;
    if (readingFluency.value > 100) readingFluency.value = 100;

    double score = (pronunciationScore.value * 0.5) + (readingFluency.value * 0.2);
    totalScore.value = score;

    // Save paragraph metrics
    paragraphScores.add(score);
    paragraphErrors.add(paragraphWrong);
    paragraphPronunciation.add(pronunciationScore.value);
    paragraphReadingSpeed.add(readingSpeed.value);
    paragraphFluency.add(readingFluency.value);
    paragraphTimeTaken.add(timeTaken.value);
    paragraphWrongWordsCount.add(paragraphWrong);
  }

  double getFinalSpeakingScore() {
    if (paragraphScores.isEmpty) return 0.0;
    double total = paragraphScores.fold(0.0, (sum, s) => sum + s);
    return total / paragraphScores.length;
  }

  Map<String, dynamic> getSpeakingResults() {
    return {
      "pronunciationAccuracy": paragraphPronunciation.isEmpty
          ? 0.0
          : paragraphPronunciation.fold(0.0, (a, b) => a + b) / paragraphPronunciation.length,
      "readingSpeedWpm": paragraphReadingSpeed.isEmpty
          ? 0.0
          : paragraphReadingSpeed.fold(0.0, (a, b) => a + b) / paragraphReadingSpeed.length,
      "timeTaken": paragraphTimeTaken.fold(0, (a, b) => a + b),
      "totalErrors": paragraphErrors.fold(0, (a, b) => a + b),
      "wrongWords": paragraphWrongWordsCount.fold(0, (a, b) => a + b),
      "totalScore": finalScore.value,
      "readingFluency": paragraphFluency.isEmpty
          ? 0.0
          : paragraphFluency.fold(0.0, (a, b) => a + b) / paragraphFluency.length,
    };
  }

  void updateIndex() {
    paragraphIndex.value++;
    progress.value = paragraphIndex.value / (myParagraphs.length - 1);
    resetFeedback();
  }

  void resetFeedback() {
    timeTaken.value = 0;
    recognizedText.value = '';
    pronunciationScore.value = 0.0;
    readingSpeed.value = 0.0;
    totalScore.value = 0.0;
    totalErrors.value = 0;
    wrongWords.clear();
    highlightedWords.clear();
  }
}
