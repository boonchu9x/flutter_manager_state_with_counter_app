//event login
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginEventEmailChanged extends LoginEvent {
  final String email;

  const LoginEventEmailChanged({this.email});

  @override
  // TODO: implement props
  List<Object> get props => [email];

  @override
  String toString() => 'Email changed: ${email}';
}

class LoginEventPassChanged extends LoginEvent {
  final String pass;

  const LoginEventPassChanged({this.pass});

  @override
  // TODO: implement props
  List<Object> get props => [pass];

  @override
  String toString() => 'Password changed: ${pass}';
}

class LoginEventWithGooglePassed extends LoginEvent {}

//khi bấm submit
class LoginEventWithEmailAndPassSubmit extends LoginEvent {
  final String email;
  final String pass;

  const LoginEventWithEmailAndPassSubmit({
    @required this.email,
    @required this.pass,
  });

  @override
  // TODO: implement props
  List<Object> get props => [email, pass];


  @override
  String toString() => 'Submit email = ${email}, password = ${pass}';
}
