import 'dart:ui'; // Required for the blur effect
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // We wrap the bar in a ClipRRect and BackdropFilter to create the blur effect
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            // Use a semi-transparent color so the background shows through
            color: Colors.black.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Logo and Title
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // The path to your image
                      height: 100,
                      width: 100, // Control the size of your logo
                    ),
                    //const SizedBox(width: ),
                    const Text(
                      'SwapnaVastu', // YOUR CHANGE: Using your new title
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color is white for better contrast
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}