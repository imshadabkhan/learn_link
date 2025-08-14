import 'package:flutter/material.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';



class DyslexiaInfoScreen extends StatelessWidget {
  DyslexiaInfoScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> types = [
    {
      'title': 'Dyslexia',
      'desc':
      'A specific learning disability that affects reading, recognition, and related language-based processing skills.',
      'url': "https://en.wikipedia.org/wiki/Dyslexia"
    },
    {
      'title': 'Dysgraphia',
      'desc':
      'A specific learning disability that affects a person’s handwriting ability and fine motor skills.',
      'url': "https://en.wikipedia.org/wiki/Dysgraphia"
    },
    {
      'title': 'Dyscalculia',
      'desc':
      'A specific learning disability that affects a person’s ability to understand numbers and learn math facts.',
      'url': 'https://en.wikipedia.org/wiki/Dyscalculia'
    },
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      throw 'Could not open $url';
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showDownloadDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Texts.textBold("Download Report",size: 18),
        content:  Texts.textNormal(size: 14,
          "This will open the official 2024 State of Learning Disabilities report "
              "(PDF, 50+ pages, ~5 MB). \nDo you want to continue?",
          maxLines: 10
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openUrl(url);
            },
            child:  Text("Download",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Learning Difficulties'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Texts.textBold(
            maxlines: 2,
            'Understanding Learning Difficulties',
            size: 16,
            textAlign: TextAlign.start
          ),
          Widgets.heightSpaceH1,
          Texts.textNormal(
            'Learning difficulties are umbrella terms for problems in areas such as reading, written expression, or mathematics. Early identification is important to support children with targeted strategies.',
            size: 12,
              maxLines: 12,
            textAlign: TextAlign.start
          ),

          Widgets.heightSpaceH2,

          Texts.textBold('Types of Learning Difficulties', size: 16,textAlign: TextAlign.start),
          Widgets.heightSpaceH1,

          ...types.map((t) {
            return Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Texts.textBold(
                  t['title']!,textAlign: TextAlign.start,
                 size: 14
                ),

                subtitle: Texts.textNormal(t['desc']!,size: 12,textAlign: TextAlign.start),
                trailing: const Icon(Icons.open_in_new, color: Colors.teal),
                onTap: () {
                  final url = t['url'];
                  if (url != null && url.isNotEmpty) _openUrl(url);
                },
              ),
            );
          }).toList(),

         Widgets.heightSpaceH2,
          CustomButton(
            backgroundColor: Colors.teal,
            label:'View Full Report' ,
            onTap: (){
              _showDownloadDialog(
                context,
                'https://www.ncld.org/wp-content/uploads/2024/12/241210-SoLD-Report-Booklet-1.pdf',
              );

            },
          )

        ,

          Widgets.heightSpaceH2,
          Texts.textBold('Recommendations',size: 14,textAlign: TextAlign.start),
          Widgets.heightSpaceH1,
          Texts.textNormal(
            size: 13,
            'Early identification and intervention are critical.\n'
                'Provide in-service training to teachers.\n'
                'Use counseling and specialized techniques to support learners.\n'
                'Partner with psychology departments for internships and extra support.',
            maxLines: 10,textAlign: TextAlign.start
          ),
         Widgets.heightSpaceH1,
        ],
      ),
    );
  }
}

