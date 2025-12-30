import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository/RoleRepository.dart';
import 'RoleEvent.dart';
import 'RoleState.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleRepository roleRepository;

  RoleBloc({required this.roleRepository}) : super(RoleInitial()) {
    on<LoadRoles>((event, emit) async {
      emit(RoleLoading());
      try {
        final roles = await roleRepository.getRole();
        emit(RoleLoaded(roles));
      } catch (e) {
        emit(RoleError(e.toString()));
      }
    });

    on<LoadRoleById>((event, emit) async {
      emit(RoleLoading());
      try {
        final role = await roleRepository.getRoleById(event.roleId);
        emit(RoleLoadedSingle(role));
      } catch (e) {
        emit(RoleError(e.toString()));
      }
    });

    on<DeleteRoleById>((event, emit) async {
      emit(RoleLoading());
      try {
        await roleRepository.deleteRole(event.roleId);
        emit(RoleDeleted());
      } catch (e) {
        emit(RoleError(e.toString()));
      }
    });

    on<UpdateRoleById>((event, emit) async {
      emit(RoleLoading());
      try {
        await roleRepository.updateRole(event.roleId, event.updatedData);
        emit(RoleUpdated());
      } catch (e) {
        emit(RoleError(e.toString()));
      }
    });
  }
}
