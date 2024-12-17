import 'package:flutter/material.dart';
/*
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
*/

import '../services/google_auth_service.dart';
/*
import '../services/microsoft_auth_service.dart';
import '../services/apple_auth_service.dart';
*/
import '../services/magic_link_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Authentication services
  final GoogleAuthService _googleAuthService = GoogleAuthService();
//  final MicrosoftAuthService _microsoftAuthService = MicrosoftAuthService();
//  final AppleAuthService _appleAuthService = AppleAuthService();
  final MagicLinkService _magicLinkService = MagicLinkService();

  // Method to handle Google login
  Future<void> _handleGoogleLogin() async {
    setState(() { _isLoading = true; });
    try {
      final user = await _googleAuthService.signInWithGoogle();
      _navigateToHomeOrProfileSetup(user);
    } catch (e) {
      _showErrorSnackBar('Google login failed: ${e.toString()}');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Method to handle Microsoft login
  /*Future<void> _handleMicrosoftLogin() async {
    setState(() { _isLoading = true; });
    try {
      final user = await _microsoftAuthService.signInWithMicrosoft();
      _navigateToHomeOrProfileSetup(user);
    } catch (e) {
      _showErrorSnackBar('Microsoft login failed: ${e.toString()}');
    } finally {
      setState(() { _isLoading = false; });
    }
  }*/

  // Method to handle Apple login
/*
  Future<void> _handleAppleLogin() async {
    // Only allow Apple login on iOS
    if (!_isApplePlatform()) {
      _showErrorSnackBar('Apple login is only available on iOS devices');
      return;
    }

    setState(() { _isLoading = true; });
    try {
      final user = await _appleAuthService.signInWithApple();
      _navigateToHomeOrProfileSetup(user);
    } catch (e) {
      _showErrorSnackBar('Apple login failed: ${e.toString()}');
    } finally {
      setState(() { _isLoading = false; });
    }
  }
*/

  // Method to handle Magic Link login
  void _showMagicLinkLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter email or phone number',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) async {
                try {
                  await _magicLinkService.sendMagicLink(value);
                  Navigator.pop(context);
                  _showSuccessSnackBar('Magic link sent to $value');
                } catch (e) {
                  _showErrorSnackBar('Failed to send magic link: ${e.toString()}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Check if the current platform supports Apple login
  /*bool _isApplePlatform() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }*/

  // Navigation method after successful login
  void _navigateToHomeOrProfileSetup(dynamic user) {
    // Implement navigation logic based on whether it's a new or existing user
    // Navigator.pushReplacement(context, MaterialPageRoute(...));
  }

  // Error handling methods
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Google Login Button
              ElevatedButton.icon(
                icon: Image.asset('assets/google_logo.png', height: 24),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                onPressed: _handleGoogleLogin,
              ),
              const SizedBox(height: 12),

              // Microsoft Login Button
/*
              ElevatedButton.icon(
                icon: Image.asset('assets/microsoft_logo.png', height: 24),
                label: Text('Continue with Microsoft'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: _handleMicrosoftLogin,
              ),
              SizedBox(height: 12),

              // Apple Login Button (conditionally rendered)
              if (_isApplePlatform())
                ElevatedButton.icon(
                  icon: Image.asset('assets/apple_logo.png', height: 24),
                  label: Text('Continue with Apple'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _handleAppleLogin,
                ),
              SizedBox(height: 12),
*/

              // Magic Link Login Button
              ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: const Text('Continue with Email/Phone'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: _showMagicLinkLoginBottomSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}