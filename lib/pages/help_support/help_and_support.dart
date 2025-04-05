import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color.fromARGB(255, 255, 248, 241),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg", // Use your own asset
                height: 120,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Our Mission",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "To simplify everyday tasks with technology that’s fast, reliable, and user-friendly.",
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              "Our Vision",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "To empower individuals and businesses through innovative digital solutions that drive efficiency and convenience.",
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Company Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kwik Digital Solutions Pvt Ltd\nPlot No. 42, KwikTech Park,\nKoramangala 5th Block,\nBengaluru, Karnataka - 560095\nIndia',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Text(
              'Customer Support',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              '📧 Email: support@kwik.com\n📞 Phone: +91 98765 43210\n📞 Alt: +91 91234 56789',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Text(
              'Working Hours',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Monday to Friday: 9 AM - 6 PM\nSaturday: 10 AM - 2 PM\nSunday: Closed',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Text(
              'FAQs & Troubleshooting',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Need help? Visit our in-app Help Center or explore our website for tutorials, FAQs, and support articles.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
