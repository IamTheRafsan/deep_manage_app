import 'package:deep_manage_app/Model/WeightLess/WeightLessModel.dart';

abstract class WeightLessEvent {}

class LoadWeightLesses extends WeightLessEvent {
  final bool showDeleted;
  LoadWeightLesses({this.showDeleted = false});
}

class LoadWeightLessById extends WeightLessEvent {
  final String weightLessId;
  LoadWeightLessById(this.weightLessId);
}

class CreateWeightLess extends WeightLessEvent {
  final WeightLessModel weightLess;
  CreateWeightLess(this.weightLess);
}

class DeleteWeightLess extends WeightLessEvent {
  final String weightLessId;
  DeleteWeightLess(this.weightLessId);
}

class UpdateWeightLess extends WeightLessEvent {
  final String weightLessId;
  final WeightLessModel weightLess;
  UpdateWeightLess(this.weightLessId, this.weightLess);
}

class RestoreWeightLess extends WeightLessEvent {
  final String weightLessId;
  RestoreWeightLess(this.weightLessId);
}