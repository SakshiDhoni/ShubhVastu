import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // CORRECTED: Reduced padding to make the footer smaller
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: const Color(0xFF1F2937), // A dark background for the footer
      child: Column(
        children: [
          const Wrap(
            spacing: 30, // Adjusted spacing
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _FooterContactInfo(
                icon: Icons.phone,
                text: '+91-7588139239',
              ),
              _FooterContactInfo(
                icon: Icons.email,
                text: 'swapnavastu@gmail.com', // UPDATED: Email address
              ),
              _FooterContactInfo(
                icon: Icons.location_on,
                text: 'Nashik, Maharashtra, India',
              ),
            ],
          ),
          // CORRECTED: Reduced vertical spacing
          const SizedBox(height: 25),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 25),
          Text(
            // CORRECTED: Changed the company name and year
            '© 2025 Swapnavastu. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              // CORRECTED: Reduced font size
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FooterContactInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // CORRECTED: Reduced icon size
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            // CORRECTED: Reduced font size for a cleaner look
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
