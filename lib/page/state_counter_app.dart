import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/components/appbar_general.dart';
import 'package:flutter_manage_state_basic/counter_app/bloc_counter/counter_bloc.dart';
import 'package:flutter_manage_state_basic/counter_app/events/counter_events.dart';

class CounterAppScreen extends StatefulWidget {
  @override
  _CounterAppScreenState createState() => _CounterAppScreenState();
}

class _CounterAppScreenState extends State<CounterAppScreen> {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = context.bloc<CounterBloc>();
    return Scaffold(
      appBar: BuildAppBar(
        titleApp: 'Counter App',
        iconLeft: Icons.arrow_back_ios,
        isShowIconLeft: true,
        onTapLeft: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<CounterBloc, int>(builder: (context, counter) {
        //counter is avariable
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      '${counter}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Decrement',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      counterBloc.add(CounterEvent.decrement);
                      print('Decrement');
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  FlatButton(
                    color: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Increment',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      counterBloc.add(CounterEvent.increment);
                      print('Increment');
                    },
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
