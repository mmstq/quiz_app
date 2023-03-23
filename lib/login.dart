import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/util.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),),
      body: Center(
        child: OutlinedButton(
          child: const Icon(FontAwesomeIcons.google),
          onPressed: ()async{

            final creds = await signInWithGoogle();
            Utils.preferences!.setString('email',  creds.user!.email!);
          },
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {

    final instance = FirebaseAuth.instance;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();


    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    instance.setPersistence(Persistence.LOCAL);
    // Once signed in, return the UserCredential
    return await instance.signInWithCredential(credential);

  }



}
