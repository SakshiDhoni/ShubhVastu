// import 'dart:ui';
// import 'package:flutter/material.dart';

// class EnquiryFormCard extends StatelessWidget {
//   final TextEditingController nameCtrl;
//   final TextEditingController emailCtrl;
//   final TextEditingController phoneCtrl;
//   final TextEditingController cityCtrl;

//   final String selectedPropertyType;
//   final ValueChanged<String?> onPropertyTypeChanged;
//   final bool isLoading;
//   final VoidCallback onSubmit;

//   const EnquiryFormCard({
//     super.key,
//     required this.nameCtrl,
//     required this.emailCtrl,
//     required this.phoneCtrl,
//     required this.cityCtrl,
//     required this.selectedPropertyType,
//     required this.onPropertyTypeChanged,
//     required this.isLoading,
//     required this.onSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: const EdgeInsets.all(32),
//           constraints: const BoxConstraints(maxWidth: 450),
//           decoration: _cardDecoration(),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   'Let\'s Find Your Dream Property',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildPropertyTypeDropdown(),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: nameCtrl,
//                 label: 'Your Name',
//                 hint: 'Enter your full name',
//                 icon: Icons.person,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: emailCtrl,
//                 label: 'Email Address',
//                 hint: 'email@example.com',
//                 icon: Icons.email,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: phoneCtrl,
//                 label: 'Phone Number',
//                 hint: 'Enter your phone number',
//                 icon: Icons.phone,
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: cityCtrl,
//                 label: 'City',
//                 hint: 'Enter your city',
//                 icon: Icons.location_city,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : onSubmit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black.withOpacity(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text(
//                           'Submit Enquiry',
//                           style: TextStyle(
        
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
                          
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------- DROPDOWN ----------
//   Widget _buildPropertyTypeDropdown() {
//     final List<String> propertyTypes = ['Bungalow', 'Flat', 'Commercial'];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Property Type',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.white.withOpacity(0.35)),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               borderRadius: BorderRadius.circular(14),
//               value:
//                   selectedPropertyType.isEmpty ? null : selectedPropertyType,
//               hint: Text(
//                 'Select Property Type',
//                 style: TextStyle(color: Colors.white.withOpacity(0.7)),
//               ),
//               isExpanded: true,
//               padding: const EdgeInsets.symmetric(horizontal: 16),

//               dropdownColor: const Color(0xFF1F2937),

//               style: const TextStyle(color: Colors.white),
//               icon: const Icon(Icons.arrow_drop_down, color: Colors.white),

//               items: propertyTypes.map((type) {
//                 return DropdownMenuItem<String>(
                  
//                   value: type,
//                   child: const Text(
//                     '', // placeholder replaced below
//                   ),
//                 );
//               }).toList().asMap().entries.map((entry) {
//                 final type = propertyTypes[entry.key];
//                 return DropdownMenuItem<String>(
//                   value: type,
//                   child: Text(
//                     type,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 );
//               }).toList(),

//               onChanged: onPropertyTypeChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }


//   // ---------- TEXT FIELD ----------
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
//             prefixIcon: Icon(icon, color: Colors.white),
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//                   BorderSide(color: Colors.white.withOpacity(0.35)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//                   const BorderSide(color: Colors.white, width: 1.5),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------- CARD DECORATION ----------
//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.black.withOpacity(0.18),
//       borderRadius: BorderRadius.circular(24),
//       border: Border.all(color: Colors.white.withOpacity(0.25)),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.25),
//           blurRadius: 30,
//           offset: const Offset(0, 15),
//         ),
//       ],
//     );
//   }
// }


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EnquiryFormCard extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController cityCtrl;

  final String selectedPropertyType;
  final ValueChanged<String?> onPropertyTypeChanged;
  final bool isLoading;
  final VoidCallback onSubmit;

  const EnquiryFormCard({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.cityCtrl,
    required this.selectedPropertyType,
    required this.onPropertyTypeChanged,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: _cardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Let\'s Find Your Dream Property',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildPropertyTypeDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: nameCtrl,
                label: 'Your Name',
                hint: 'Enter your full name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailCtrl,
                label: 'Email Address',
                hint: 'email@example.com',
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: phoneCtrl,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: cityCtrl,
                label: 'City',
                hint: 'Enter your city',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Enquiry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- DROPDOWN (FIXED) ----------
  Widget _buildPropertyTypeDropdown() {
    final List<String> propertyTypes = ['Bungalow', 'Flat', 'Commercial'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Type',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            value:
                selectedPropertyType.isEmpty ? null : selectedPropertyType,

            hint: Text(
              'Select Property Type',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),

            // 🔹 Field style
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
            ),

            // 🔹 Forces dropdown to open DOWN + circular popup
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, 8),
              maxHeight: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            menuItemStyleData: const MenuItemStyleData(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),

            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
            ),

            items: propertyTypes
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .toList(),

            onChanged: onPropertyTypeChanged,
          ),
        ),
      ],
    );
  }

  // ---------- TEXT FIELD ----------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: Icon(icon, color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.35)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- CARD DECORATION ----------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.18),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ],
    );
  }
}
