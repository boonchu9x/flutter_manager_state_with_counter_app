import 'package:meta/meta.dart';

//chỉ có thể thay đổi thông qua event block
@immutable
class RegisterState {
  final bool isValidEmail;
  final bool isValidPass;
  final bool isSubmit;
  final bool isSuccess;
  final bool isFailure;

  //get email and password
  bool get isValidEmailAndPass => isValidEmail && isValidPass;

  RegisterState({
    @required this.isValidEmail,
    @required this.isValidPass,
    @required this.isSubmit,
    @required this.isSuccess,
    @required this.isFailure,
  });

  //mỗi state là 1 object hoặc có thể tạo static object
  //init
  factory RegisterState.intial() {
    return RegisterState(
      isValidEmail: true,
      isValidPass: true,
      isSubmit: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  //loading
  factory RegisterState.loading() {
    return RegisterState(
      isValidEmail: true,
      isValidPass: true,
      isSubmit: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isValidEmail: true,
      isValidPass: true,
      isSubmit: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  //failure state
  factory RegisterState.failure() {
    return RegisterState(
      isValidEmail: true,
      isValidPass: true,
      isSubmit: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  //clone object state
  //Nhân bản đối tượng (clone object) CommentStateSuccess
  RegisterState cloneWith({
    bool isValidEmail,
    bool isValidPass,
    bool isSubmit,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegisterState(
      isValidEmail: isValidEmail ?? this.isValidEmail,
      isValidPass: isValidPass ?? this.isValidPass,
      isSubmit: isSubmit ?? this.isSubmit,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  //clone and update object
  RegisterState cloneAndUpdate({
    bool isValidEmail,
    bool isValidPass,
  }) {
    return cloneWith(
      isValidEmail: isValidEmail,
      isValidPass: isValidPass,
    );
  }
}
