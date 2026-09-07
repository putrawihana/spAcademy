import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/pages/welcome_page.dart';

class TermsServicePage extends StatefulWidget {
  const TermsServicePage({super.key});

  @override
  State<TermsServicePage> createState() => _TermsServicePageState();
}

class _TermsServicePageState extends State<TermsServicePage> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms & Service",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Last Updated: August 22, 2026"),
            SizedBox(height: 10),

            Text(
              "Welcome to SpAcademy. By accessing or using our application, website, or services, you agree to be bound by these Terms and Service. Please read this document carefully before using our platform. If you do not agree with any part of these terms, please discontinue using our services immediately.",
            ),

            SizedBox(height: 10),

            Text(
              "1. Acceptance of Terms",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "By creating an account or using our platform, you confirm that you have read, understood, and accepted these Terms and Service. These terms apply to all users, visitors, and customers.",
            ),

            SizedBox(height: 10),

            Text(
              "2. Eligibility",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You must have the legal capacity to enter into this agreement. If you are under the legal age in your jurisdiction, you may only use the service with permission from a parent or guardian.",
            ),

            SizedBox(height: 10),

            Text(
              "3. User Accounts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate and up-to-date information during registration.",
            ),

            SizedBox(height: 10),

            Text(
              "4. Acceptable Use",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You agree not to misuse the service, violate any applicable laws, upload malicious software, attempt unauthorized access, or harass other users while using our platform.",
            ),

            SizedBox(height: 10),

            Text(
              "5. User Content",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You retain ownership of any content you upload. However, you grant us permission to store, process, and display your content as necessary to operate and improve the service.",
            ),

            SizedBox(height: 10),

            Text(
              "6. Intellectual Property",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "All logos, designs, software, graphics, text, and other materials provided through the platform are protected by intellectual property laws and may not be copied or redistributed without permission.",
            ),

            SizedBox(height: 10),

            Text(
              "7. Payments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "If paid features are available, you agree to provide valid payment information. Prices may change without prior notice, and failure to complete payment may result in suspension of premium features.",
            ),

            SizedBox(height: 10),

            Text(
              "8. Refund Policy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Refunds, when applicable, will follow the refund policy presented during the purchase process.",
            ),

            SizedBox(height: 10),

            Text(
              "9. Privacy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Your use of our services is also governed by our Privacy Policy, which explains how your personal information is collected and protected.",
            ),

            SizedBox(height: 10),

            Text(
              "10. Service Availability",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We strive to keep the service available but cannot guarantee uninterrupted operation due to maintenance, technical issues, or circumstances beyond our control.",
            ),

            SizedBox(height: 10),

            Text(
              "11. Disclaimer",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "The service is provided on an 'as is' basis without warranties of any kind regarding accuracy, reliability, or availability.",
            ),

            SizedBox(height: 10),

            Text(
              "12. Limitation of Liability",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To the fullest extent permitted by law, we shall not be liable for indirect, incidental, or consequential damages arising from the use of our platform.",
            ),

            SizedBox(height: 10),

            Text(
              "13. Account Termination",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We reserve the right to suspend or terminate accounts that violate these Terms and Service or threaten the security of our platform.",
            ),

            SizedBox(height: 10),

            Text(
              "14. Third-Party Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Our application may contain links or integrations with third-party services. We are not responsible for their content or policies.",
            ),

            SizedBox(height: 10),

            Text(
              "15. Changes to These Terms",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We may update these Terms and Service from time to time. Continued use of the platform after changes means you accept the updated terms.",
            ),

            SizedBox(height: 10),

            Text(
              "16. Governing Law",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "These Terms and Service shall be governed by the applicable laws of the jurisdiction where our business operates.",
            ),

            SizedBox(height: 10),

            Text(
              "17. Contact Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Email: support@example.com"),
            Text("Website: https://example.com"),
            Text("Address: Your Company Address"),

            SizedBox(height: 30),

            Text(
              "By continuing to use our platform, you confirm that you have read, understood, and agreed to these Terms and Service in their entirety.",
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isCheck,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheck = value ?? false;
                    });
                  },
                ),
                Text('Saya Telah membaca term and services'),
              ],
            ),
            SizedBox(height: 5),
            FilledButton(
              onPressed: () {
                checklist();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
                backgroundColor: isCheck ? Colors.teal : Colors.grey,
              ),
              child: Text('Terima'),
            ),
          ],
        ),
      ),
    );
  }

  void checklist() {
    if (isCheck == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WelcomePage();
          },
        ),
      );
    }
  }
}
