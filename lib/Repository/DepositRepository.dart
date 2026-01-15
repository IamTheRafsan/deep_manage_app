import 'package:deep_manage_app/Model/Deposit/DepositModel.dart';
import '../ApiService/DepositApi/DepositApi.dart';

class DepositRepository {
  final DepositApi depositApi;

  DepositRepository({required this.depositApi});

  Future<void> addDeposit(Map<String, dynamic> data) async {
    await depositApi.addDeposit(data);
  }

  Future<List<DepositModel>> getDeposit() {
    return depositApi.getDeposit();
  }

  Future<DepositModel> getDepositById(String id) {
    return depositApi.getDepositById(id);
  }

  Future<void> deleteDeposit(String id) {
    return depositApi.deleteDeposit(id);
  }

  Future<void> updateDeposit(String id, Map<String, dynamic> data) {
    return depositApi.updateDeposit(id, data);
  }
}