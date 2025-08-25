import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:learn_link/view/english_readers/controller.dart';


class DyslexiaImageScanner extends StatefulWidget {
  @override
  _DyslexiaImageScannerState createState() => _DyslexiaImageScannerState();
}

class _DyslexiaImageScannerState extends State<DyslexiaImageScanner> {
  UserController userController=Get.put(UserController());
  EnglishReaderController englishReaderController=Get.put(EnglishReaderController());
  File? _image;
  String _extractedText = '';
  int _riskScore = 0;
  double _errorDensity = 0.0;
  bool _showText = false;
  final picker = ImagePicker();

  double _spellingAccuracy = 0.0;
  int _letterReversalCount = 0;
  List<String> _errorReport = [];

  Set<String> _dictionary = {};

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    final dictString = await rootBundle.loadString('assets/dictationary/my_dictionary.txt');
    final lines = dictString.split('\n');
    setState(() {
      _dictionary = lines
          .map((line) => line.trim().toLowerCase())
          .where((word) => word.isNotEmpty)
          .toSet();
    });
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<List<int>> v =
    List.generate(s.length + 1, (_) => List<int>.filled(t.length + 1, 0));

    for (var i = 0; i <= s.length; i++) v[i][0] = i;
    for (var j = 0; j <= t.length; j++) v[0][j] = j;

    for (var i = 1; i <= s.length; i++) {
      for (var j = 1; j <= t.length; j++) {
        int cost = s[i - 1] == t[j - 1] ? 0 : 1;
        v[i][j] = [
          v[i - 1][j] + 1,
          v[i][j - 1] + 1,
          v[i - 1][j - 1] + cost
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return v[s.length][t.length];
  }

  bool _isCorrectlySpelled(String word) {
    if (_dictionary.contains(word)) return true;
    for (var dictWord in _dictionary) {
      if (_levenshtein(word, dictWord) <= 1) return true;
    }
    return false;
  }

  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    int score = 0;
    double density = 0.0;

    final patterns = [
      RegExp(r'\b(?:[bpqd]){2,}\b', caseSensitive: false),
      RegExp(r'\b(\w+)\s+\1\b', caseSensitive: false),
      RegExp(r'\b[a-zA-Z]{12,}\b'),
      RegExp(r'\s{3,}'),
      RegExp(r'\b(?![aAiI])[a-zA-Z]{1}\b'),
      RegExp(r'\b[a-z]+[A-Z]+[a-z]*\b'),
      RegExp(r'([a-zA-Z])\1{2,}'),
      RegExp(r'\b\w*(?:-{2,}|\.\.+)\w*\b'),
      RegExp(r'[!?.]{3,}'),
      RegExp(r'\b[a-zA-Z]*\d+[a-zA-Z]*\b'),
    ];

    for (var pattern in patterns) {
      if (pattern.hasMatch(text)) {
        score++;
      }
    }
    Future<void> _getImage() async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.teal),
                  title: Text("Take a Photo"),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                        _extractedText = '';
                        _riskScore = 0;
                        _errorDensity = 0.0;
                        _spellingAccuracy = 0.0;
                        _letterReversalCount = 0;
                        _errorReport.clear();
                        _showText = false;
                      });
                      _recognizeText(File(pickedFile.path));
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.teal),
                  title: Text("Choose from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                        _extractedText = '';
                        _riskScore = 0;
                        _errorDensity = 0.0;
                        _spellingAccuracy = 0.0;
                        _letterReversalCount = 0;
                        _errorReport.clear();
                        _showText = false;
                      });
                      _recognizeText(File(pickedFile.path));
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
    int totalWords = text
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .length;

    density = totalWords > 0 ? score / totalWords : 0.0;

    List<String> words = text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.trim().isNotEmpty)
        .toList();

    int correctWords = words.where((word) => _isCorrectlySpelled(word)).length;
    _spellingAccuracy = words.isNotEmpty ? correctWords / words.length : 0.0;
    final reversalPattern = RegExp(r'[bpdqmwnu]', caseSensitive: false);

    _letterReversalCount = words.where((word) {
      // Check if word contains any reversal letters
      if (!reversalPattern.hasMatch(word)) return false;

      // Optionally, check if word contains pairs of confusing letters
      // For example, check if it contains at least one pair of reversed letters next to each other
      // like 'bd', 'pq', 'mn', etc.
      final pairs = ['bd', 'db', 'pq', 'qp', 'mn', 'nm', 'uw', 'wu', 'nu', 'un'];

      for (var pair in pairs) {
        if (word.toLowerCase().contains(pair)) return true;
      }

      // Or just count any word containing reversal letters
      return true;
    }).length;


    setState(() {
      _extractedText = text;
      _riskScore = score;
      _errorDensity = density;
    });
  }




  Future<void> _getImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.teal),
                title: Text("Take a Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                      _extractedText = '';
                      _riskScore = 0;
                      _errorDensity = 0.0;
                      _spellingAccuracy = 0.0;
                      _letterReversalCount = 0;
                      _errorReport.clear();
                      _showText = false;
                    });
                    _recognizeText(File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.teal),
                title: Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                      _extractedText = '';
                      _riskScore = 0;
                      _errorDensity = 0.0;
                      _spellingAccuracy = 0.0;
                      _letterReversalCount = 0;
                      _errorReport.clear();
                      _showText = false;
                    });
                    _recognizeText(File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDiagnosisDialog(BuildContext context) {
    final TextEditingController ageController = TextEditingController();
    final TextEditingController userAge = TextEditingController();
    final RxnBool diagnosedDyslexic = RxnBool(); // true, false or null
    final RxnBool parentHistoryOfDyslexic = RxnBool();
    Get.bottomSheet(
      GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Diagnosis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),

                const SizedBox(height: 16),

                // Age Started Reading
                TextField(

                  controller: ageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(           // <-- this changes user input color
                    color: Colors.black,             // pick any color
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration:  InputDecoration(

                    labelText: "Age Started Reading",
                    border: OutlineInputBorder(),
                  ),
                ),

                Widgets.heightSpaceH2,

                TextField(

                  controller: userAge,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(           // <-- this changes user input color
                    color: Colors.black,             // pick any color
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration:  InputDecoration(

                    labelText: "User Age",
                    border: OutlineInputBorder(),
                  ),
                ),


                const SizedBox(height: 20),


                userController.role=="guardian"?Column(children: [
                  const Text("Is the student dyslexic?",
                      style: TextStyle(fontSize: 16,color: Colors.black),textAlign: TextAlign.start,),


                  Obx(() => Column(

                    children: [
                      RadioListTile<bool?>(
                        title: const Text("Dyslexic"),
                        value: true,
                        groupValue: diagnosedDyslexic.value,
                        onChanged: (val) => diagnosedDyslexic.value = val,
                      ),
                      RadioListTile<bool?>(
                        title: const Text("Not Dyslexic"),
                        value: false,
                        groupValue: diagnosedDyslexic.value,
                        onChanged: (val) => diagnosedDyslexic.value = val,
                      ),
                      RadioListTile<bool?>(
                        title: const Text("Don't know"),
                        value: null,
                        groupValue: diagnosedDyslexic.value,
                        onChanged: (val) => diagnosedDyslexic.value = val,
                      ),
                    ],
                  )),
                ],):Column(children: [
                  const Text("Parents History Of Dyslexia",
                    style: TextStyle(fontSize: 16,color: Colors.black),textAlign: TextAlign.start,),


                  Obx(() => Column(

                    children: [
                      RadioListTile<bool?>(
                        title: const Text("YES"),
                        value: true,
                        groupValue: parentHistoryOfDyslexic.value,
                        onChanged: (val) => parentHistoryOfDyslexic.value = val,
                      ),
                      RadioListTile<bool?>(
                        title: const Text("No"),
                        value: false,
                        groupValue: parentHistoryOfDyslexic.value,
                        onChanged: (val) => parentHistoryOfDyslexic.value = val,
                      ),

                    ],
                  )),
                ],),





                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // ✅ teal button
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("Start Diagnosis"),
                    onPressed: () {
                      // Trim and check if text field is empty
                      if (ageController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Validation Error",
                          "Age Started Reading cannot be empty",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return; // Stop execution
                      }

                      int age = int.tryParse(ageController.text.trim()) ?? 0;

                      print("📌 Age Started Reading: $age");
                      print("📌 Diagnosed Dyslexic: ${diagnosedDyslexic.value}");
                      print("📌 parent History Dyslexic: ${parentHistoryOfDyslexic.value}");
                      englishReaderController.SubmitReport(
                        context: context,
                        diagnosedDyslexic: diagnosedDyslexic.value,
                        ageStartedReading: age,
                        familyHistoryOfDyslexia: parentHistoryOfDyslexic.value
                      );

                      Get.back(); // close sheet
                    },
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('📷 Dyslexia Detector'),
        backgroundColor: Colors.teal,
        leading: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.navBar);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 4,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _getImage,
            label: const Text("Scan Text"),
            icon: const Icon(Icons.document_scanner),
            backgroundColor: Colors.teal,
          ),
          const SizedBox(width: 12),
          if (_extractedText.isNotEmpty) // ✅ Show Diagnose only after text is scanned
            FloatingActionButton.extended(
              onPressed: () {
                _showDiagnosisDialog(context);
                Get.snackbar("Diagnosis", "Analyzing scanned text...");
              },
              label: const Text("Diagnose"),
              icon: const Icon(Icons.medical_services),
              backgroundColor: Colors.redAccent,
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                )
              else
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      "Upload or capture an image to scan for patterns 📄",
                      style: TextStyle(
                          color: Colors.teal[800],
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (_extractedText.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showText = !_showText;
                    });
                  },
                  child: Card(
                    elevation: 4,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      height: _showText ? 300 : 60,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Texts.textBold("📝 Extracted Text", size: 14),
                            Widgets.heightSpaceH1,
                            Text(
                              _extractedText,
                              style: const TextStyle(color: Colors.black),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (_extractedText.isNotEmpty)
                Card(
                  elevation: 4,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [


                        Text(
                          "Error Density: ${_errorDensity.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Spelling Accuracy: ${(_spellingAccuracy * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Letter Reversals Detected: $_letterReversalCount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                        ),
                        const SizedBox(height: 12),


                      ],
                    ),
                  ),
                ),
              Widgets.heightSpaceH5,
              Widgets.heightSpaceH5,
              Widgets.heightSpaceH5,
              Widgets.heightSpaceH5,

            ],
          ),
        ),
      ),
    );
  }
}

