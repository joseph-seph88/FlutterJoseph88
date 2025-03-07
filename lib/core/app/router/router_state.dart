import 'package:equatable/equatable.dart';

abstract class RouterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RouterInitial extends RouterState {}

class RouterAuthenticated extends RouterState {}

class RouterUnAuthenticated extends RouterState {}
