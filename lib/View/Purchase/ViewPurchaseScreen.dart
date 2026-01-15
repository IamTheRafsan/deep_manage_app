import 'package:deep_manage_app/Bloc/User/UserBlock.dart';
import 'package:deep_manage_app/Bloc/User/UserEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Purchase/PurchaseBloc.dart';
import '../../Bloc/Purchase/PurchaseState.dart';
import '../../Bloc/Purchase/PurchaseEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Cards/ViewCard.dart';
import '../../Component/CircularIndicator/CustomCircularIndicator.dart';
import 'PurchaseDetailScreen.dart';

class ViewPurchaseScreen extends StatefulWidget {
  const ViewPurchaseScreen({super.key});

  @override
  State<ViewPurchaseScreen> createState() => _ViewPurchaseScreenState();
}

class _ViewPurchaseScreenState extends State<ViewPurchaseScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<PurchaseBloc>().add(LoadPurchases(showDeleted: _showDeleted));
    context.read<UserBloc>().add(LoadUser(),);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Purchases",
      body: BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is PurchaseLoaded) {
            final purchases = state.purchases;

            if (purchases.isEmpty) {
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
                            "Showing deleted purchases",
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
                      context.read<PurchaseBloc>().add(LoadPurchases(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        final purchase = purchases[index];

                        // // Calculate total amount
                        // final totalAmount = purchase.totalAmount ??
                        //     purchase.purchaseItems.fold(0.0, (sum, item) {
                        //       final quantity = item['quantity'] ?? 0.0;
                        //       final price = item['purchasePrice'] ?? 0.0;
                        //       return sum! + (quantity * price);
                        //     });

                        return ViewCard(
                          title: purchase.reference,
                          subtitle: "Purchased By: ${purchase.purchasedByName}",
                          icon: Icons.shopping_cart_outlined,
                          dateText: purchase.purchaseDate ?? purchase.createdDate ?? '',
                          //amount: totalAmount,
                          //isDeleted: purchase.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PurchaseDetailScreen(
                                  purchaseId: purchase.id,
                                ),
                              ),
                            );
                            context.read<PurchaseBloc>().add(LoadPurchases(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is PurchaseError) {
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
                    "Error Loading Purchases",
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
                      context.read<PurchaseBloc>().add(LoadPurchases(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No purchases available"),
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
                showDeleted ? Icons.delete_outline : Icons.shopping_cart_outlined,
                size: 64,
                color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              showDeleted ? "No Deleted Purchases Found" : "No Purchases Found",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              showDeleted
                  ? "There are no deleted purchases to show"
                  : "Create your first purchase to get started",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}