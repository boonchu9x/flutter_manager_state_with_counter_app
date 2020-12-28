import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/authentication_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/login_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/register_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/authentication_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/login_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/register_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/login_state.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/register_state.dart';
import 'package:flutter_manage_state_basic/page/login_firebase_screen/firebase_home_page.dart';
import 'package:flutter_manage_state_basic/util/shape_custom.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatefulWidget {
  final UserRepository _userRepository;

  SignInScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  RegisterBloc _registerBloc;
  bool _togglePassVisible = false;

  UserRepository get _userRepository => widget._userRepository;

  //lấy ra các giá trị thay đổi của controller
  @override
  void initState() {
    super.initState();
    //show/hide pass
    _togglePassVisible = false;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    //lấy ra text của email
    _emailController.addListener(() {
      _registerBloc
          .add(RegisterEventEmailChanged(email: _emailController.text));
    });
    //lấy ra text của password
    _passController.addListener(() {
      _registerBloc.add(RegisterEventPassChanged(pass: _passController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState registerState) =>
      registerState.isValidEmailAndPass && isPopulated;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //hide status bar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            if (registerState.isFailure) {
              print('Login failed');
              return Container(width: 0.0, height: 0.0,);
            } else if (registerState.isSubmit) {
              print('Login success');
              /*Navigator.push(context, MaterialPageRoute(builder: (context) {
              FirebaseHomeScreen();
              Navigator.of(context).pop();
              }
              ));*/
              return Container(width: 0.0, height: 0.0,);
            } else if (registerState.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedIn());
              return Container(width: 0.0, height: 0.0,);
            } else
              // ignore: missing_return
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            ShapeCustom(
                              clipType: ClipType.arc,
                              child: Container(
                                width: double.infinity,
                                height: size.height / 2.3,
                                color: Colors.blue[400],
                              ),
                            ),
                            Positioned(
                              bottom: 70.0,
                              left: 0.0,
                              right: 0.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/icon_firebase.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //FORM
                              ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          1000.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(Icons.person),
                                            hintText: 'Enter your email'),
                                        keyboardType: TextInputType
                                            .emailAddress,
                                        autovalidate: true,
                                        autocorrect: false,
                                        /* validator: (_) {
                                    return loginState.isValidEmail
                                        ? null
                                        : 'Invalid email format';
                                  },*/
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          1000.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          controller: _passController,
                                          textAlignVertical:
                                          TextAlignVertical.center,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.lock,
                                              size: 22,
                                            ),
                                            // ignore: missing_return
                                            suffixIcon: GestureDetector(
                                              //long press show/hide icon password
                                              onLongPress: () {
                                                setState(() {
                                                  _togglePassVisible = true;
                                                });
                                              },
                                              onLongPressUp: () {
                                                setState(() {
                                                  _togglePassVisible = false;
                                                });
                                              },
                                              child: IconButton(
                                                focusColor: Colors.transparent,
                                                highlightColor: Colors
                                                    .transparent,
                                                hoverColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                icon: Icon(_togglePassVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _togglePassVisible =
                                                    !_togglePassVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            hintText: 'Enter your password',
                                          ),
                                          keyboardType:
                                          TextInputType.visiblePassword,
                                          autovalidate: true,
                                          autocorrect: false,
                                          obscureText: !_togglePassVisible,
                                          enableInteractiveSelection: false,
                                          /*validator: (_) {
                                      return loginState.isValidPass
                                          ? null
                                          : 'Invalid password format';
                                    },*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 50.0),
                              //LOGIN/ SIGN IN
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000.0),
                                  ),
                                  color: Colors.blue[400],
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(1000.0),
                                    highlightColor: Colors.white.withOpacity(
                                        0.4),
                                    focusColor: Colors.white.withOpacity(0.9),
                                    onTap: () => _onLoginEmailAndPass(),
                                    child: Container(
                                      height: 48.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign In'.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              //BACK
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000.0),
                                  ),
                                  color: Colors.blue[400],
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(1000.0),
                                    highlightColor: Colors.white.withOpacity(
                                        0.4),
                                    focusColor: Colors.white.withOpacity(0.9),
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      height: 48.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Back'.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ],
                ),
              );
          }),
    );
  }

  void _onLoginEmailAndPass() {
    _registerBloc.add(RegisterEventWithEmailAndPassSubmit(
        email: _emailController.text, pass: _passController.text));
  }


}
