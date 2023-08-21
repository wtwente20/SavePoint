import 'package:firebase_auth/firebase_auth.dart'; // Ensure you have imported this package.
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savepoint_app/screens/sign_up_screen.dart'; // Ensure you have imported this package.

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

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) { // Catch FirebaseAuthException
      print('Error code: ${e.code}');
      String errorMessage;

      // Use switch-case to match against the error codes and provide a more friendly message.
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error logging in. Please try again.")));
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
          child: Column(
            children: [
              // Placeholder for your logo
              Container(
                height: 200,
                width: 200,
                color: Colors.grey[300],
                child: Center(child: Text('Logo Placeholder')),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign in with Google'),
                onPressed: _signInWithGoogle,
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
              ElevatedButton(
                child: Text('Login'),
                onPressed: _signInWithEmailAndPassword,
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Don\'t have an account? Register here!'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
