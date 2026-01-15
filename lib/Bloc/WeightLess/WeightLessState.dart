import 'package:deep_manage_app/Model/WeightLess/WeightLessModel.dart';

abstract class WeightLessState {}

class WeightLessInitial extends WeightLessState {}

class WeightLessLoading extends WeightLessState {}

class WeightLessLoaded extends WeightLessState {
  final List<WeightLessModel> weightLesses;
  WeightLessLoaded(this.weightLesses);
}

class WeightLessLoadedSingle extends WeightLessState {
  final WeightLessModel weightLess;
  WeightLessLoadedSingle(this.weightLess);
}

class WeightLessCreated extends WeightLessState {}

class WeightLessDeleted extends WeightLessState {}

class WeightLessUpdated extends WeightLessState {}

class WeightLessRestored extends WeightLessState {}

class WeightLessError extends WeightLessState {
  final String message;
  WeightLessError(this.message);
}