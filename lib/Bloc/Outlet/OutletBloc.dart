// lib/Bloc/Outlet/OutletBloc.dart
import 'package:deep_manage_app/Bloc/Outlet/OutletEvent.dart';
import 'package:deep_manage_app/Bloc/Outlet/OutletState.dart';
import 'package:deep_manage_app/Repository/OutletRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutletBloc extends Bloc<OutletEvent, OutletState> {
  final OutletRepository outletRepository;

  OutletBloc({required this.outletRepository}) : super(OutletInitial()) {
    on<LoadOutlet>((event, emit) async {
      emit(OutletLoading());
      try {
        final outlets = await outletRepository.getOutlet();
        // Filter deleted outlets if needed
        final filteredOutlets = event.showDeleted
            ? outlets
            : outlets.where((o) => !o.deleted).toList();
        emit(OutletLoaded(filteredOutlets));
      } catch (e) {
        emit(OutletError(e.toString()));
      }
    });

    on<LoadOutletById>((event, emit) async {
      emit(OutletLoading());
      try {
        final outlet = await outletRepository.getOutletById(event.outletId);
        emit(OutletLoadedSingle(outlet));
      } catch (e) {
        emit(OutletError(e.toString()));
      }
    });

    on<CreateOutlet>((event, emit) async {
      emit(OutletLoading());
      try {
        await outletRepository.addOutlet(event.data);
        emit(OutletCreated());
      } catch (e) {
        emit(OutletError(e.toString()));
      }
    });

    on<DeleteOutlet>((event, emit) async {
      emit(OutletLoading());
      try {
        await outletRepository.deleteOutlet(event.outletId);
        emit(OutletDeleted());
      } catch (e) {
        emit(OutletError(e.toString()));
      }
    });

    on<UpdateOutlet>((event, emit) async {
      emit(OutletLoading());
      try {
        await outletRepository.updateOutlet(
          event.outletId,
          event.updatedData,
        );
        emit(OutletUpdated());
      } catch (e) {
        emit(OutletError(e.toString()));
      }
    });
  }
}