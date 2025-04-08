import 'package:get/get.dart';

class SpeakingController extends GetxController {
  RxInt paragraphIndex = 0.obs;
  RxDouble progress = 0.0.obs;
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

  updateIndex(){
    if(paragraphIndex.value <4){ paragraphIndex.value = paragraphIndex.value + 1;}
    progress.value=paragraphIndex.value/4;

    print("text updated ${paragraphIndex.value}");
  }
}
