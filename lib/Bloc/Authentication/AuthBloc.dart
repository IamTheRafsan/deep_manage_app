import 'package:deep_manage_app/Bloc/Authentication/AuthEvent.dart';
import 'package:deep_manage_app/Bloc/Authentication/AuthState.dart';
import 'package:deep_manage_app/Repository/AuthRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('Login started for: ${event.email}');

    try {
      final token = await authRepository.login(event.email, event.password);
      print('Login API successful, token received');

      final user = await authRepository.getUserData();
      print('getUserData result: ${user != null ? "User found" : "User is NULL"}');

      if (user == null) {
        print('getUserData returned null!');
        throw Exception('User data not found after login');
      }

      print('Emitting AuthSuccess for user: ${user.email}');
      emit(AuthSuccess(token: token, user: user));
    } catch (e) {
      print('Login error: $e');
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthLoggedOut());
  }

  Future<void> _onCheckLoginStatus(CheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final token = await authRepository.getToken();
    final user = await authRepository.getUserData();

    if (token == null || token.isEmpty || user == null) {
      emit(AuthLoggedOut());
      return;
    }

    final isValid = await authRepository.validateToken();

    if (isValid) {
      emit(AuthSuccess(token: token, user: user));
    } else {
      await authRepository.logout();
      emit(AuthLoggedOut());
    }
  }
}