import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/components/appbar_general.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/authentication_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/login_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/authentication_state.dart';
import 'package:flutter_manage_state_basic/page/login_firebase_screen/firebase_home_page.dart';
import 'package:flutter_manage_state_basic/page/login_firebase_screen/splash_page.dart';
import 'login_firebase_screen/login_page.dart';

class LoginFirebaseApp extends StatefulWidget {
  final UserRepository _userRepository;

  LoginFirebaseApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFirebaseAppState createState() => _LoginFirebaseAppState();
}

class _LoginFirebaseAppState extends State<LoginFirebaseApp> {
  UserRepository get _userRepository => widget._userRepository;

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            //success: open page user app screen
            if (authenticationState is AuthenticationStateSuccess) {
              return FirebaseHomeScreen();
            }
            //failure: open login page
            else if (authenticationState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(userRepository: _userRepository),
                  child: LoginScreen(
                    userRepository: _userRepository,
                  ) //LoginPage,
              );
            }
            //else: open splash page
            else
              return SplashScreen();
          });


  }
}
