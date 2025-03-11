import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<User?> getCurrentUser();
  Future<User?> signIn(String email, String password);
  Future<User?> signInUpWithGoogle();
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("[FAuth-DS] getCurrentUser null");
      }
      return user;
    } catch (e) {
      throw Exception("[FAuth-DS] getCurrentUser error: ${e.toString()}");
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("[FAuth-DS] signIn null");
      }
      return user;
    } catch (e) {
      throw Exception("[FAuth-DS] signIn error: ${e.toString()}");
    }
  }

  @override
  Future<User?> signInUpWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if(googleAccount == null){
        throw Exception("[FAuth-DS] signInWithGoogle null");
      }

      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) {
        throw Exception("[FAuth-DS] signInWithGoogle null");
      }
      return user;
    } catch (e) {
      throw Exception("[FAuth-DS] signInWithGoogle error: ${e.toString()}");
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("[FAuth-DS] signUp error: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("[FAuth-DS] signOut error: ${e.toString()}");
    }
  }
}