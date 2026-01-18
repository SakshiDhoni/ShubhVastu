import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // CORRECTED: Reduced vertical padding
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            // CORRECTED: Changed the company name
            'Why Choose ShubhVastu?',
            textAlign: TextAlign.center,
            style: TextStyle(
              // CORRECTED: Reduced font size
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            // CORRECTED: Updated the tagline to be more relevant
            'Your trusted partner in finding the perfect property.',
            style: TextStyle(
              // CORRECTED: Reduced font size
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          // CORRECTED: Reduced spacing
          const SizedBox(height: 60),
          const Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _FeatureCard(
                icon: Icons.handshake_rounded,
                title: 'Direct Connection',
                // CORRECTED: Updated feature description
                description: 'Connect directly with owners and buyers, ensuring transparency.',
              ),
              _FeatureCard(
                icon: Icons.verified_user_rounded,
                title: 'Verified Listings',
                // CORRECTED: Updated feature description
                description: 'Every property is thoroughly checked and verified by our expert team.',
              ),
              _FeatureCard(
                icon: Icons.support_agent_rounded,
                title: '24/7 Support',
                // CORRECTED: Updated feature description
                description: 'Our dedicated support team is here to help you at every step of your journey.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // CORRECTED: Reduced card width
      width: 260,
      // CORRECTED: Reduced padding
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            // CORRECTED: Reduced icon container size
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            // CORRECTED: Reduced icon size
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              // CORRECTED: Reduced font size
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              // CORRECTED: Reduced font size
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
