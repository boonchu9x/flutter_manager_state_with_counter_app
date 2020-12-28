//event login
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RegisterEventEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEventEmailChanged({this.email});

  @override
  // TODO: implement props
  List<Object> get props => [email];

  @override
  String toString() => 'Email changed: ${email}';
}

class RegisterEventPassChanged extends RegisterEvent {
  final String pass;
  const RegisterEventPassChanged({this.pass});

  @override
  // TODO: implement props
  List<Object> get props => [pass];

  @override
  String toString() => 'Password changed: ${pass}';
}


//khi bấm submit
class RegisterEventWithEmailAndPassSubmit extends RegisterEvent {
  final String email;
  final String pass;

  const RegisterEventWithEmailAndPassSubmit({
    @required this.email,
    @required this.pass,
  });

  @override
  // TODO: implement props
  List<Object> get props => [email, pass];

  @override
  String toString() => 'Submit email = ${email}, password = ${pass}';
}
