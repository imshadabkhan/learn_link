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
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _extractedText = '';
        _riskScore = 0;
        _errorDensity = 0.0;
      });
      _recognizeText(File(pickedFile.path));
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    int score = 0;



    final patterns = [
      RegExp(r'\b([bpqd]){2,}\b'), // confusing letters repeated
      RegExp(r'\b(\w+)\s+\1\b', caseSensitive: false), // repeated words like "the the"
      RegExp(r'\b\w{12,}\b'), // very long words
      RegExp(r'\s{3,}'), // excessive spacing
      RegExp(r'\b[a-zA-Z]{1,2}\b'), // lots of very short words
    ];

    for (var pattern in patterns) {
      if (pattern.hasMatch(text)) {
        score++;
        print("Matched: ${pattern.pattern}");
      }
    }

    int totalWords = text.split(RegExp(r'\s+')).where((word) => word.trim().isNotEmpty).length;
    double density = totalWords > 0 ? score / totalWords : 0;

    setState(() {
      _extractedText = text;
      _riskScore = score;
      _errorDensity = density;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📷 Dyslexia Detector'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: _getImage,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
              ),
            const SizedBox(height: 10),
            if (_extractedText.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '📝 Extracted Text:\n\n$_extractedText',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (_extractedText.isNotEmpty)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "📊 Risk Score: $_riskScore\n"
                        "🧠 Error Density: ${_errorDensity.toStringAsFixed(2)}\n\n"
                        "${_riskScore >= 3 || _errorDensity > 0.1 ? "⚠️ Kuch patterns dyslexia ki taraf ishara karte hain. Specialist se zarur mashwara karein." : "✅ Filhal risk low hai, lekin agar shak ho to observation zaruri hai."}\n\n"
                        "🔍 Note: Ye sirf ek screening tool hai. Diagnosis ke liye certified specialist se check-up zarur karayein.",
                    style: TextStyle(fontSize: 16,color: Colors.black),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
