import 'package:deep_manage_app/Model/DepositCategory/DepositCategoryModel.dart';

abstract class DepositCategoryState {}

class DepositCategoryInitial extends DepositCategoryState {}

class DepositCategoryLoading extends DepositCategoryState {}

class DepositCategoryLoaded extends DepositCategoryState {
  final List<DepositCategoryModel> depositCategories;
  DepositCategoryLoaded(this.depositCategories);
}

class DepositCategoryLoadedSingle extends DepositCategoryState {
  final DepositCategoryModel depositCategory;
  DepositCategoryLoadedSingle(this.depositCategory);
}

class DepositCategoryCreated extends DepositCategoryState {}

class DepositCategoryDeleted extends DepositCategoryState {}

class DepositCategoryUpdated extends DepositCategoryState {}

class DepositCategoryError extends DepositCategoryState {
  final String message;
  DepositCategoryError(this.message);
}