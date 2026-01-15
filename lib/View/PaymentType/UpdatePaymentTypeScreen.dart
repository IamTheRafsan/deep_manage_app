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

class UpdatePaymentTypeScreen extends StatefulWidget {
  final String paymentTypeId;

  const UpdatePaymentTypeScreen({super.key, required this.paymentTypeId});

  @override
  State<UpdatePaymentTypeScreen> createState() => _UpdatePaymentTypeScreenState();
}

class _UpdatePaymentTypeScreenState extends State<UpdatePaymentTypeScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  bool _initialDataLoaded = false;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    context.read<PaymentTypeBloc>().add(LoadPaymentTypeById(widget.paymentTypeId));
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
      title: "Update Payment Type",
      body: BlocConsumer<PaymentTypeBloc, PaymentTypeState>(
        listener: (context, state) {
          if (state is PaymentTypeLoadedSingle && !_initialDataLoaded) {
            final paymentType = state.paymentType;
            _nameController.text = paymentType.name;
            _initialDataLoaded = true;
          }

          if (state is PaymentTypeUpdated) {
            SuccessSnackBar.show(context, message: "Payment Type Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is PaymentTypeError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is PaymentTypeLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading payment type data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is PaymentTypeLoadedSingle && state.paymentType.deleted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Payment Type is Deleted",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This payment type has been deleted and cannot be updated.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go Back"),
                  ),
                ],
              ),
            );
          }

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
                    onPressed: _isLoading ? null : _updatePaymentType,
                    text: _isLoading ? 'Updating...' : 'Update Payment Type',
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

  Future<void> _updatePaymentType() async {
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
    final updatedData = {
      "name": _nameController.text.trim(),
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_by_id": _currentUserId,
    };

    try {
      context.read<PaymentTypeBloc>().add(UpdatePaymentType(widget.paymentTypeId, updatedData));
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