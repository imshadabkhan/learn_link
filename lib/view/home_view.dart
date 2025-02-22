import 'package:flutter/material.dart';
import 'package:learn_link/core/constants/asset_constant.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, List<String>> _gridImages = {
    ImageConstants.main_MathematicImage.toString(): [
      ImageConstants.main_MathematicImage,
      ImageConstants.sub_MathematicImage1,
      ImageConstants.sub_MathematicImage2,
      ImageConstants.sub_MathematicImage3,
    ],
  };

  // List of images for the grid.

  // Controls the opacity of the overlay image.
  double _opacity = 1.0;


  int totalMarks = 0;
  String? selectedImage = '';
  void marksCounter(String correctImage) {
    if (selectedImage == correctImage) {
      totalMarks++;
      debugPrint("You Answer is right");
      debugPrint("SelectedImage $selectedImage");
      debugPrint("correctImage $correctImage");
    } else {
      debugPrint("Wrong Answer");
      debugPrint("SelectedImage $selectedImage");
      debugPrint("correctImage $correctImage");
    }
  }

  @override
  void initState() {
    super.initState();
    // Trigger the fade-out animation after a 5-second delay.
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _opacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String overlayImage = _gridImages.keys.first;
    final List<String> gridImage = _gridImages.values.first;
    String correctImage = overlayImage;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          marksCounter(
            correctImage,
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
      // Stack to overlay the fading image on top of the centered grid.
      body: Stack(
        children: [
          // Centering the grid on the screen.
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                // Ensures the grid takes only the space it needs.
                shrinkWrap: true,
                // Disable grid scrolling as it is centered and small.
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid.
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {


                      setState(() {
                        selectedImage = gridImage[index];
                        debugPrint(selectedImage);
                      });
                    },
                    child: Image.asset(
                      gridImage[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          // Fading overlay image that covers the entire screen.
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 5),
              child: Image.asset(
                overlayImage,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
