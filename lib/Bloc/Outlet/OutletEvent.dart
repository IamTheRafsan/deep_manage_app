// lib/Bloc/Outlet/OutletEvent.dart
abstract class OutletEvent {}

class LoadOutlet extends OutletEvent {
  final bool showDeleted;
  LoadOutlet({this.showDeleted = false});
}

class LoadOutletById extends OutletEvent {
  final String outletId;
  LoadOutletById(this.outletId);
}

class CreateOutlet extends OutletEvent {
  final Map<String, dynamic> data;
  CreateOutlet(this.data);
}

class DeleteOutlet extends OutletEvent {
  final String outletId;
  DeleteOutlet(this.outletId);
}

class UpdateOutlet extends OutletEvent {
  final String outletId;
  final Map<String, dynamic> updatedData;
  UpdateOutlet(this.outletId, this.updatedData);
}