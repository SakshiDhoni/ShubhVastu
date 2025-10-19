import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'Why Choose CtoC Broker?',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937), // Darker text for light background
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'We connect customers and contractors directly, making transactions seamless.',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          const Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _FeatureCard(
                icon: Icons.handshake_rounded,
                title: 'Direct Connection',
                description: 'Connect directly with contractors or customers without intermediaries.',
              ),
              _FeatureCard(
                icon: Icons.verified_user_rounded,
                title: 'Verified Listings',
                description: 'All property and service listings are verified for authenticity and quality.',
              ),
              _FeatureCard(
                icon: Icons.support_agent_rounded,
                title: '24/7 Support',
                description: 'Round-the-clock customer support to assist you at every step of the way.',
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
      width: 280,
      padding: const EdgeInsets.all(32),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
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