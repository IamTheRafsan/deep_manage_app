import 'package:deep_manage_app/Bloc/Purchase/PurchaseEvent.dart';
import 'package:deep_manage_app/Bloc/Purchase/PurchaseState.dart';
import 'package:deep_manage_app/Repository/PurchaseRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;

  PurchaseBloc({required this.purchaseRepository}) : super(PurchaseInitial()) {

    on<LoadPurchases>((event, emit) async {
      emit(PurchaseLoading());
      try {
        final purchases = await purchaseRepository.getPurchases();
        // Filter deleted purchases if needed
        final filteredPurchases = event.showDeleted
            ? purchases
            : purchases.where((p) => !p.deleted).toList();
        emit(PurchaseLoaded(filteredPurchases));
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });

    on<LoadPurchaseById>((event, emit) async {
      emit(PurchaseLoading());
      try {
        final purchase = await purchaseRepository.getPurchaseById(event.purchaseId);
        emit(PurchaseLoadedSingle(purchase));
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });

    on<CreatePurchase>((event, emit) async {
      emit(PurchaseLoading());
      try {
        await purchaseRepository.addPurchase(event.purchase);
        emit(PurchaseCreated());
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });

    on<DeletePurchase>((event, emit) async {
      emit(PurchaseLoading());
      try {
        await purchaseRepository.deletePurchase(event.purchaseId);
        emit(PurchaseDeleted());
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });

    on<UpdatePurchase>((event, emit) async {
      emit(PurchaseLoading());
      try {
        await purchaseRepository.updatePurchase(event.purchaseId, event.purchase);
        emit(PurchaseUpdated());
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });

    on<RestorePurchase>((event, emit) async {
      emit(PurchaseLoading());
      try {
        await purchaseRepository.restorePurchase(event.purchaseId);
        emit(PurchaseRestored());
      } catch (e) {
        emit(PurchaseError(e.toString()));
      }
    });
  }
}