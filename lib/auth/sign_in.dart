import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:food_app/auth/register.dart'; // Added missing import

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserProvider userProvider;
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Loading state
  bool _isLoading = false;
  String _errorMessage = '';

  // Sign in with email and password
  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        // Sign in with email and password
        UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final User? user = authResult.user;

        if (user != null) {
          userProvider.addUserData(
            currentUser: user,
            userEmail: user.email ?? '',
            userImage: '', // No image for email/password login
            userName:
                user.email?.split('@')[0] ?? '', // Use part of email as name
          );

          // Navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to sign in: ${e.toString()}';
        });
        print('Error during email sign in: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Register with email and password
  Future<void> _registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        // Create user with email and password
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final User? user = authResult.user;

        if (user != null) {
          userProvider.addUserData(
            currentUser: user,
            userEmail: user.email ?? '',
            userImage: '', // No image for email/password login
            userName:
                user.email?.split('@')[0] ?? '', // Use part of email as name
          );

          // Navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to register: ${e.toString()}';
        });
        print('Error during email registration: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Add these methods for social login
  void _signInWithGoogle() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading for frontend-only implementation
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show a snackbar indicating this is just a frontend implementation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Google Sign In failed due to internet connection')));
    });
  }

  void _signInWithApple() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading for frontend-only implementation
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show a snackbar indicating this is just a frontend implementation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Apple Sign In failed due to internet connection')));
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/background.png')),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Vegi',
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.green.shade200,
                                  offset: Offset(3, 3),
                                )
                              ]),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        // Error message
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        SizedBox(height: 30),

                        // Sign in button
                        _isLoading
                            ? CircularProgressIndicator()
                            : Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _signInWithEmailAndPassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade800,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(child: Text('Sign In')),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(child: Text('Register')),
                                    ),
                                  ),
                                  SizedBox(height: 15),

                                  // Add social login buttons here
                                  SizedBox(height: 20),
                                  Row(children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text("OR",
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                    Expanded(child: Divider()),
                                  ]),
                                  SizedBox(height: 20),

                                  // Google Sign In Button
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.g_mobiledata,
                                        color: Colors.black87,
                                        size:
                                            28), // Using a built-in icon instead of network image
                                    label: Text(
                                      'Sign in with Google',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    onPressed: _signInWithGoogle,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15),

                                  // Apple Sign In Button
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.apple,
                                        color: Colors.white, size: 28),
                                    label: Text(
                                      'Sign in with Apple',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: _signInWithApple,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                        SizedBox(height: 20),
                        Text(
                          'By signing in you are agreeing to our Terms and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
