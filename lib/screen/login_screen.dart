import 'package:eigital_exam/cubit/login_cubit.dart';
import 'package:eigital_exam/cubit/login_state.dart';
import 'package:eigital_exam/cubit/main_screen_cubit.dart';
import 'package:eigital_exam/util/authentication.dart';
import 'package:eigital_exam/widgets/login_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              _buildDetails(),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build details section
  ///
  Expanded _buildDetails() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/firebase_logo.png',
              height: 160,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'FlutterFire',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 40,
            ),
          ),
          const Text(
            'Authentication',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  /// Build button sections
  ///
  FutureBuilder<FirebaseApp> _buildButtons(BuildContext context) {
    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return BlocConsumer<LoginCubit, LoginState>(
            listener: (BuildContext context, LoginState state) {
              if (state is LoginSuccess) {
                print("this is the user:${state.user?.displayName}");
                if(state.user!=null){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<MainScreenCubit>(
                        create: (_) => MainScreenCubit(),
                        child: MainScreen(state.user),
                      ),
                    ),
                  );
                }
              }
            },
            builder: (BuildContext context, LoginState state) {
              final LoginCubit cubit = BlocProvider.of(context);
              if (state is LoginInitial || state is LoginSuccess) {
                return Column(children: <Widget>[
                  LoginButton(
                    onPressed: ()=>cubit.loginWithGoogle(context),
                    urlImage: 'assets/google_logo.png',
                    label: 'Sign in with Google',
                  ),
                  LoginButton(
                    onPressed: ()=>cubit.loginWithFacebook(context),
                    urlImage: 'assets/facebook.png',
                    label: 'Sign in with Facebook',
                  ),
                ]);
              }
              return _buildProgressIndicator();
            },
          );
        }
        return _buildProgressIndicator();
      },
    );
  }

  /// Build progress indicator
  ///
  Widget _buildProgressIndicator(){
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.orange,
      ),
    );
  }
}
