import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Deposit/DepositBloc.dart';
import '../../Bloc/Deposit/DepositEvent.dart';
import '../../Bloc/Deposit/DepositState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateDepositScreen.dart';

class DepositDetailScreen extends StatefulWidget {
  final String depositId;

  const DepositDetailScreen({super.key, required this.depositId});

  @override
  State<DepositDetailScreen> createState() => _DepositDetailScreenState();
}

class _DepositDetailScreenState extends State<DepositDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DepositBloc>().add(LoadDepositById(widget.depositId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Deposit Details",
      onBackPressed: () {
        final bloc = context.read<DepositBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadDeposit());
      },
      body: BlocConsumer<DepositBloc, DepositState>(
        listener: (context, state) {
          if (state is DepositDeleted) {
            SuccessSnackBar.show(context, message: "Deposit Deleted Successfully!");
            context.read<DepositBloc>().add(LoadDeposit());
            Navigator.pop(context);
          }

          if (state is DepositUpdated) {
            SuccessSnackBar.show(context, message: "Deposit Updated Successfully");
            context.read<DepositBloc>().add(LoadDepositById(widget.depositId));
          }

          if (state is DepositError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is DepositLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DepositLoadedSingle) {
            final deposit = state.deposit;

            // Determine status color
            Color statusColor;
            switch (deposit.status) {
              case 'PAID':
                statusColor = Colors.green;
                break;
              case 'PENDING':
                statusColor = Colors.orange;
                break;
              case 'CANCELLED':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.grey;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deposit Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.primaryColor,
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
                                color: color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
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
                                    deposit.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      deposit.status,
                                      style: AppText.BodyText().copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Amount: ৳${deposit.amount}",
                          style: AppText.SubHeadingText().copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Deposit Information Section
                  Text(
                    "Deposit Details",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.category_outlined,
                    title: "Category",
                    value: deposit.categoryName ?? 'N/A',
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.description_outlined,
                    title: "Description",
                    value: deposit.description.isNotEmpty ? deposit.description : 'No description',
                  ),

                  const SizedBox(height: 28),

                  // Related Information Section
                  Text(
                    "Related Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (deposit.warehouseName != null && deposit.warehouseName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.warehouse_outlined,
                      title: "Warehouse",
                      value: deposit.warehouseName!,
                    ),
                  const SizedBox(height: 12),

                  if (deposit.outletName != null && deposit.outletName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.store_outlined,
                      title: "Outlet",
                      value: deposit.outletName!,
                    ),
                  const SizedBox(height: 12),

                  if (deposit.userName != null && deposit.userName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.person_outlined,
                      title: "Created By",
                      value: deposit.userName!,
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
                    value: "${deposit.created_date} at ${deposit.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${deposit.updated_date} at ${deposit.updated_time}",
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Deposit',
                          onPressed: () {
                            context.read<DepositBloc>().add(DeleteDeposit(deposit.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update Deposit',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateDepositScreen(
                                  depositId: deposit.id,
                                ),
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

          if (state is DepositError) {
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
                    "Error Loading Deposit",
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
                      context.read<DepositBloc>().add(LoadDepositById(widget.depositId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No deposit information available"),
          );
        },
      ),
    );
  }
}