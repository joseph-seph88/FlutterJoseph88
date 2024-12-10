import 'package:class_10_firebase/todo_app/repositories/login_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final emailProvider = Provider<TextEditingController>((ref)=>TextEditingController());
final passwordProvider = Provider<TextEditingController>((ref)=>TextEditingController());
final nicknameProvider = Provider<TextEditingController>((ref)=>TextEditingController());


final loginFirebaseProvider = Provider<LoginFirebaseRepository>((ref) {
  return LoginFirebaseRepository();
});

final loginStateProvider = StreamProvider<User?>((ref) {
  final firebaseAuthService = ref.watch(loginFirebaseProvider);
  return firebaseAuthService.authStateChanges;
});
