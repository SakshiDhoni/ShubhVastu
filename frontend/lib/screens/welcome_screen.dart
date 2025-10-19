import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart'; // Using the ApiService for cleaner code

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

// CORRECTED: The 'auth' state is no longer needed
enum FormType { enquiry, success }

class _WelcomeScreenState extends State<WelcomeScreen> {
  // --- STATE AND CONTROLLERS (CORRECTED) ---
  FormType _currentForm = FormType.enquiry;
  bool _isLoading = false;
  String _selectedPropertyType = '';
 // String _selectedUserType = 'Customer';

  // Using a dedicated controller for the enquiry email
  final _nameCtrl = TextEditingController();
  final _enquiryEmailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  
  // REMOVED: All controllers for the old auth form are gone

  @override
  void dispose() {
    _nameCtrl.dispose();
    _enquiryEmailCtrl.dispose();
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

  // --- LOGIC (CORRECTED) ---
  
  // This is the only submission logic needed now
  Future<void> _handleEnquirySubmit() async {
    final name = _nameCtrl.text.trim();
    final email = _enquiryEmailCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    // Updated validation for a valid email
    if (!email.contains('@') || city.isEmpty || _selectedPropertyType.isEmpty) {
      _showSnack('Please fill all fields with a valid email.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Save to Firestore
      await FirebaseFirestore.instance.collection('user_inquiries').add({
        'name': name,
        'contact': email,
        'city': city,
        'propertyType': _selectedPropertyType,
        //'userType': _selectedUserType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Step 2: Call the backend via the ApiService (cleaner)
      final response = await ApiService.handleEnquiry(
        name: name,
        contact: email,
        city: city,
        propertyType: _selectedPropertyType,
       // userType: _selectedUserType,
      );

      if (response.statusCode == 200) {
        _showSnack('Enquiry sent successfully!');
        setState(() => _currentForm = FormType.success);
      } else {
        throw Exception('Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnack('Submission failed. Could not connect to the server.', isError: true);
      print('❌ Submission Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // REMOVED: The entire _handleAuthSubmit function is gone

  // --- BUILD METHOD (CORRECTED) ---
  
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
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          SingleChildScrollView(
            child: Column(
              children: [
                // CORRECTED: No callback needed for the button that was removed
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
          cityCtrl: _cityCtrl,
          selectedPropertyType: _selectedPropertyType,
          onPropertyTypeChanged: (value) => setState(() => _selectedPropertyType = value ?? ''),
        //  selectedUserType: _selectedUserType,
         // onUserTypeChanged: (value) => setState(() => _selectedUserType = value),
          isLoading: _isLoading,
          onSubmit: _handleEnquirySubmit,
        );
      
      // REMOVED: The case for the auth form is gone
      
      case FormType.success:
        return SuccessCard(
          key: const ValueKey('success'),
          onReset: () {
            _nameCtrl.clear();
             _enquiryEmailCtrl.clear();
             _cityCtrl.clear();
             setState(() {
               _selectedPropertyType = '';
              // _selectedUserType = 'Customer';
               _currentForm = FormType.enquiry;
             });
          },
        );
    }
  }
}