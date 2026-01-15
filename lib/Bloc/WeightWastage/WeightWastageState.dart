import 'package:deep_manage_app/Model/WeightWastage/WeightWastageModel.dart';

abstract class WeightWastageState {}

class WeightWastageInitial extends WeightWastageState {}

class WeightWastageLoading extends WeightWastageState {}

class WeightWastageLoaded extends WeightWastageState {
  final List<WeightWastageModel> weightWastages;
  WeightWastageLoaded(this.weightWastages);
}

class WeightWastageLoadedSingle extends WeightWastageState {
  final WeightWastageModel weightWastage;
  WeightWastageLoadedSingle(this.weightWastage);
}

class WeightWastageCreated extends WeightWastageState {}

class WeightWastageDeleted extends WeightWastageState {}

class WeightWastageUpdated extends WeightWastageState {}

class WeightWastageRestored extends WeightWastageState {}

class WeightWastageError extends WeightWastageState {
  final String message;
  WeightWastageError(this.message);
}