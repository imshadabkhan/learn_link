import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';

//
// class DyslexiaImageScanner extends StatefulWidget {
//   @override
//   _DyslexiaImageScannerState createState() => _DyslexiaImageScannerState();
// }
//
// class _DyslexiaImageScannerState extends State<DyslexiaImageScanner> {
//   File? _image;
//   String _extractedText = '';
//   int _riskScore = 0;
//   double _errorDensity = 0.0;
//   bool _showText = false;
//   final picker = ImagePicker();
//
//   // New metrics
//   double _spellingAccuracy = 0.0;
//   int _letterReversalCount = 0;
//
//   // Error breakdown
//   List<String> _errorReport = [];
//
//   // Example dictionary (expand later)
//   final Set<String> _dictionary = {
//     "the", "and", "is", "in", "it", "of", "to", "a",
//     "cat", "dog", "school", "ball", "sun", "moon",
//     "apple", "book", "tree", "car", "house"
//   };
//
//   Future<void> _getImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt, color: Colors.teal),
//                 title: Text("Take a Photo"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final pickedFile =
//                   await picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _image = File(pickedFile.path);
//                       _extractedText = '';
//                       _riskScore = 0;
//                       _errorDensity = 0.0;
//                       _spellingAccuracy = 0.0;
//                       _letterReversalCount = 0;
//                       _errorReport.clear();
//                       _showText = false;
//                     });
//                     _recognizeText(File(pickedFile.path));
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library, color: Colors.teal),
//                 title: Text("Choose from Gallery"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final pickedFile =
//                   await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _image = File(pickedFile.path);
//                       _extractedText = '';
//                       _riskScore = 0;
//                       _errorDensity = 0.0;
//                       _spellingAccuracy = 0.0;
//                       _letterReversalCount = 0;
//                       _errorReport.clear();
//                       _showText = false;
//                     });
//                     _recognizeText(File(pickedFile.path));
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Levenshtein Distance function for smart spell-check
//   int _levenshtein(String s, String t) {
//     if (s == t) return 0;
//     if (s.isEmpty) return t.length;
//     if (t.isEmpty) return s.length;
//
//     List<List<int>> v =
//     List.generate(s.length + 1, (_) => List<int>.filled(t.length + 1, 0));
//
//     for (var i = 0; i <= s.length; i++) v[i][0] = i;
//     for (var j = 0; j <= t.length; j++) v[0][j] = j;
//
//     for (var i = 1; i <= s.length; i++) {
//       for (var j = 1; j <= t.length; j++) {
//         int cost = s[i - 1] == t[j - 1] ? 0 : 1;
//         v[i][j] = [
//           v[i - 1][j] + 1,
//           v[i][j - 1] + 1,
//           v[i - 1][j - 1] + cost
//         ].reduce((a, b) => a < b ? a : b);
//       }
//     }
//     return v[s.length][t.length];
//   }
//
//   bool _isCorrectlySpelled(String word) {
//     if (_dictionary.contains(word)) return true;
//     for (var dictWord in _dictionary) {
//       if (_levenshtein(word, dictWord) <= 1) return true; // 1-char tolerance
//     }
//     return false;
//   }
//
//   Future<void> _recognizeText(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//     await textRecognizer.processImage(inputImage);
//
//     String text = recognizedText.text;
//     int score = 0;
//     double density = 0.0;
//
//     // Existing patterns
//     final patterns = [
//       RegExp(r'\b(?:[bpqd]){2,}\b', caseSensitive: false),
//       RegExp(r'\b(\w+)\s+\1\b', caseSensitive: false),
//       RegExp(r'\b[a-zA-Z]{12,}\b'),
//       RegExp(r'\s{3,}'),
//       RegExp(r'\b(?![aAiI])[a-zA-Z]{1}\b'),
//       RegExp(r'\b[a-z]+[A-Z]+[a-z]*\b'),
//       RegExp(r'([a-zA-Z])\1{2,}'),
//       RegExp(r'\b\w*(?:-{2,}|\.\.+)\w*\b'),
//       RegExp(r'[!?.]{3,}'),
//       RegExp(r'\b[a-zA-Z]*\d+[a-zA-Z]*\b'),
//     ];
//
//     for (var pattern in patterns) {
//       if (pattern.hasMatch(text)) {
//         score++;
//       }
//     }
//
//     int totalWords = text
//         .split(RegExp(r'\s+'))
//         .where((word) => word.trim().isNotEmpty)
//         .length;
//
//     density = totalWords > 0 ? score / totalWords : 0.0;
//
//     // --- New: Spelling Accuracy ---
//     List<String> words = text
//         .toLowerCase()
//         .split(RegExp(r'\s+'))
//         .where((w) => w.trim().isNotEmpty)
//         .toList();
//
//     int correctWords = words.where((word) => _isCorrectlySpelled(word)).length;
//     _spellingAccuracy =
//     words.isNotEmpty ? correctWords / words.length : 0.0;
//
//     // --- New: Letter Reversal Detection ---
//     final reversalPattern =
//     RegExp(r'\b(?:[bp]|[dq]|[mw]|[nu])+\b', caseSensitive: false);
//     _letterReversalCount =
//         words.where((word) => reversalPattern.hasMatch(word)).length;
//
//     setState(() {
//       _extractedText = text;
//       _riskScore = score;
//       _errorDensity = density;
//     });
//   }
//
//   Color _riskColor() {
//     if (_riskScore >= 5 || _errorDensity > 0.15) {
//       return Colors.red;
//     } else if (_riskScore >= 3) {
//       return Colors.orange;
//     } else {
//       return Colors.green;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.teal[50],
//       appBar: AppBar(
//         title: const Text('📷 Dyslexia Detector'),
//         backgroundColor: Colors.teal,
//         leading: GestureDetector(
//             onTap: () {
//               Get.toNamed(AppRoutes.navBar);
//             },
//             child: Icon(Icons.arrow_back)),
//         elevation: 4,
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _getImage,
//         label: const Text("Scan Text"),
//         icon: const Icon(Icons.document_scanner),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               if (_image != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(_image!, height: 200, fit: BoxFit.cover),
//                 )
//               else
//                 SizedBox(
//                   height: 200,
//                   child: Center(
//                     child: Text(
//                       "Upload or capture an image to scan for patterns 📄",
//                       style: TextStyle(
//                           color: Colors.teal[800],
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               if (_extractedText.isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showText = !_showText;
//                     });
//                   },
//                   child: Card(
//                     elevation: 4,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       padding: const EdgeInsets.all(12),
//                       height: _showText ? 300 : 60,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Texts.textBold("📝 Extracted Text", size: 14),
//                             Widgets.heightSpaceH1,
//                             Text(
//                               _extractedText,
//                               style: const TextStyle(color: Colors.black),
//                               textDirection: TextDirection.ltr,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 10),
//               if (_extractedText.isNotEmpty)
//                 Card(
//                   elevation: 4,
//                   color: _riskColor().withOpacity(0.1),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text("📊 Risk Score: $_riskScore",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: _riskColor())),
//                         const SizedBox(height: 4),
//                         Text(
//                           "🧠 Error Density: ${_errorDensity.toStringAsFixed(2)}",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "📏 Spelling Accuracy: ${(_spellingAccuracy * 100).toStringAsFixed(1)}%",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "🔄 Letter Reversals Detected: $_letterReversalCount",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 12),
//                         if (_errorReport.isNotEmpty) ...[
//                           const Text(
//                             "🔍 Error Breakdown:",
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 4),
//                           ..._errorReport
//                               .map((e) => Text("• $e",
//                               style: const TextStyle(fontSize: 14)))
//                               .toList(),
//                           const SizedBox(height: 12),
//                         ],
//                         Text(
//                           _riskScore >= 5 || _errorDensity > 0.15
//                               ? "⚠️ Kuch patterns dyslexia/dysgraphia ki taraf ishara karte hain. Specialist se zarur mashwara karein."
//                               : "✅ Filhal risk low hai, lekin agar shak ho to observation zaruri hai.",
//                           style: const TextStyle(fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           "🔍 Note: Ye sirf ek screening tool hai. Diagnosis ke liye certified specialist se check-up zarur karayein.",
//                           style: TextStyle(
//                               fontSize: 14, fontStyle: FontStyle.italic),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';

class DyslexiaImageScanner extends StatefulWidget {
  @override
  _DyslexiaImageScannerState createState() => _DyslexiaImageScannerState();
}

class _DyslexiaImageScannerState extends State<DyslexiaImageScanner> {
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

  Color _riskColor() {
    if (_riskScore >= 5 || _errorDensity > 0.15) {
      return Colors.red;
    } else if (_riskScore >= 3) {
      return Colors.orange;
    } else {
      return Colors.green;
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getImage,
        label: const Text("Scan Text"),
        icon: const Icon(Icons.document_scanner),
        backgroundColor: Colors.teal,
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
                  color: _riskColor().withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("📊 Risk Score: $_riskScore",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _riskColor())),
                        const SizedBox(height: 4),
                        Text(
                          "🧠 Error Density: ${_errorDensity.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "📏 Spelling Accuracy: ${(_spellingAccuracy * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "🔄 Letter Reversals Detected: $_letterReversalCount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 12),
                        if (_errorReport.isNotEmpty) ...[
                          const Text(
                            "🔍 Error Breakdown:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ..._errorReport
                              .map((e) => Text("• $e",
                              style: const TextStyle(fontSize: 14)))
                              .toList(),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          _riskScore >= 5 || _errorDensity > 0.15
                              ? "⚠️ Kuch patterns dyslexia/dysgraphia ki taraf ishara karte hain. Specialist se zarur mashwara karein."
                              : "✅ Filhal risk low hai, lekin agar shak ho to observation zaruri hai.",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "🔍 Note: Ye sirf ek screening tool hai. Diagnosis ke liye certified specialist se check-up zarur karayein.",
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

