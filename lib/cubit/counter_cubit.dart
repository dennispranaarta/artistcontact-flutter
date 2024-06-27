import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterInitialState());

  void increment() {
    emit(CounterState(counter: state.counter + 1));
  }

  void decrement() {
    emit(CounterState(counter: state.counter - 1));
  }
}