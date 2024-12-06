import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final emailControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final passwordControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());


final authProvider = Provider<FirebaseAuth>((ref) {
    return FirebaseAuth.instance;
});

final currentUserProvider = Provider<User?>((ref) {
    return ref.watch(authProvider).currentUser;
});
