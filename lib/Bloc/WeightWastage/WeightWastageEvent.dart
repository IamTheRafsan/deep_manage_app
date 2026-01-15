import 'package:deep_manage_app/Model/WeightWastage/WeightWastageModel.dart';

abstract class WeightWastageEvent {}

class LoadWeightWastages extends WeightWastageEvent {
  final bool showDeleted;
  LoadWeightWastages({this.showDeleted = false});
}

class LoadWeightWastageById extends WeightWastageEvent {
  final String weightWastageId;
  LoadWeightWastageById(this.weightWastageId);
}

class CreateWeightWastage extends WeightWastageEvent {
  final WeightWastageModel weightWastage;
  CreateWeightWastage(this.weightWastage);
}

class DeleteWeightWastage extends WeightWastageEvent {
  final String weightWastageId;
  DeleteWeightWastage(this.weightWastageId);
}

class UpdateWeightWastage extends WeightWastageEvent {
  final String weightWastageId;
  final WeightWastageModel weightWastage;
  UpdateWeightWastage(this.weightWastageId, this.weightWastage);
}

class RestoreWeightWastage extends WeightWastageEvent {
  final String weightWastageId;
  RestoreWeightWastage(this.weightWastageId);
}