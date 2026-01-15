import 'package:deep_manage_app/Model/PaymentType/PaymentTypeModel.dart';

abstract class PaymentTypeState {}

class PaymentTypeInitial extends PaymentTypeState {}

class PaymentTypeLoading extends PaymentTypeState {}

class PaymentTypeLoaded extends PaymentTypeState {
  final List<PaymentTypeModel> paymentTypes;
  PaymentTypeLoaded(this.paymentTypes);
}

class PaymentTypeLoadedSingle extends PaymentTypeState {
  final PaymentTypeModel paymentType;
  PaymentTypeLoadedSingle(this.paymentType);
}

class PaymentTypeCreated extends PaymentTypeState {}

class PaymentTypeDeleted extends PaymentTypeState {}

class PaymentTypeUpdated extends PaymentTypeState {}

class PaymentTypeRestored extends PaymentTypeState {}

class PaymentTypeError extends PaymentTypeState {
  final String message;
  PaymentTypeError(this.message);
}