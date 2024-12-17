import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcial_2/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String userName,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
  Future<UserModel> loginWithGoogle(String idToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('profiles').doc(userCredential.user!.uid).set({
        'userName': userName,
        'email': email,
      });
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('profiles').doc(userCredential.user!.uid).get();
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
  
  @override
  Future<UserModel> getCurrentUserData() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('profiles').doc(user.uid).get();
        return UserModel.fromFirestore(userData);
      } else {
        throw FirebaseAuthException(code: 'user-not-found', message: 'User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
  
  @override
  Future<UserModel> loginWithGoogle(String idToken) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final userData = await _firestore.collection('profiles').doc(userCredential.user!.uid).get();
      return UserModel.fromFirestore(userData);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
}