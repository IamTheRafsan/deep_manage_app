import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/PaymentType/PaymentTypeBloc.dart';
import '../../Bloc/PaymentType/PaymentTypeEvent.dart';
import '../../Bloc/PaymentType/PaymentTypeState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../PaymentType/ViewPaymentTypeScreen.dart';

class AddPaymentTypeScreen extends StatefulWidget {
  const AddPaymentTypeScreen({super.key});

  @override
  State<AddPaymentTypeScreen> createState() => _AddPaymentTypeScreenState();
}

class _AddPaymentTypeScreenState extends State<AddPaymentTypeScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Payment Type",
      body: BlocConsumer<PaymentTypeBloc, PaymentTypeState>(
        listener: (context, state) {
          if (state is PaymentTypeCreated) {
            SuccessSnackBar.show(context, message: "Payment Type Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPaymentTypeScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is PaymentTypeError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Type Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 24),

                TextInputField(
                  controller: _nameController,
                  label: 'Payment Type Name *',
                  hintText: 'e.g., Cash, Credit Card, Bank Transfer',
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _createPaymentType,
                    text: _isLoading ? 'Creating...' : 'Create Payment Type',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _createPaymentType() async {
    if (_nameController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter payment type name");
      return;
    }

    if (_currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "User not authenticated");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final paymentTypeData = {
      "name": _nameController.text.trim(),
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "created_by_id": _currentUserId,
    };

    try {
      context.read<PaymentTypeBloc>().add(CreatePaymentType(paymentTypeData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}