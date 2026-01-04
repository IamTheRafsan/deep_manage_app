// lib/Bloc/Outlet/OutletState.dart
import 'package:deep_manage_app/Model/Outlet/OutletModel.dart';

abstract class OutletState {}

class OutletInitial extends OutletState {}

class OutletLoading extends OutletState {}

class OutletLoaded extends OutletState {
  final List<OutletModel> outlets;
  OutletLoaded(this.outlets);
}

class OutletLoadedSingle extends OutletState {
  final OutletModel outlet;
  OutletLoadedSingle(this.outlet);
}

class OutletCreated extends OutletState {}

class OutletDeleted extends OutletState {}

class OutletUpdated extends OutletState {}

class OutletError extends OutletState {
  final String message;
  OutletError(this.message);
}