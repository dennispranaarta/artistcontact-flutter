part of 'counter_cubit.dart';

@immutable
class CounterState {
  final int counter;
  const CounterState({required this.counter});
}

final class CounterInitialState extends CounterState {
  const CounterInitialState() : super(counter: 0);
}