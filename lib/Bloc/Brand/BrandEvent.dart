// lib/Bloc/Brand/BrandEvent.dart
abstract class BrandEvent {}

class LoadBrand extends BrandEvent {}

class LoadBrandById extends BrandEvent {
  final String brandId;
  LoadBrandById(this.brandId);
}

class CreateBrand extends BrandEvent {
  final Map<String, dynamic> data;
  CreateBrand(this.data);
}

class DeleteBrand extends BrandEvent {
  final String brandId;
  DeleteBrand(this.brandId);
}

class UpdateBrand extends BrandEvent {
  final String brandId;
  final Map<String, dynamic> updatedData;
  UpdateBrand(this.brandId, this.updatedData);
}