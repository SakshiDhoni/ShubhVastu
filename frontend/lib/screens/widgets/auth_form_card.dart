import 'package:flutter/material.dart';

class AuthFormCard extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController usernameCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onClose;

  const AuthFormCard({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.usernameCtrl,
    required this.isLoading,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 24),
          
          // --- ADDED FORM FIELDS START HERE ---
          _buildTextField(
            controller: usernameCtrl,
            label: 'Username',
            hint: 'Enter your username',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: emailCtrl,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: passwordCtrl,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock,
            isObscure: true,
          ),
          // --- ADDED FORM FIELDS END HERE ---
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: Icon(icon, color: Colors.white, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
     return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ],
    );
  }
}