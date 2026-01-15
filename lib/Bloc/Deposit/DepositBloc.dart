import 'package:deep_manage_app/Bloc/Deposit/DepositEvent.dart';
import 'package:deep_manage_app/Bloc/Deposit/DepositState.dart';
import 'package:deep_manage_app/Repository/DepositRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final DepositRepository depositRepository;

  DepositBloc({required this.depositRepository}) : super(DepositInitial()) {
    on<LoadDeposit>((event, emit) async {
      emit(DepositLoading());
      try {
        final deposits = await depositRepository.getDeposit();
        // Filter deleted deposits if needed
        final filteredDeposits = event.showDeleted
            ? deposits
            : deposits.where((d) => !d.deleted).toList();
        emit(DepositLoaded(filteredDeposits));
      } catch (e) {
        emit(DepositError(e.toString()));
      }
    });

    on<LoadDepositById>((event, emit) async {
      emit(DepositLoading());
      try {
        final deposit = await depositRepository.getDepositById(event.depositId);
        emit(DepositLoadedSingle(deposit));
      } catch (e) {
        emit(DepositError(e.toString()));
      }
    });

    on<CreateDeposit>((event, emit) async {
      emit(DepositLoading());
      try {
        await depositRepository.addDeposit(event.data);
        emit(DepositCreated());
      } catch (e) {
        emit(DepositError(e.toString()));
      }
    });

    on<DeleteDeposit>((event, emit) async {
      emit(DepositLoading());
      try {
        await depositRepository.deleteDeposit(event.depositId);
        emit(DepositDeleted());
      } catch (e) {
        emit(DepositError(e.toString()));
      }
    });

    on<UpdateDeposit>((event, emit) async {
      emit(DepositLoading());
      try {
        await depositRepository.updateDeposit(
          event.depositId,
          event.updatedData,
        );
        emit(DepositUpdated());
      } catch (e) {
        emit(DepositError(e.toString()));
      }
    });
  }
}