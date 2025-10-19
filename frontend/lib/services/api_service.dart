import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';

  /// Handles the initial user enquiry.
  /// Sends data to Firestore and triggers a notification via the backend.
  static Future<http.Response> handleEnquiry({
    required String name,
    required String contact,
    required String city,
    required String propertyType,
    //required String userType,
  }) {
    final channel = contact.contains('@') ? 'email' : 'whatsapp';
    final message =
       '🏠 Welcome, $name! You\'re interested in $propertyType in $city. We\'ll connect you soon!';
       
    return http.post(
      Uri.parse('$_baseUrl/notify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'to': contact,
        'text': message,
        'channel': channel,
      }),
    ).timeout(const Duration(seconds: 15));
  }

  /// Registers a new user via the backend.
  static Future<http.Response> registerUser({
    required String email,
    required String password,
    required String username,
  }) {
    return http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    ).timeout(const Duration(seconds: 15));
  }
}