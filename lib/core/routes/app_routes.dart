import 'package:get/get.dart';
import 'package:learn_link/view/attention/attention_screen.dart';
import 'package:learn_link/view/letter_reversal/view/letter_reversal.dart';
import 'package:learn_link/view/speaking/speaking_screen.dart';

class AppRoutes {
  static const  String writingModule="";
  static const String letterReversal="/LetterQuizScreen";
  static const  String speakingModule="/SpeakingScreen";
  static const  String attentionModule="/AttentionModule";
static final routes = [
  GetPage(name: letterReversal, page:()=>LetterQuizScreen()),
  GetPage(name: speakingModule, page:()=>SpeakingScreen()),
  GetPage(name: attentionModule, page:()=>AttentionModule()),
];

}