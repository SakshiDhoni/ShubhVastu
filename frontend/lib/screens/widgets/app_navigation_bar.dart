import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  // REMOVED: The callback is no longer needed
  // final VoidCallback onAuthButtonPressed;

  const AppNavigationBar({
    super.key,
    // required this.onAuthButtonPressed, // REMOVED
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App Logo and Title
            const Row(
              children: [
                Icon(
                  Icons.business_center_rounded,
                  color: Color(0xFF2563EB),
                  size: 36,
                ),
                SizedBox(width: 16),
                Text(
                  'CtoC Broker',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            // REMOVED: The ElevatedButton for "Sign Up / Login" is gone
          ],
        ),
      ),
    );
  }
}