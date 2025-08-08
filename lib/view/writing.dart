import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class DyslexiaImageScanner extends StatefulWidget {
  @override
  _DyslexiaImageScannerState createState() => _DyslexiaImageScannerState();
}

class _DyslexiaImageScannerState extends State<DyslexiaImageScanner> {
  File? _image;
  String _extractedText = '';
  int _riskScore = 0;
  double _errorDensity = 0.0;
  bool _showText = false; // for collapsing text view
  final picker = ImagePicker();

  // New: To store detailed error breakdown
  List<String> _errorReport = [];

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

  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    String text = recognizedText.text ?? ''; // ensure non-null
    int score = 0; // keep as int
    double density = 0.0; // keep as double

    final patterns = [
      // 1. Letter confusion/reversal: repeated or mirrored letters (b/p/q/d)
      RegExp(r'\b(?:[bpqd]){2,}\b', caseSensitive: false),

      // 2. Duplicate words (case-insensitive)
      RegExp(r'\b(\w+)\s+\1\b', caseSensitive: false),

      // 3. Overly long words (12+ letters)
      RegExp(r'\b[a-zA-Z]{12,}\b'),

      // 4. Large gaps / extra spaces
      RegExp(r'\s{3,}'),

      // 5. Single letters as words (excluding valid ones like "I" or "a")
      RegExp(r'\b(?![aAiI])[a-zA-Z]{1}\b'),

      // 6. Random capital letters in the middle of words (mixed case)
      RegExp(r'\b[a-z]+[A-Z]+[a-z]*\b'),

      // 7. Letter tripling or more
      RegExp(r'([a-zA-Z])\1{2,}'),

      // 8. Incomplete/broken words (too many hyphens or dots)
      RegExp(r'\b\w*(?:-{2,}|\.\.+)\w*\b'),

      // 9. Excess punctuation clutter
      RegExp(r'[!?.]{3,}'),

      // 10. Numbers inside words
      RegExp(r'\b[a-zA-Z]*\d+[a-zA-Z]*\b'),
    ];

    for (var pattern in patterns) {
      if (pattern.hasMatch(text)) {
        score++;
      }
    }

    int totalWords = text
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .length;

    density = totalWords > 0 ? score / totalWords : 0.0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('📷 Dyslexia Detector'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getImage,
        label: const Text("Scan Text"),
        icon: const Icon(Icons.document_scanner),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_image!, height: 200, fit: BoxFit.cover),
              )
            else
              Expanded(
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
                    height: _showText ? 200 : 60,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("📝 Extracted Text",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
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
                      const SizedBox(height: 12),
                      // New: Detailed error breakdown
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
    );
  }
}
