import 'package:fasto_billing_software/auth/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'businessinfo.dart';

// Function to handle Google Sign-In
Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // If the user cancels sign-in

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    debugPrint("Google Sign-In Error: $e");
    return null;
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If login successful, navigate to BusinessInfoPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Star Icon
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.auto_awesome, size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Sign in Text
              const Text(
                'Sign in',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),

              // Forgot Password TextButton
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Implement forgot password functionality
                  },
                  child: const Text('Forgot password?', style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 20),

              // Log in Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Divider with Or Login with Text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or Login with',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Social Media Login Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: Image.asset(
                        'lib/images/facebookiconimg.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                      iconSize: 24,
                      onPressed: () {},
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: Image.asset(
                        'lib/images/google.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                      iconSize: 24,
                      onPressed: () async {
                        UserCredential? userCredential = await signInWithGoogle();
                        if (userCredential != null) {
                          // Navigate to the next page on successful login
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Google Sign-In failed")),
                          );
                        }
                      },
                    ),
                  ),

                  Flexible(
                    child: IconButton(
                      icon: Image.asset(
                        'lib/images/appleiconimg.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                      iconSize: 24,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Sign up Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Create Account Page
                      Navigator.pushNamed(context, '/create-account');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
