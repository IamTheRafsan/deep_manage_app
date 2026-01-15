import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Deposit/DepositBloc.dart';
import '../../Bloc/Deposit/DepositState.dart';
import '../../Bloc/Deposit/DepositEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'DepositDetailScreen.dart';

class ViewDepositScreen extends StatefulWidget {
  const ViewDepositScreen({super.key});

  @override
  State<ViewDepositScreen> createState() => _ViewDepositScreenState();
}

class _ViewDepositScreenState extends State<ViewDepositScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<DepositBloc>().add(LoadDeposit(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Deposits",
      body: BlocBuilder<DepositBloc, DepositState>(
        builder: (context, state) {
          if (state is DepositLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is DepositLoaded) {
            final deposits = state.deposits;

            if (deposits.isEmpty) {
              return _buildEmptyState(_showDeleted);
            }

            return Column(
              children: [
                if (_showDeleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.orange.shade50,
                    child: Row(
                      children: [
                        Icon(Icons.info, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Showing deleted deposits",
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<DepositBloc>().add(LoadDeposit(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: deposits.length,
                      itemBuilder: (context, index) {
                        final deposit = deposits[index];

                        return ViewCard(
                          title: deposit.name,
                          subtitle: "${deposit.categoryName ?? 'No Category'}\n৳${deposit.amount}",
                          icon: Icons.account_balance_wallet_outlined,
                          dateText: "${deposit.created_date}",
                          //isDeleted: deposit.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DepositDetailScreen(depositId: deposit.id),
                              ),
                            );
                            context.read<DepositBloc>().add(LoadDeposit(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DepositError) {
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
                    "Error Loading Deposits",
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
                      context.read<DepositBloc>().add(LoadDeposit(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No deposits available"),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool showDeleted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              showDeleted ? Icons.delete_outline : Icons.account_balance_wallet_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Deposits Found" : "No Deposits Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted deposits to show"
                : "Create your first deposit to get started",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}