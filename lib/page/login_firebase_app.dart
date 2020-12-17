import 'package:flutter/material.dart';
import 'package:flutter_manage_state_basic/components/appbar_general.dart';

class LoginFirebaseApp extends StatefulWidget {
  @override
  _LoginFirebaseAppState createState() => _LoginFirebaseAppState();
}

class _LoginFirebaseAppState extends State<LoginFirebaseApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        titleApp: 'Login Firebase App',
        iconLeft: Icons.arrow_back_ios,
        isShowIconLeft: true,
        onTapLeft: () => Navigator.of(context).pop(),
      ),
    );
  }
}
