import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String privacyText;

  const PrivacyPolicyPage({required this.privacyText});

  List<String> _splitIntoParagraphs(String text) {
    return text.split('\n\n'); // Double new line as paragraph separator
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _splitIntoParagraphs(privacyText);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color.fromARGB(255, 255, 248, 241),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            ...paragraphs.map((para) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    para.trim(),
                    style: const TextStyle(fontSize: 12, height: 1.5),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
