import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savepoint_app/screens/sign_up_screen.dart';

import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // Future<User?> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();

  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );

  //       final userCredential = await _auth.signInWithCredential(credential);
  //       return userCredential.user;
  //     }
  //   } catch (error) {
  //     print(error);
  //     return null;
  //   }
  // } disabled for now

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        print('Error code: ${e.code}');
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          default:
            errorMessage = e.message!;
            break;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error logging in. Please try again.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SavePoint Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                      'assets/SavepointLogo1.png'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (value) => _email = value!,
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter your email.";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter your password.";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextButton(
                  child: Text('Forgot password?'),
                  onPressed: () {
                    // Navigate to ForgotPasswordScreen
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ForgotPasswordScreen()));
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: _signInWithEmailAndPassword,
                ),
                SizedBox(height: 10),
                TextButton(
                  child: Text('Don\'t have an account? Register here!'),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SignUpScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
