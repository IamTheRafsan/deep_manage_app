import 'package:deep_manage_app/Model/WeightWastage/WeightWastageModel.dart';
import '../ApiService/WeightWastageApi/WeightWastageApi.dart';

class WeightWastageRepository {
  final WeightWastageApi weightWastageApi;

  WeightWastageRepository({required this.weightWastageApi});

  // Create new weight wastage
  Future<void> addWeightWastage(WeightWastageModel weightWastage) async {
    final data = weightWastage.toApiJson();
    await weightWastageApi.addWeightWastage(data);
  }

  // View all weight wastages (only non-deleted)
  Future<List<WeightWastageModel>> getWeightWastages() {
    return weightWastageApi.getWeightWastages();
  }

  // View all weight wastages including deleted (for admin)
  Future<List<WeightWastageModel>> getAllWeightWastages() {
    return weightWastageApi.getWeightWastages();
  }

  // View weight wastage by id
  Future<WeightWastageModel> getWeightWastageById(String id) {
    return weightWastageApi.getWeightWastageById(id);
  }

  // Delete weight wastage (soft delete handled by backend)
  Future<void> deleteWeightWastage(String id) async {
    await weightWastageApi.deleteWeightWastage(id);
  }

  // Update weight wastage
  Future<void> updateWeightWastage(String id, WeightWastageModel weightWastage) async {
    final data = weightWastage.toApiJson();
    return weightWastageApi.updateWeightWastage(id, data);
  }

  // Restore soft deleted weight wastage
  Future<void> restoreWeightWastage(String id) async {
    final data = {
      "deleted": false,
      "deletedById": null,
      "deletedByName": null,
      "deletedDate": null,
      "deletedTime": null,
    };

    return weightWastageApi.updateWeightWastage(id, data);
  }
}