import 'package:equatable/equatable.dart';

abstract class RouterEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class RouterLoginEvent extends RouterEvent{}

class RouterLogoutEvent extends RouterEvent{}