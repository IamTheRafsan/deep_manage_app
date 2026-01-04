import 'package:deep_manage_app/ApiService/ExpenseApi/ExpenseApi.dart';
import 'package:deep_manage_app/ApiService/ExpenseCategoryApi/ExpenseCategoryApi.dart';
import 'package:deep_manage_app/ApiService/OutletApi/OutletApi.dart';
import 'package:deep_manage_app/ApiService/UserApi/UserApi.dart';
import 'package:deep_manage_app/ApiService/WarehouseApi/WarehouseApi.dart';
import 'package:deep_manage_app/Bloc/Expense/ExpenseBloc.dart';
import 'package:deep_manage_app/Bloc/ExpenseCategory/ExpenseCategoryBloc.dart';
import 'package:deep_manage_app/Bloc/Navigation/NavigationBloc.dart';
import 'package:deep_manage_app/Bloc/Outlet/OutletBloc.dart';
import 'package:deep_manage_app/Bloc/Role/RoleBloc.dart';
import 'package:deep_manage_app/Bloc/Warehouse/WarehouseBloc.dart';
import 'package:deep_manage_app/Component/NavigationBar/CustomBottomNavigationBar.dart';
import 'package:deep_manage_app/Repository/ExpenseCategoryRepository.dart';
import 'package:deep_manage_app/Repository/ExpenseRepository.dart';
import 'package:deep_manage_app/Repository/OutletRepository.dart';
import 'package:deep_manage_app/Repository/UserRepository.dart';
import 'package:deep_manage_app/Repository/WarehouseRepository.dart';
import 'package:deep_manage_app/Service/AppSetup.dart';
import 'package:deep_manage_app/View/User/ViewUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/AuthApi/AuthApi.dart';
import '../Bloc/Authentication/AuthBloc.dart';
import '../View/Authentication/LoginScreen.dart';
import '../View/HomeScreen.dart';
import '../Repository/AuthRepository.dart';
import 'ApiService/RoleApi/RoleApi.dart';
import 'Bloc/Authentication/AuthEvent.dart';
import 'Bloc/Authentication/AuthState.dart';
import 'Bloc/Role/RoleEvent.dart';
import 'Bloc/User/UserBlock.dart';
import 'Repository/RoleRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final dio = AppSetup.createDio();

    final authApi = AuthApi(dio);
    final roleApi = RoleApi(dio);
    final userApi = UserApi(dio);
    final warehouseApi = WarehouseApi(dio);
    final outletApi = OutletApi(dio);
    final expenseCategoryApi  = ExpenseCategoryApi(dio);
    final expenseApi = ExpenseApi(dio);

    final authRepository = AuthRepository(authApi);
    final roleRepository = RoleRepository(roleApi);
    final userRepository = UserRepository(userApi: userApi);
    final warehouseRepository = WarehouseRepository(warehouseApi: warehouseApi);
    final outletRepository = OutletRepository(outletApi: outletApi);
    final expenseCategoryRepository = ExpenseCategoryRepository(expenseCategoryApi: expenseCategoryApi);
    final expenseRepository = ExpenseRepository(expenseApi: expenseApi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          AuthBloc(authRepository: authRepository)
            ..add(CheckLoginStatusEvent()),
        ),

        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => RoleBloc(roleRepository: roleRepository),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => WarehouseBloc(warehouseRepository: warehouseRepository),
        ),
        BlocProvider(
          create: (context) => OutletBloc(outletRepository: outletRepository),
        ),
        BlocProvider(
          create: (context) => ExpenseCategoryBloc(expenseCategoryRepository: expenseCategoryRepository),
        ),
        BlocProvider(
          create: (context) => ExpenseBloc(expenseRepository: expenseRepository),
        ),
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
        title: 'Inventory Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading || state is AuthInitial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is AuthSuccess) {
                context.read<RoleBloc>().add(LoadRoles());
                return CustomBottomNavigationBar();
              }

              return LoginScreen();
            },
          ),
          routes: {
          '/login': (context) =>  LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}