import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      color: const Color(0xFF1F2937), // A dark background for the footer
      child: Column(
        children: [
          const Wrap(
            spacing: 40,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _FooterContactInfo(
                icon: Icons.phone,
                text: '+91 98765 43210',
              ),
              _FooterContactInfo(
                icon: Icons.email,
                text: 'info@ctocbroker.com',
              ),
              _FooterContactInfo(
                icon: Icons.location_on,
                text: 'Ahmadnagar, Maharashtra, India',
              ),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            '© 2025 CtoC Broker. All rights reserved.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
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
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}