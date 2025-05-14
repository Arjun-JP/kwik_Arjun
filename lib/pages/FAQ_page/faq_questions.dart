import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> _faqData = [
    {
      'question': 'How do I place an order?',
      'answer':
          'To place an order, simply browse our products, add them to your cart, and proceed to checkout. You will need to provide your delivery address and payment details.',
    },
    {
      'question': 'What are your delivery hours?',
      'answer':
          'Our delivery hours are from 7 AM to 11 PM, 7 days a week. We aim to deliver your groceries within 10-15 minutes.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept all major credit and debit cards, UPI, and cash on delivery.',
    },
    {
      'question': 'Can I track my order?',
      'answer':
          'Yes, you can track your order in real-time through the app. You will receive updates on the delivery status.',
    },
    {
      'question': 'What if I want to return an item?',
      'answer':
          'We have a hassle-free return policy. If you are not satisfied with an item, you can return it within 7 days for a full refund or exchange.',
    },
    {
      'question': 'Is there a minimum order amount?',
      'answer':
          'No, there is no minimum order amount. You can order as little or as much as you need.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact our customer support team through the app’s help section or by calling our support number.',
    },
    {
      'question': 'Do you offer any discounts or promotions?',
      'answer':
          'Yes, we frequently offer discounts and promotions. Keep an eye on the app for the latest deals.',
    },
    {
      'question': 'Can I schedule a delivery for a later time?',
      'answer':
          'Currently, we focus on quick deliveries. However, we are working on adding scheduling options in the future.',
    },
    {
      'question': 'What areas do you deliver to?',
      'answer':
          'We currently deliver to all major areas within [Your City/Region]. You can check if we deliver to your area by entering your address in the app.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align message to start
            children: [
              Image.asset(
                'assets/images/kwiklogo.png', // Replace with your logo asset path
                height: 120, // Adjust logo height as needed
              ),
              const SizedBox(width: 8),
              const Text(
                "Thank you for choosing Kwik!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Text(
                "Your trust fuels our commitment to quick and reliable service.We're here to make your grocery shopping seamless and efficient.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                  height: 16), // Add space between message and FAQ list
              ..._faqData.map((faq) {
                return Card(
                  elevation: 1,
                  shadowColor: const Color.fromARGB(255, 255, 255, 255),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(faq['answer']!),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
