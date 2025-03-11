import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository{
  Future<User?> getCurrentUser();
  Future<bool> signIn(String email, String password);
  Future<bool> signInUpWithGoogle();
  Future<bool> signUp(String email, String password);
  Future<void> signOut();
}