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
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/login_firebase/state/login_state.dart';
import 'package:flutter_manage_state_basic/page/login_firebase_screen/sign_in_page.dart';
import 'package:flutter_manage_state_basic/util/shape_custom.dart';
import 'package:flutter_svg/svg.dart';

import 'firebase_home_page.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  LoginBloc _loginBloc;
  bool _togglePassVisible = false;

  UserRepository get _userRepository => widget._userRepository;

  //lấy ra các giá trị thay đổi của controller
  @override
  void initState() {
    super.initState();
    //show/hide pass
    _togglePassVisible = false;
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    //lấy ra text của email
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    //lấy ra text của password
    _passController.addListener(() {
      _loginBloc.add(LoginEventPassChanged(pass: _passController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPass && isPopulated && !loginState.isSubmit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //hide status bar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
        if (loginState.isFailure) {
          print('Login failed');
          Container(
            child: Text('Login Failed'),
          );
        } else if (loginState.isSubmit) {
          print('Login success');

          return Container(
            child: Text('Login Success'),
          );
        } else if (loginState.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationEventLoggedIn());
          return Container(
            child: Text('Login Event'),
          );
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
                            height: size.height / 2.4,
                            color: Colors.blue[400],
                          ),
                        ),

                        //HEADER ICON AND TEXT FIREBASE
                        Positioned(
                          bottom: 70.0,
                          left: 0.0,
                          right: 0.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                width: 110.0,
                                height: 110.0,
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
                                'Firebase',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //ICON LOGOUT
                        Positioned(
                          right: 20.0,
                          top: 20.0,
                          left: 0.0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () =>
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(AuthenticationEventLoggedOut()),
                              child: Container(
                                  alignment: Alignment.topRight,
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Colors.white,
                                  ))),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //LIST FORM
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
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
                              //GOOGLE
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000.0),
                                ),
                                color: Colors.white,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000.0),
                                  highlightColor: Colors.white.withOpacity(0.4),
                                  focusColor: Colors.white.withOpacity(0.9),
                                  onTap: () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(LoginEventWithGooglePassed());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                      vertical: 12.0,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 22.0,
                                              height: 22.0,
                                              child: SvgPicture.asset(
                                                  'assets/icons/ic_google.svg')),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Text(
                                              'Sign in with Google',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //LINE
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 26.0,
                                  horizontal: 12.0,
                                ),
                                child: Divider(
                                  color: Colors.black26,
                                  height: 1.0,
                                ),
                              ),

                              //EDITEXT WITH EMAIL
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000.0),
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
                                        hintText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
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

                              //EDITTEXT WITH PASSWORD
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000.0),
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
                                            highlightColor: Colors.transparent,
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
                                        hintText: 'Password',
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
                                highlightColor: Colors.white.withOpacity(0.4),
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
                                      'Log In'.toUpperCase(),
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

                    //SIGN IN
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(1000.0),
                              highlightColor: Colors.white.withOpacity(0.4),
                              focusColor: Colors.white.withOpacity(0.9),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<RegisterBloc>(
                                            create: (context) => RegisterBloc(
                                                userRepository:
                                                    _userRepository),
                                            child: SignInScreen(
                                                userRepository:
                                                    _userRepository),
                                          ))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue[400],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
      }),
    );
  }

  void _onLoginEmailAndPass() {
    _loginBloc.add(LoginEventWithEmailAndPassSubmit(
        email: _emailController.text, pass: _passController.text));
  }
}
