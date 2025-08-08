import 'package:get/get.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingController extends GetxController {


  var timeTaken = 0.obs;
  var wrongWords = <String>[].obs;
  var totalScore = 0.0.obs;

  var pronunciationScores = <double>[];
  var readingSpeeds = <double>[];
  var totalErrorsList = <int>[];
  var wrongWordsList = <List<String>>[];
  var totalScores = <double>[];


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

  // NEW LISTS TO TRACK SCORES FOR ALL PARAGRAPHS
  RxList<double> paragraphScores = <double>[].obs;
  RxList<int> errorCounts = <int>[].obs;

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
        print("Speech status: $status");
        if (status == 'done' || status == 'notListening') {
          stopListening(); // auto stop
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
    if (paragraphIndex.value == myParagraphs.length - 1) {
      await _speech.stop();
      isListening.value = false;
      _analyzeSpeech();
      // Calculate final score
      finalScore.value =
          paragraphScores.fold(0.0, (sum, s) => sum + s) / paragraphScores.length;
      print("Final Speaking Score: $finalScore");
      isFinished.value = true;

      // You can also pass it to next screen or save it in SharedPreferences if needed
      // Get.toNamed(AppRoutes.attentionModule);
      return;
    }
    await _speech.stop();
    isListening.value = false;
    _analyzeSpeech();

    // if (paragraphIndex.value == myParagraphs.length - 1) {
    //   isFinished.value = true;
    // }
  }

  void _analyzeSpeech() {
    final original = myParagraphs[paragraphIndex.value];
    final spoken = recognizedText.value;

    // Clean punctuation
    String clean(String text) => text.replaceAll(RegExp(r'[^\w\s]'), '');
    final originalWords = clean(original).split(RegExp(r'\s+'));
    final spokenWords = clean(spoken).split(RegExp(r'\s+'));

    Set<String> originalSet = originalWords.map((w) => w.toLowerCase()).toSet();
    Set<String> spokenSet = spokenWords.map((w) => w.toLowerCase()).toSet();

    int matches = spokenSet.intersection(originalSet).length;

    wrongWords.clear();
    highlightedWords.clear();

    for (String word in originalWords) {
      if (spokenSet.contains(word.toLowerCase())) {
        highlightedWords.add(word); // correct
      } else {
        highlightedWords.add("*$word*"); // wrong
        wrongWords.add(word);
      }
    }

    totalErrors.value = wrongWords.length;
    pronunciationScore.value = (matches / originalWords.length) * 100;

    final duration = DateTime.now().difference(_startTime).inSeconds;
    timeTaken.value = duration == 0 ? 1 : duration;
    readingSpeed.value = (spokenWords.length / timeTaken.value) * 60;

    double score = (pronunciationScore.value * 0.7) +
        ((readingSpeed.value > 120 ? 120 : readingSpeed.value) / 120 * 30);

    totalScore.value = score;
    paragraphScores.add(score);
    pronunciationScores.add(pronunciationScore.value);
    readingSpeeds.add(readingSpeed.value);
    errorCounts.add(totalErrors.value);
  }


  void updateIndex() {
    // if (paragraphIndex.value == myParagraphs.length - 1) {
    //   // Calculate final score
    //   finalScore.value =
    //       paragraphScores.fold(0.0, (sum, s) => sum + s) / paragraphScores.length;
    //   print("Final Speaking Score: $finalScore");
    //   isFinished.value = true;
    //
    //   // You can also pass it to next screen or save it in SharedPreferences if needed
    //   // Get.toNamed(AppRoutes.attentionModule);
    //   return;
    // }

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
