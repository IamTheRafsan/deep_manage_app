import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Purchase/PurchaseBloc.dart';
import '../../Bloc/Purchase/PurchaseEvent.dart';
import '../../Bloc/Purchase/PurchaseState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/Purchase/PurchaseModel.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdatePurchaseScreen.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final String purchaseId;

  const PurchaseDetailScreen({super.key, required this.purchaseId});

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  // String _currentUserId = '';
  // String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    context.read<PurchaseBloc>().add(LoadPurchaseById(widget.purchaseId));
    //_getCurrentUser();
  }

  // Future<void> _getCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _currentUserId = prefs.getString('userId') ?? '';
  //     _currentUserName = prefs.getString('userName') ?? '';
  //   });
  // }

  void _restorePurchase(PurchaseModel purchase) {
    context.read<PurchaseBloc>().add(RestorePurchase(purchase.id));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Purchase Details",
      onBackPressed: () {
        final purchaseBloc = context.read<PurchaseBloc>();
        Navigator.of(context).pop();
        purchaseBloc.add(LoadPurchases());
      },
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseDeleted) {
            SuccessSnackBar.show(context, message: "Purchase Deleted Successfully!");
            context.read<PurchaseBloc>().add(LoadPurchases());
            Navigator.pop(context);
          }

          if (state is PurchaseRestored) {
            SuccessSnackBar.show(context, message: "Purchase Restored Successfully!");
            context.read<PurchaseBloc>().add(LoadPurchaseById(widget.purchaseId));
          }

          if (state is PurchaseUpdated) {
            SuccessSnackBar.show(context, message: "Purchase Updated Successfully");
            context.read<PurchaseBloc>().add(LoadPurchaseById(widget.purchaseId));
          }

          if (state is PurchaseError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PurchaseLoadedSingle) {
            final purchase = state.purchase;

            // Calculate total amount and quantity
            // final totalAmount = purchase.totalAmount ??
            //     purchase.purchaseItems.fold(0.0, (sum, item) {
            //       final quantity = item['quantity'] ?? 0.0;
            //       final price = item['purchasePrice'] ?? 0.0;
            //       return sum! + (quantity * price);
            //     });

            // final totalQuantity = purchase.totalQuantity ??
            //     purchase.purchaseItems.fold(0.0, (sum, item) => sum! + (item['quantity'] ?? 0.0));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purchase Header Card with Deleted Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: purchase.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: purchase.deleted ? Colors.red : color.primaryColor,
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
                                color: purchase.deleted ? Colors.red : color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined,
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
                                    purchase.reference,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Summary Card
                  Card(
                    elevation: 2,
                    color: color.cardBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Items",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                purchase.purchaseItems.length.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Quantity",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   totalQuantity.toStringAsFixed(2),
                              //   style: const TextStyle(
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   "\$${totalAmount.toStringAsFixed(2)}",
                              //   style: const TextStyle(
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.green,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Purchase Information
                  Text(
                    "Purchase Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.store,
                    title: "Warehouse",
                    value: purchase.warehouseName?? "Warehouse Name",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.account_circle,
                    title: "Supplier",
                    value: purchase.supplierName?? "Supplier Name",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.account_circle,
                    title: "Purchased By",
                    value: purchase.purchasedByName?? "Purchased By Name",
                  ),
                  const SizedBox(height: 12),


                  if (purchase.paymentTypeName != null && purchase.paymentTypeName!.isNotEmpty)
                    Column(
                      children: [
                        //const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.payment_outlined,
                          title: "Payment Type",
                          value: purchase.paymentTypeName!,
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),

                  //const SizedBox(height: 12),
                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Purchase Date",
                    value: purchase.purchaseDate ?? 'N/A',
                  ),

                  const SizedBox(height: 28),

                  // Purchase Items
                  Text(
                    "Purchase Items",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (purchase.purchaseItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "No items found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purchase.purchaseItems.length,
                      itemBuilder: (context, index) {
                        final item = purchase.purchaseItems[index];
                        final quantity = item['quantity'] ?? 0.0;
                        final purchasePrice = item['purchasePrice'] ?? 0.0;
                        final totalPrice = quantity * purchasePrice;
                        final productName = item['productName']?.toString() ?? 'Unknown Product';

                        return Card(
                          color: color.cardBackgroundColor,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity: $quantity',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      'Price: \$$purchasePrice',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      'Total: \$$totalPrice',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                    value: "${purchase.createdDate ?? 'N/A'} ${purchase.createdTime != null ? 'at ${purchase.createdTime}' : ''}",
                  ),

                  // if (purchase.createdByName != null && purchase.createdByName!.isNotEmpty)
                  //   Column(
                  //     children: [
                  //       const SizedBox(height: 12),
                  //       InfoCard(
                  //         icon: Icons.person_outline,
                  //         title: "Created By",
                  //         value: purchase.createdByName!,
                  //       ),
                  //     ],
                  //   ),

                  if (purchase.updatedDate != null && purchase.updatedDate!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated",
                          value: "${purchase.updatedDate} ${purchase.updatedTime != null ? 'at ${purchase.updatedTime}' : ''}",
                        ),
                      ],
                    ),

                  // if (purchase.updatedByName != null && purchase.updatedByName!.isNotEmpty)
                  //   Column(
                  //     children: [
                  //       const SizedBox(height: 12),
                  //       InfoCard(
                  //         icon: Icons.person_outline,
                  //         title: "Updated By",
                  //         value: purchase.updatedByName!,
                  //       ),
                  //     ],
                  //   ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (purchase.deleted)
                    PrimaryButton(
                      text: 'Restore Purchase',
                      onPressed: () => _restorePurchase(purchase),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Purchase',
                            onPressed: () => context
                                .read<PurchaseBloc>()
                                .add(DeletePurchase(purchase.id)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Purchase',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePurchaseScreen(
                                      purchaseId: purchase.id),
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

          if (state is PurchaseError) {
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
                    "Error Loading Purchase",
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
                      context.read<PurchaseBloc>().add(LoadPurchaseById(widget.purchaseId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No purchase information available"),
          );
        },
      ),
    );
  }
}