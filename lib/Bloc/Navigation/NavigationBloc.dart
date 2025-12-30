import 'package:bloc/bloc.dart';

import 'NavigationEvent.dart';
import 'NavigationState.dart';


// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationTabChanged>((event, emit) {
      emit(NavigationChanged(event.tabIndex));
    });
  }
}