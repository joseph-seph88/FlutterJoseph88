import 'package:equatable/equatable.dart';

abstract class RouterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RouterInitialState extends RouterState {}

class RouterAuthenticatedState extends RouterState {}

class RouterUnAuthenticatedState extends RouterState {}
