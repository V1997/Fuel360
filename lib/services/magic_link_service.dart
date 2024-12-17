
import 'package:firebase_auth/firebase_auth.dart';

class MagicLinkService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send magic link via email
  Future<void> sendMagicLink(String email) async {
    try {
      // Check if the input is an email or phone number
      if (_isValidEmail(email)) {
        await _sendEmailLink(email);
      } else if (_isValidPhoneNumber(email)) {
        await _sendPhoneLink(email);
      } else {
        throw Exception('Invalid email or phone number');
      }
    } catch (e) {
      print('Magic Link Error: $e');
      rethrow;
    }
  }

  // Send email link
  Future<void> _sendEmailLink(String email) async {
    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://yourapp.page.link/login', // Replace with your app's deep link
      handleCodeInApp: true,
      androidPackageName: 'com.yourcompany.yourapp',
      androidMinimumVersion: '1',
      iOSBundleId: 'com.yourcompany.yourapp',
    );

    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
  }

  // Send phone verification link
  Future<void> _sendPhoneLink(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in on Android
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception('Phone verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent to phone
        print('Verification code sent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        print('Verification code timeout');
      },
    );
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number format (basic validation)
  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }
}