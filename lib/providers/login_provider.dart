import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final passwordControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());
