import 'package:deep_manage_app/Bloc/WeightLess/WeightLessEvent.dart';
import 'package:deep_manage_app/Bloc/WeightLess/WeightLessState.dart';
import 'package:deep_manage_app/Repository/WeightLessRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightLessBloc extends Bloc<WeightLessEvent, WeightLessState> {
  final WeightLessRepository weightLessRepository;

  WeightLessBloc({required this.weightLessRepository}) : super(WeightLessInitial()) {
    on<LoadWeightLesses>((event, emit) async {
      emit(WeightLessLoading());
      try {
        final weightLesses = await weightLessRepository.getWeightLesses();
        // Filter deleted weight lesses if needed
        final filteredWeightLesses = event.showDeleted
            ? weightLesses
            : weightLesses.where((wl) => !wl.deleted).toList();
        emit(WeightLessLoaded(filteredWeightLesses));
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });

    on<LoadWeightLessById>((event, emit) async {
      emit(WeightLessLoading());
      try {
        final weightLess = await weightLessRepository.getWeightLessById(event.weightLessId);
        emit(WeightLessLoadedSingle(weightLess));
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });

    on<CreateWeightLess>((event, emit) async {
      emit(WeightLessLoading());
      try {
        await weightLessRepository.addWeightLess(event.weightLess);
        emit(WeightLessCreated());
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });

    on<DeleteWeightLess>((event, emit) async {
      emit(WeightLessLoading());
      try {
        await weightLessRepository.deleteWeightLess(event.weightLessId);
        emit(WeightLessDeleted());
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });

    on<UpdateWeightLess>((event, emit) async {
      emit(WeightLessLoading());
      try {
        await weightLessRepository.updateWeightLess(event.weightLessId, event.weightLess);
        emit(WeightLessUpdated());
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });

    on<RestoreWeightLess>((event, emit) async {
      emit(WeightLessLoading());
      try {
        await weightLessRepository.restoreWeightLess(event.weightLessId);
        emit(WeightLessRestored());
      } catch (e) {
        emit(WeightLessError(e.toString()));
      }
    });
  }
}