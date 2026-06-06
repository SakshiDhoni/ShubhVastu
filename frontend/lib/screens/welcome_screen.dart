import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/api_service.dart'; // ApiService call is commented out below

// Import widget components
import 'widgets/app_navigation_bar.dart';
import 'widgets/enquiry_form_card.dart';
import 'widgets/success_card.dart';
import 'widgets/features_section.dart';
import 'widgets/app_footer.dart';
import 'widgets/property_carousel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

enum FormType { carousel, enquiry, success }

class _WelcomeScreenState extends State<WelcomeScreen> {
  // --- STATE AND CONTROLLERS ---
  FormType _currentForm = FormType.carousel;
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

    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // Validation now includes strict email regex and phone minimum digits
    if (name.isEmpty || !emailRegex.hasMatch(email) || phone.length < 10 || city.isEmpty || _selectedPropertyType.isEmpty) {
      _showSnack('Please check your inputs. Ensure the email is valid and phone has at least 10 digits.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Save to Firestore
      // Added phone number to the Firestore document with a network timeout
      await FirebaseFirestore.instance.collection('user_inquiries').add({
        'name': name,
        'contact': email,
        'phone': phone,
        'city': city,
        'propertyType': _selectedPropertyType,
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Network timeout. Please check your internet connection.');
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
      String errorStr = e.toString().contains('Exception:') 
          ? e.toString().split('Exception:')[1].trim() 
          : 'Submission failed. Please check your internet connection.';
      _showSnack(errorStr, isError: true);
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
                child: Image.asset(
                  'assets/background_img.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF1a1a2e),
                  ),
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Container(color: const Color(0xFF1a1a2e));
                  },
                ),
              ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          SingleChildScrollView(
            child: Column(
              children: [
                const AppNavigationBar(),
                SizedBox(
                  height: 800,
                  child: Align(
                    alignment: const Alignment(0, -0.4), // Moves the carousel/form slightly upwards
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
      case FormType.carousel:
        return PropertyCarousel(
          key: const ValueKey('carousel'),
          onCardTap: () {
            setState(() {
              _currentForm = FormType.enquiry;
            });
          },
        );

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
                _currentForm = FormType.carousel;
              });
          },
        );
    }
  }
}

