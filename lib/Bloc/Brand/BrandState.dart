import 'package:deep_manage_app/Model/Brand/BrandModel.dart';

abstract class BrandState {}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<BrandModel> brands;
  BrandLoaded(this.brands);
}

class BrandLoadedSingle extends BrandState {
  final BrandModel brand;
  BrandLoadedSingle(this.brand);
}

class BrandCreated extends BrandState {}

class BrandDeleted extends BrandState {}

class BrandUpdated extends BrandState {}

class BrandError extends BrandState {
  final String message;
  BrandError(this.message);
}