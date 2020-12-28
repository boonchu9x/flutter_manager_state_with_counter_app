import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/authentication_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  //constructor
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationStateInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent authenticationEvent) async* {
    //check
    if (authenticationEvent is AuthenticationEventStarted) {
      final isSignedIn = await _userRepository.isSignIn();
      //đã sign in thì trả về sucess
      if(isSignedIn){
        final firebaseUser = await _userRepository.getUser();
        yield AuthenticationStateSuccess(firebaseUser: firebaseUser);
      }else{
        //false thì trả về failure
        yield AuthenticationStateFailure();
      }

    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      yield AuthenticationStateSuccess(firebaseUser: await _userRepository.getUser());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationStateFailure();
    }
  }
}
