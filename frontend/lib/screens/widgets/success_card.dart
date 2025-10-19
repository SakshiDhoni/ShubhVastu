import 'package:flutter/material.dart';

class SuccessCard extends StatelessWidget {
  final VoidCallback onReset;

  const SuccessCard({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 64),
          const SizedBox(height: 24),
          const Text('Thank You!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          const Text(
            'Your information has been received. We will get in touch with you shortly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onReset,
            child: const Text('Submit Another Enquiry'),
          ),
        ],
      ),
    );
  }
}