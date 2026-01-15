import 'package:deep_manage_app/Model/WeightLess/WeightLessModel.dart';
import '../ApiService/WeightLessApi/WeightLessApi.dart';

class WeightLessRepository {
  final WeightLessApi weightLessApi;

  WeightLessRepository({required this.weightLessApi});

  // Create new weight less
  Future<void> addWeightLess(WeightLessModel weightLess) async {
    final data = weightLess.toApiJson();
    await weightLessApi.addWeightLess(data);
  }

  // View all weight less (only non-deleted)
  Future<List<WeightLessModel>> getWeightLesses() {
    return weightLessApi.getWeightLesses();
  }

  // View all weight less including deleted (for admin)
  Future<List<WeightLessModel>> getAllWeightLesses() {
    return weightLessApi.getWeightLesses();
  }

  // View weight less by id
  Future<WeightLessModel> getWeightLessById(String id) {
    return weightLessApi.getWeightLessById(id);
  }

  // Delete weight less (soft delete handled by backend)
  Future<void> deleteWeightLess(String id) async {
    await weightLessApi.deleteWeightLess(id);
  }

  // Update weight less
  Future<void> updateWeightLess(String id, WeightLessModel weightLess) async {
    final data = weightLess.toApiJson();
    return weightLessApi.updateWeightLess(id, data);
  }

  // Restore soft deleted weight less
  Future<void> restoreWeightLess(String id) async {
    final data = {
      "deleted": false,
      "deletedById": null,
      "deletedByName": null,
      "deletedDate": null,
      "deletedTime": null,
    };

    return weightLessApi.updateWeightLess(id, data);
  }
}