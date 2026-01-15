import 'package:deep_manage_app/Bloc/WeightWastage/WeightWastageEvent.dart';
import 'package:deep_manage_app/Bloc/WeightWastage/WeightWastageState.dart';
import 'package:deep_manage_app/Repository/WeightWastageRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightWastageBloc extends Bloc<WeightWastageEvent, WeightWastageState> {
  final WeightWastageRepository weightWastageRepository;

  WeightWastageBloc({required this.weightWastageRepository}) : super(WeightWastageInitial()) {
    on<LoadWeightWastages>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        final weightWastages = await weightWastageRepository.getWeightWastages();
        // Filter deleted weight wastages if needed
        final filteredWeightWastages = event.showDeleted
            ? weightWastages
            : weightWastages.where((ww) => !ww.deleted).toList();
        emit(WeightWastageLoaded(filteredWeightWastages));
      } catch (e) {
        emit(WeightWastageError(e.toString()));
      }
    });

    on<LoadWeightWastageById>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        final weightWastage = await weightWastageRepository.getWeightWastageById(event.weightWastageId);
        emit(WeightWastageLoadedSingle(weightWastage));
      } catch (e) {
        emit(WeightWastageError(e.toString()));
      }
    });

    on<CreateWeightWastage>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        await weightWastageRepository.addWeightWastage(event.weightWastage);
        emit(WeightWastageCreated());
      } catch (e) {
        // Check if error is about duplicate entry
        if (e.toString().contains("WeightWastage entry already exists") ||
            e.toString().contains("already exists")) {
          emit(WeightWastageError("Weight wastage record already exists for this purchase. Please update the existing record instead."));
        } else {
          emit(WeightWastageError(e.toString()));
        }
      }
    });

    on<DeleteWeightWastage>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        await weightWastageRepository.deleteWeightWastage(event.weightWastageId);
        emit(WeightWastageDeleted());
      } catch (e) {
        emit(WeightWastageError(e.toString()));
      }
    });

    on<UpdateWeightWastage>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        await weightWastageRepository.updateWeightWastage(event.weightWastageId, event.weightWastage);
        emit(WeightWastageUpdated());
      } catch (e) {
        emit(WeightWastageError(e.toString()));
      }
    });

    on<RestoreWeightWastage>((event, emit) async {
      emit(WeightWastageLoading());
      try {
        await weightWastageRepository.restoreWeightWastage(event.weightWastageId);
        emit(WeightWastageRestored());
      } catch (e) {
        emit(WeightWastageError(e.toString()));
      }
    });
  }
}