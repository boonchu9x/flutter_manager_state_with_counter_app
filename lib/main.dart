import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/counter_app/bloc_counter/counter_bloc.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/bloc_infinite/comment_bloc.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/bloc_infinite/event/comment_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/authentication_bloc.dart';
import 'package:flutter_manage_state_basic/login_firebase/bloc/simple_bloc_observer.dart';
import 'package:flutter_manage_state_basic/login_firebase/event/authentication_event.dart';
import 'package:flutter_manage_state_basic/login_firebase/model/user_repository.dart';
import 'package:flutter_manage_state_basic/page/infinite_loadmore_list_app.dart';
import 'package:flutter_manage_state_basic/page/login_firebase_app.dart';
import 'package:flutter_manage_state_basic/page/state_counter_app.dart';
import 'components/appbar_general.dart';

//must to set to user firebase core
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  //must to call to user firebase core
  await Firebase.initializeApp();
  //init object UserRepository\
  final UserRepository _userRepository = UserRepository();

  runApp(BlocProvider<CounterBloc>(
      //Counter Bloc
      create: (context) => CounterBloc(),
      child: BlocProvider<CommentBloc>(
        //Comment Bloc
        create: (context) {
          final commentBolc = CommentBloc();
          commentBolc.add(CommentFetchedEvent());
          return commentBolc;
        },
        child: BlocProvider(
          // Firebase Authentication Bloc
          /*create: (context) {
            final authenticationBloc =
                AuthenticationBloc(userRepository: _userRepository);
            authenticationBloc.add(AuthenticationEventStarted());
            return authenticationBloc;
          },*/
          create: (context) => AuthenticationBloc(userRepository: _userRepository)..add(AuthenticationEventStarted()) ,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: HomeScreen(userRepository: _userRepository,),
          ),
        ),
      )));
}

class HomeScreen extends StatefulWidget {


  final UserRepository _userRepository;

  HomeScreen({
    Key key, @required UserRepository userRepository}):
        assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  UserRepository get _userRepository => widget._userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        titleApp: 'Manage State',
        titleAlignment: Alignment.center,
        iconLeft: Icons.arrow_back_ios,
        isShowIconLeft: true,
        onTapLeft: () => _exit(),
        iconRight: Icons.account_circle,
        onTapRight: () => onClickRight(),
        isShowIconRight: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //COUNTER APP
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CounterAppScreen()));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'State with Counter App',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 50.0,
            ),

            //INFINITE & LOADMORE LIST APP
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InfiniteAppScreen()));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'State with Infinite & Loadmore List',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 50.0,
            ),

            //LOGIN FIREBASE APP
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginFirebaseApp(userRepository: _userRepository)));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'State with Login Firebase App',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//exit app
Function _exit() {
  SystemNavigator.pop();
}

//event click right
void onClickRight() {
  print('onTapRight');
}


