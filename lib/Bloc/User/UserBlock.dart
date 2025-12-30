import 'package:deep_manage_app/Bloc/User/UserEvent.dart';
import 'package:deep_manage_app/Bloc/User/UserState.dart';
import 'package:deep_manage_app/Repository/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState>{
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>((event,emit) async{
      emit(UserLoading());
      try{
        final users = await userRepository.getUser();
        emit(UserLoaded(users));
      }catch(e){
        emit(UserError(e.toString()));
      }
    });


    on<LoadUserById>((event, emit) async{
      emit(UserLoading());
      try{
        final user = await userRepository.getUserById(event.userId);
        emit(UserLoadedSingle(user));
      }catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<CreateUser>((event, emit) async{
      emit(UserLoading());
      try{
        await userRepository.userApi.addUser(event.data);
        emit(UserCreated());
      }catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<DeleteUser>((event, emit) async {
    emit(UserLoading());
    try {
      await userRepository.deleteUser(event.userId);
      emit(UserDeleted());
    } catch (e) {
      emit(UserError(e.toString()));
    }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateUser(
          event.userId,
          event.updatedData,
        );
        emit(UserUpdated());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
}
}