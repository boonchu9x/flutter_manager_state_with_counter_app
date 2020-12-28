import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/login_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/login_state.dart';
import 'package:flutter_manage_state_basic/login_firebase/validator/validator.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.intial());

  //delay giữa 2 lần nhấn submit, không để nhấn login liên tục
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents( Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFunction,) {
    final debounceStream = loginEvents.where((loginEvent) {
      //chỉ áp dụng cho login change email/password
      return (loginEvent is LoginEventEmailChanged || loginEvent is LoginEventPassChanged);
    }).debounceTime(Duration(milliseconds: 300));//minimum 300ms for each event

    //không áp dụng delay giữa 2 khoảng trống liên tiếp
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged || loginEvent is! LoginEventPassChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    if (loginEvent is LoginEventEmailChanged) {
      //cập nhật emai, pass
      yield loginState.cloneAndUpdate(
          isValidEmail: Validator.validEmail(loginEvent.email));
    } else if (loginEvent is LoginEventPassChanged) {
      yield loginState.cloneAndUpdate(
          isValidPass: Validator.validPass(loginEvent.pass));
    } else if (loginEvent is LoginEventWithGooglePassed) {
      try {
        await _userRepository.signInWithGoogle();
        //login with google success
        yield LoginState.success();
      } catch (_) {
        //login with google failure
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginEventWithEmailAndPassSubmit) {
      try {
        await _userRepository.signInWithMailAndPass(
            loginEvent.email, loginEvent.pass);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
