import 'package:get/get.dart';
import 'package:learn_link/view/attention/attention_screen.dart';
import 'package:learn_link/view/guardian/guardian_view.dart';
import 'package:learn_link/view/letter_reversal/view/letter_reversal.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_ui.dart';
import 'package:learn_link/view/small_kids/number_sequence/number_sequence_game.dart';
import 'package:learn_link/view/small_kids/phoneme_matching/audio_quiz.dart';
import 'package:learn_link/view/speaking/speaking_screen.dart';

class AppRoutes {
  static const  String writingModule="//writingModule";
  static const String letterReversal="/LetterQuizScreen";
  static const  String speakingModule="/SpeakingScreen";
  static const  String attentionModule="/AttentionModule";
  static const  String guardianDashboard="/guardianModule";
  static const  String memoryPattern="/memoryPatternView";
  static const  String numberSequence="/numberSequenceView";
  static const  String phonemeMatching="/phonemeMatchingView";
static final routes = [
  GetPage(name: letterReversal, page:()=>LetterQuizScreen()),
  GetPage(name: speakingModule, page:()=>SpeakingScreen()),
  GetPage(name: attentionModule, page:()=>AttentionModule()),
  GetPage(name: guardianDashboard, page:()=>GuardianDashboard()),
  //kids
  GetPage(name: memoryPattern, page:()=>PatternMemoryScreen()),
  GetPage(name: numberSequence, page:()=>NumberSequenceGame()),

];

}