import 'package:bloc/bloc.dart';
import 'package:eigital_exam/cubit/login_state.dart';
import 'package:eigital_exam/util/authentication.dart';
import 'package:flutter/cupertino.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  /// Login with google api
  ///
  Future<void> loginWithGoogle(BuildContext context) async {
    emit(LoginLoading());
    emit(LoginSuccess(await Authentication.signInWithGoogle(context: context)));
  }

  /// Login with facebook api
  ///
  Future<void> loginWithFacebook(BuildContext context) async {
    emit(LoginLoading());
    emit(LoginSuccess(await Authentication.loginWithFacebook(context)));
  }
}
