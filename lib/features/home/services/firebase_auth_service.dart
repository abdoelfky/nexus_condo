import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/features/auth/data/User.dart';

typedef UserAuthStatus = void Function({required bool loggedIn});

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(
      {required BuildContext context,
        required String email,
        required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // Step 1: Fetch user data from Firestore
        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        Map<String, dynamic> userData =
        userDataSnapshot.data() as Map<String, dynamic>;
        UserData user = UserData.fromMap(userData);
        user.id = userCredential.user!.uid;
        print(user.id);
        print(AppSettingsPreferences().isVerified.toString());
        AppSettingsPreferences().saveUser(user: user);
        return true;

      } else {
        // await signOut();
        // showSnackBar(
        //     context: context,
        //     message: 'Verity email to login into the app!',
        //     error: true);
        return false;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _controlException(context, e);
    } catch (e) {}
    return false;
  }

  bool loggedIn() => _auth.currentUser != null;

  StreamSubscription<User?> checkUserStatus(UserAuthStatus userAuthStatus) {
    return _auth.authStateChanges().listen((event) {
      userAuthStatus(loggedIn: event != null);
    });
  }

  void _controlException(
      BuildContext context, FirebaseAuthException exception) {
    // showSnackBar(
    //     context: context, message: exception.message ??
    //     'Error!', error: true);
    switch (exception.code) {
      case 'invalid-email':
        break;
      case 'user-disabled':
        break;
      case 'user-not-found':
        break;
      case 'wrong-password':
        break;
    }
  }

// Add authStateChanges to listen for authentication changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
