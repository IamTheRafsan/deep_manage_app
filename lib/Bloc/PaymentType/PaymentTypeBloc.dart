import 'package:deep_manage_app/Bloc/PaymentType/PaymentTypeEvent.dart';
import 'package:deep_manage_app/Bloc/PaymentType/PaymentTypeState.dart';
import 'package:deep_manage_app/Repository/PaymentTypeRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentTypeBloc extends Bloc<PaymentTypeEvent, PaymentTypeState> {
  final PaymentTypeRepository paymentTypeRepository;

  PaymentTypeBloc({required this.paymentTypeRepository}) : super(PaymentTypeInitial()) {
    on<LoadPaymentTypes>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        final paymentTypes = await paymentTypeRepository.getPaymentTypes();
        // Filter deleted payment types if needed
        final filteredPaymentTypes = event.showDeleted
            ? paymentTypes
            : paymentTypes.where((pt) => !pt.deleted).toList();
        emit(PaymentTypeLoaded(filteredPaymentTypes));
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });

    on<LoadPaymentTypeById>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        final paymentType = await paymentTypeRepository.getPaymentTypeById(event.paymentTypeId);
        emit(PaymentTypeLoadedSingle(paymentType));
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });

    on<CreatePaymentType>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        await paymentTypeRepository.addPaymentType(
          name: event.data['name'],
          createdById: event.data['created_by_id'],
        );
        emit(PaymentTypeCreated());
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });

    on<DeletePaymentType>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        await paymentTypeRepository.deletePaymentType(
          id: event.paymentTypeId
        );
        emit(PaymentTypeDeleted());
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });

    on<UpdatePaymentType>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        await paymentTypeRepository.updatePaymentType(
          id: event.paymentTypeId,
          data: event.updatedData,
          updatedById: event.updatedData['updated_by_id'],
        );
        emit(PaymentTypeUpdated());
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });

    on<RestorePaymentType>((event, emit) async {
      emit(PaymentTypeLoading());
      try {
        await paymentTypeRepository.restorePaymentType(event.paymentTypeId);
        emit(PaymentTypeRestored());
      } catch (e) {
        emit(PaymentTypeError(e.toString()));
      }
    });
  }
}