import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/PaymentType/PaymentTypeBloc.dart';
import '../../Bloc/PaymentType/PaymentTypeState.dart';
import '../../Bloc/PaymentType/PaymentTypeEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Cards/ViewCard.dart';
import '../../Component/CircularIndicator/CustomCircularIndicator.dart';
import '../PaymentType/PaymentTypeDetailScreen.dart';

class ViewPaymentTypeScreen extends StatefulWidget {
  const ViewPaymentTypeScreen({super.key});

  @override
  State<ViewPaymentTypeScreen> createState() => _ViewPaymentTypeScreenState();
}

class _ViewPaymentTypeScreenState extends State<ViewPaymentTypeScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<PaymentTypeBloc>().add(LoadPaymentTypes(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Payment Types",
      body: BlocBuilder<PaymentTypeBloc, PaymentTypeState>(
        builder: (context, state) {
          if (state is PaymentTypeLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is PaymentTypeLoaded) {
            final paymentTypes = state.paymentTypes;

            if (paymentTypes.isEmpty) {
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
                            "Showing deleted payment types",
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
                      context.read<PaymentTypeBloc>().add(LoadPaymentTypes(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: paymentTypes.length,
                      itemBuilder: (context, index) {
                        final paymentType = paymentTypes[index];

                        return ViewCard(
                          title: paymentType.name,
                          subtitle: paymentType.createdDate ?? '',
                          icon: Icons.payment_outlined,
                          dateText: paymentType.createdDate ?? '',
                          //isDeleted: paymentType.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentTypeDetailScreen(
                                  paymentTypeId: paymentType.id,
                                ),
                              ),
                            );
                            context.read<PaymentTypeBloc>().add(LoadPaymentTypes(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is PaymentTypeError) {
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
                    "Error Loading Payment Types",
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
                      context.read<PaymentTypeBloc>().add(LoadPaymentTypes(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No payment types available"),
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
              showDeleted ? Icons.delete_outline : Icons.payment_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Payment Types Found" : "No Payment Types Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted payment types to show"
                : "Create your first payment type to get started",
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