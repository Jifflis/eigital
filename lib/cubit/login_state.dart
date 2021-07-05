import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoginError extends LoginState {
  LoginError(this.error);

  String error;
}

class LoginSuccess extends LoginState {
  LoginSuccess(this.user);

  User? user;
}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}