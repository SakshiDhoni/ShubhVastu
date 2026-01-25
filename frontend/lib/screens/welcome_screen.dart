import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/api_service.dart'; // ApiService call is commented out below

// Import widget components
import 'widgets/app_navigation_bar.dart';
import 'widgets/enquiry_form_card.dart';
import 'widgets/success_card.dart';
import 'widgets/features_section.dart';
import 'widgets/app_footer.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

enum FormType { enquiry, success }

class _WelcomeScreenState extends State<WelcomeScreen> {
  // --- STATE AND CONTROLLERS ---
  FormType _currentForm = FormType.enquiry;
  bool _isLoading = false;
  String _selectedPropertyType = '';

  // Using dedicated controllers for the enquiry form
  final _nameCtrl = TextEditingController();
  final _enquiryEmailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); // Controller for phone number
  final _cityCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _enquiryEmailCtrl.dispose();
    _phoneCtrl.dispose(); // Dispose the new controller
    _cityCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool isError = false}) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // --- LOGIC (UPDATED) ---
  
  // This is the only submission logic needed now. Email sending is commented out.
  Future<void> _handleEnquirySubmit() async {
    final name = _nameCtrl.text.trim();
    final email = _enquiryEmailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim(); // Get phone number
    final city = _cityCtrl.text.trim();

    // Validation now includes the phone number
    if (name.isEmpty || !email.contains('@') || phone.isEmpty || city.isEmpty || _selectedPropertyType.isEmpty) {
      _showSnack('Please fill all fields with a valid email.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Save to Firestore
      // Added phone number to the Firestore document
      await FirebaseFirestore.instance.collection('user_inquiries').add({
        'name': name,
        'contact': email,
        'phone': phone,
        'city': city,
        'propertyType': _selectedPropertyType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // --- EMAIL SENDING LOGIC COMMENTED OUT ---
      // final response = await ApiService.handleEnquiry(
      //   name: name,
      //   contact: email,
      //   city: city,
      //   propertyType: _selectedPropertyType,
      // );

      // if (response.statusCode == 200) {
      //   _showSnack('Enquiry sent successfully!');
      //   setState(() => _currentForm = FormType.success);
      // } else {
      //   throw Exception('Server responded with status code: ${response.statusCode}');
      // }
      // --- END OF COMMENTED CODE ---

      // Directly show success after saving to Firestore since the email step is bypassed.
      _showSnack('Enquiry submitted successfully!');
      setState(() => _currentForm = FormType.success);

    } catch (e) {
      // Updated the error message to be more general.
      _showSnack('Submission failed. Please try again later.', isError: true);
      print('❌ Submission Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- BUILD METHOD ---
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=1920&q=80',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.4))),
          SingleChildScrollView(
            child: Column(
              children: [
                const AppNavigationBar(),
                SizedBox(
                  height: 900,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildFormContent(),
                    ),
                  ),
                ),
                const FeaturesSection(),
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormContent() {
    switch (_currentForm) {
      case FormType.enquiry:
        return EnquiryFormCard(
          key: const ValueKey('enquiry'),
          nameCtrl: _nameCtrl,
          emailCtrl: _enquiryEmailCtrl,
          phoneCtrl: _phoneCtrl, // Pass phone controller
          cityCtrl: _cityCtrl,
          selectedPropertyType: _selectedPropertyType,
          onPropertyTypeChanged: (value) => setState(() => _selectedPropertyType = value ?? ''),
          isLoading: _isLoading,
          onSubmit: _handleEnquirySubmit,
        );
      
      case FormType.success:
        return SuccessCard(
          key: const ValueKey('success'),
          onReset: () {
            _nameCtrl.clear();
              _enquiryEmailCtrl.clear();
              _phoneCtrl.clear(); // Clear phone field on reset
              _cityCtrl.clear();
              setState(() {
                _selectedPropertyType = '';
                _currentForm = FormType.enquiry;
              });
          },
        );
    }
  }
}

