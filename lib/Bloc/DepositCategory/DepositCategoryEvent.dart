abstract class DepositCategoryEvent {}

class LoadDepositCategory extends DepositCategoryEvent {
  final bool showDeleted;
  LoadDepositCategory({this.showDeleted = false});
}

class LoadDepositCategoryById extends DepositCategoryEvent {
  final String depositCategoryId;
  LoadDepositCategoryById(this.depositCategoryId);
}

class CreateDepositCategory extends DepositCategoryEvent {
  final Map<String, dynamic> data;
  CreateDepositCategory(this.data);
}

class DeleteDepositCategory extends DepositCategoryEvent {
  final String depositCategoryId;
  DeleteDepositCategory(this.depositCategoryId);
}

class UpdateDepositCategory extends DepositCategoryEvent {
  final String depositCategoryId;
  final Map<String, dynamic> updatedData;
  UpdateDepositCategory(this.depositCategoryId, this.updatedData);
}