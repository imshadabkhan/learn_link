import 'package:get/get.dart';
import 'package:learn_link/view/bottom_bar/bottomnavbar.dart';
import 'package:learn_link/view/english_readers/attention/attention_screen.dart';
import 'package:learn_link/view/english_readers/letter_reversal/view/letter_reversal.dart';
import 'package:learn_link/view/english_readers/speaking/speaking_screen.dart';
import 'package:learn_link/view/guardian/guardian_view.dart';
import 'package:learn_link/view/small_kids/letter_recognition/letter_recognition_view.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_ui.dart';
import 'package:learn_link/view/small_kids/number_sequence/number_sequence_game.dart';

import '../../view/english_readers/writing.dart';

class AppRoutes {

  static const String letterReversal="/LetterQuizScreen";
  static const  String speakingModule="/SpeakingScreen";
  static const  String attentionModule="/AttentionModule";
  static const  String guardianDashboard="/guardianModule";
  static const  String memoryPattern="/memoryPatternView";
  static const  String numberSequence="/numberSequenceView";
  static const  String phonemeMatching="/phonemeMatchingView";
  static const  String writingScanner="/writingScanner";
  static const  String letterRecognitionView="/letterRecognitionView";
  static const  String navBar="/navBar";
static final routes = [
  GetPage(name: letterReversal, page:()=>LetterQuizScreen()),
  GetPage(name: speakingModule, page:()=>SpeakingScreen()),
  GetPage(name: attentionModule, page:()=>AttentionModule()),
  GetPage(name: guardianDashboard, page:()=>GuardianDashboard()),
  GetPage(name: writingScanner, page:()=>DyslexiaImageScanner()),
  //kids
  GetPage(name: memoryPattern, page:()=>PatternMemoryScreen()),
  GetPage(name: numberSequence, page:()=>NumberSequenceGame()),
  GetPage(name: navBar, page:()=>GuardianNavBar()),
  GetPage(name: letterRecognitionView, page:()=>LetterRecognitionPage()),

];

}