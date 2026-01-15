import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/PaymentType/PaymentTypeBloc.dart';
import '../../Bloc/PaymentType/PaymentTypeEvent.dart';
import '../../Bloc/PaymentType/PaymentTypeState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/PaymentType/PaymentTypeModel.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdatePaymentTypeScreen.dart';

class PaymentTypeDetailScreen extends StatefulWidget {
  final String paymentTypeId;

  const PaymentTypeDetailScreen({super.key, required this.paymentTypeId});

  @override
  State<PaymentTypeDetailScreen> createState() => _PaymentTypeDetailScreenState();
}

class _PaymentTypeDetailScreenState extends State<PaymentTypeDetailScreen> {
  String _currentUserId = '';
  String _currentUserName = '';

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
      _currentUserName = prefs.getString('userName') ?? '';
    });
  }

  void _restorePaymentType(PaymentTypeModel paymentType) {
    context.read<PaymentTypeBloc>().add(RestorePaymentType(paymentType.id));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Payment Type Details",
      onBackPressed: () {
        final paymentTypeBloc = context.read<PaymentTypeBloc>();
        Navigator.of(context).pop();
        paymentTypeBloc.add(LoadPaymentTypes());
      },
      body: BlocConsumer<PaymentTypeBloc, PaymentTypeState>(
        listener: (context, state) {
          if (state is PaymentTypeDeleted) {
            SuccessSnackBar.show(context, message: "Payment Type Deleted Successfully!");
            context.read<PaymentTypeBloc>().add(LoadPaymentTypes());
            Navigator.pop(context);
          }

          if (state is PaymentTypeRestored) {
            SuccessSnackBar.show(context, message: "Payment Type Restored Successfully!");
            context.read<PaymentTypeBloc>().add(LoadPaymentTypeById(widget.paymentTypeId));
          }

          if (state is PaymentTypeUpdated) {
            SuccessSnackBar.show(context, message: "Payment Type Updated Successfully");
            context.read<PaymentTypeBloc>().add(LoadPaymentTypeById(widget.paymentTypeId));
          }

          if (state is PaymentTypeError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is PaymentTypeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PaymentTypeLoadedSingle) {
            final paymentType = state.paymentType;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Type Header Card with Deleted Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: paymentType.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: paymentType.deleted ? Colors.red : color.primaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: paymentType.deleted ? Colors.red : color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.payment_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    paymentType.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  if (paymentType.deleted) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "DELETED",
                                        style: AppText.BodyText().copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (paymentType.deleted) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.red.shade200),
                          Row(
                            children: [
                              Icon(Icons.delete_outline, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Deleted by ${paymentType.deletedByName ?? 'Unknown'} on ${paymentType.deletedDate ?? 'Unknown'}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Audit Information
                  Text(
                    "Audit Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${paymentType.createdDate ?? 'N/A'} ${paymentType.createdTime != null ? 'at ${paymentType.createdTime}' : ''}",
                  ),
                  const SizedBox(height: 12),

                  if (paymentType.createdByName != null && paymentType.createdByName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.person_outline,
                      title: "Created By",
                      value: paymentType.createdByName!,
                    ),

                  if (paymentType.updatedDate != null && paymentType.updatedDate!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated",
                          value: "${paymentType.updatedDate} ${paymentType.updatedTime != null ? 'at ${paymentType.updatedTime}' : ''}",
                        ),
                      ],
                    ),

                  if (paymentType.updatedByName != null && paymentType.updatedByName!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.person_outline,
                          title: "Updated By",
                          value: paymentType.updatedByName!,
                        ),
                      ],
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (paymentType.deleted)
                    PrimaryButton(
                      text: 'Restore Payment Type',
                      onPressed: () => _restorePaymentType(paymentType),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Payment Type',
                            onPressed: () => context
                                .read<PaymentTypeBloc>()
                                .add(DeletePaymentType(paymentType.id)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Payment Type',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePaymentTypeScreen(
                                      paymentTypeId: paymentType.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          if (state is PaymentTypeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error Loading Payment Type",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PaymentTypeBloc>().add(LoadPaymentTypeById(widget.paymentTypeId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No payment type information available"),
          );
        },
      ),
    );
  }
}