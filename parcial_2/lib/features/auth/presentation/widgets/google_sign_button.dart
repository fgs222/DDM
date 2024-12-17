import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleSignButton extends StatelessWidget {
  final FirebaseAuth auth;
  final void Function(String) onSignIn;

  const GoogleSignButton({
    super.key,
    required this.auth,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: SignInButton(
          Buttons.googleDark,
          onPressed: () async {
            await _handleGoogleSign(auth, onSignIn);
          },
        ),
      )
    );
  }
}


Future<void> _handleGoogleSign(FirebaseAuth auth, void Function(String) onSignIn) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final String idToken = googleAuth.idToken!;
      final User? user = userCredential.user;
      
      if (user != null) {
        onSignIn(idToken);

        final firebaseFirestore = FirebaseFirestore.instance;
        final profileDoc = await firebaseFirestore.collection('profiles').doc(user.uid).get();

        if (!profileDoc.exists) {
          await firebaseFirestore.collection('profiles').doc(user.uid).set({
            'email': user.email,
            'username': user.displayName,
          });
        }

        print("User signed in: ${user.displayName}");
      }
    } else {
      // Handle user cancellation of the sign-in flow
      print("Google sign-in aborted by user.");
    }
  } catch (e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          print('Account exists with different credentials.');
          break;
        case 'invalid-credential':
          print('Invalid credential.');
          break;
        default:
          print('Unknown FirebaseAuthException: ${e.message}');
      }
    } else {
      print('Unknown error: $e');
    }
  }
}
