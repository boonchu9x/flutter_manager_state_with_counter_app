import 'package:flutter/cupertino.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/register_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/register_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/login_state.dart';
import 'package:flutter_manage_state_basic/login_firebase/validator/validator.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.intial());

  //delay giữa 2 lần nhấn submit, không để nhấn login liên tục
  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> registerEvents, transitionFunction) {
    final debounceStream = registerEvents.where((registerEvent) {
      //chỉ áp dụng cho login change email/password
      return (registerEvent is RegisterEventEmailChanged ||
          registerEvent is RegisterEventPassChanged);
    }).debounceTime(Duration(milliseconds: 300)); //delay 300 milisecond

    //không áp dụng delay giữa 2 khoảng trống liên tiếp
    final nonDebounceStream = registerEvents.where((registerEvent) {
      return (registerEvent is! RegisterEventEmailChanged ||
          registerEvent is! RegisterEventPassChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith({debounceStream}), transitionFunction);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    final registerState = state;
    if (registerEvent is RegisterEventEmailChanged) {
      //cập nhật email, pass
      yield state.cloneAndUpdate(
          isValidEmail: Validator.validEmail(registerEvent.email));
    } else if (registerEvent is RegisterEventPassChanged) {
      yield state.cloneAndUpdate(
          isValidPass: Validator.validPass(registerEvent.pass));
    } else if (registerEvent is RegisterEventWithEmailAndPassSubmit) {
      //loading
      yield RegisterState.loading();
      try {
        await _userRepository.createUserRegister(
            registerEvent.email, registerEvent.pass);
        yield RegisterState.success();
      } catch (_) {
        yield RegisterState.failure();
      }
    }
  }
}
