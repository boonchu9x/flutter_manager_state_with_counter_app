import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/counter_app/events/counter_events.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  int get initialState => 0;
  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    // TODO: implement mapEventToState
    print(state);
    switch (event) {
      case CounterEvent.increment:
        var newState = state + 1;
        yield newState;
        break;
      case CounterEvent.decrement:
        var newState = state - 1;
        yield newState;
        break;
    }
  }
}
