abstract class PaymentTypeEvent {}

class LoadPaymentTypes extends PaymentTypeEvent {
  final bool showDeleted;
  LoadPaymentTypes({this.showDeleted = false});
}

class LoadPaymentTypeById extends PaymentTypeEvent {
  final String paymentTypeId;
  LoadPaymentTypeById(this.paymentTypeId);
}

class CreatePaymentType extends PaymentTypeEvent {
  final Map<String, dynamic> data;
  CreatePaymentType(this.data);
}

class DeletePaymentType extends PaymentTypeEvent {
  final String paymentTypeId;

  DeletePaymentType(this.paymentTypeId);
}

class UpdatePaymentType extends PaymentTypeEvent {
  final String paymentTypeId;
  final Map<String, dynamic> updatedData;
  UpdatePaymentType(this.paymentTypeId, this.updatedData);
}

class RestorePaymentType extends PaymentTypeEvent {
  final String paymentTypeId;
  RestorePaymentType(this.paymentTypeId);
}