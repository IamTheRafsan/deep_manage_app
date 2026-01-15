import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/WeightLess/WeightLessBloc.dart';
import '../../Bloc/WeightLess/WeightLessEvent.dart';
import '../../Bloc/WeightLess/WeightLessState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/WeightLess/WeightLessModel.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateWeightLessScreen.dart';

class WeightLessDetailScreen extends StatefulWidget {
  final String weightLessId;

  const WeightLessDetailScreen({super.key, required this.weightLessId});

  @override
  State<WeightLessDetailScreen> createState() => _WeightLessDetailScreenState();
}

class _WeightLessDetailScreenState extends State<WeightLessDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WeightLessBloc>().add(LoadWeightLessById(widget.weightLessId));
  }

  void _restoreWeightLess(WeightLessModel weightLess) {
    context.read<WeightLessBloc>().add(RestoreWeightLess(weightLess.id));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Weight Loss Details",
      onBackPressed: () {
        final weightLessBloc = context.read<WeightLessBloc>();
        Navigator.of(context).pop();
        weightLessBloc.add(LoadWeightLesses());
      },
      body: BlocConsumer<WeightLessBloc, WeightLessState>(
        listener: (context, state) {
          if (state is WeightLessDeleted) {
            SuccessSnackBar.show(context, message: "Weight Loss Deleted Successfully!");
            context.read<WeightLessBloc>().add(LoadWeightLesses());
            Navigator.pop(context);
          }

          if (state is WeightLessRestored) {
            SuccessSnackBar.show(context, message: "Weight Loss Restored Successfully!");
            context.read<WeightLessBloc>().add(LoadWeightLessById(widget.weightLessId));
          }

          if (state is WeightLessUpdated) {
            SuccessSnackBar.show(context, message: "Weight Loss Updated Successfully");
            context.read<WeightLessBloc>().add(LoadWeightLessById(widget.weightLessId));
          }

          if (state is WeightLessError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is WeightLessLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WeightLessLoadedSingle) {
            final weightLess = state.weightLess;

            // Calculate totals
            final totalItems = weightLess.weightLessItems.length;
            final totalWeightLoss = weightLess.weightLessItems.fold(
              0.0,
                  (sum, item) => sum + item.quantity,
            );

            // Calculate percentage loss if we have original quantities
            double totalOriginalQuantity = 0.0;
            for (var item in weightLess.weightLessItems) {
              if (item.originalQuantity != null) {
                totalOriginalQuantity += item.originalQuantity!;
              }
            }

            final percentageLoss = totalOriginalQuantity > 0
                ? (totalWeightLoss / totalOriginalQuantity * 100)
                : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight Less Header Card with Deleted Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: weightLess.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: weightLess.deleted ? Colors.red : color.primaryColor,
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
                                color: weightLess.deleted ? Colors.red : color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.scale_outlined,
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
                                    "Weight Loss Record #${weightLess.id}",
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Purchase: ${weightLess.purchaseReference ?? 'N/A'}",
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                  if (weightLess.deleted) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.delete, size: 14, color: Colors.red.shade800),
                                          const SizedBox(width: 4),
                                          Text(
                                            "DELETED",
                                            style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                      child: Column(
                        children: [
                          Row(
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
                                    totalItems.toString(),
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
                                    "Total Weight Loss",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${totalWeightLoss.toStringAsFixed(2)} units",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Percentage Loss",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${percentageLoss.toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: percentageLoss > 10 ? Colors.red : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (totalOriginalQuantity > 0) ...[
                            const SizedBox(height: 12),
                            Divider(color: Colors.grey.shade300),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Original Quantity:",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${totalOriginalQuantity.toStringAsFixed(2)} units",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Weight Less Information
                  Text(
                    "Weight Loss Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.shopping_cart_outlined,
                    title: "Purchase Reference",
                    value: weightLess.purchaseReference ?? "N/A",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.person_outline,
                    title: "Recorded By",
                    value: weightLess.userName ?? "N/A",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.description_outlined,
                    title: "Reason",
                    value: weightLess.reason,
                  ),

                  const SizedBox(height: 28),

                  // Weight Less Items
                  Text(
                    "Weight Loss Items",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (weightLess.weightLessItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "No weight loss items found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: weightLess.weightLessItems.length,
                      itemBuilder: (context, index) {
                        final item = weightLess.weightLessItems[index];
                        final originalQty = item.originalQuantity ?? 0.0;
                        final remainingQty = originalQty - item.quantity;
                        final itemPercentage = originalQty > 0
                            ? (item.quantity / originalQty * 100)
                            : 0.0;

                        return Card(
                          color: color.cardBackgroundColor,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName ?? 'Unknown Product',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (item.productCode != null && item.productCode!.isNotEmpty)
                                            Text(
                                              "Code: ${item.productCode!}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (itemPercentage > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: itemPercentage > 30
                                              ? Colors.red.shade50
                                              : itemPercentage > 10
                                              ? Colors.orange.shade50
                                              : Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: itemPercentage > 30
                                                ? Colors.red.shade200
                                                : itemPercentage > 10
                                                ? Colors.orange.shade200
                                                : Colors.green.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          "${itemPercentage.toStringAsFixed(1)}%",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: itemPercentage > 30
                                                ? Colors.red.shade800
                                                : itemPercentage > 10
                                                ? Colors.orange.shade800
                                                : Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Progress bar for visual representation
                                if (originalQty > 0)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: item.quantity / originalQty,
                                              backgroundColor: Colors.grey.shade200,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                itemPercentage > 30
                                                    ? Colors.red
                                                    : itemPercentage > 10
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                              minHeight: 8,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "${itemPercentage.toStringAsFixed(1)}%",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: itemPercentage > 30
                                                  ? Colors.red
                                                  : itemPercentage > 10
                                                  ? Colors.orange
                                                  : Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Original',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${originalQty.toStringAsFixed(2)} units',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Weight Loss',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity.toStringAsFixed(2)} units',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Remaining',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${remainingQty.toStringAsFixed(2)} units',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (item.reason != null && item.reason!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.orange.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 16, color: Colors.orange.shade800),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.reason!,
                                            style: TextStyle(
                                              color: Colors.orange.shade800,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

                  if (weightLess.createdDate != null)
                    InfoCard(
                      icon: Icons.calendar_today_outlined,
                      title: "Created Date",
                      value: "${weightLess.createdDate ?? 'N/A'} ${weightLess.createdTime != null ? 'at ${weightLess.createdTime}' : ''}",
                    ),

                  if (weightLess.updatedDate != null && weightLess.updatedDate!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated",
                          value: "${weightLess.updatedDate} ${weightLess.updatedTime != null ? 'at ${weightLess.updatedTime}' : ''}",
                        ),
                      ],
                    ),

                  // Deletion info if deleted
                  if (weightLess.deleted && weightLess.deletedDate != null)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.delete_outline,
                          title: "Deleted",
                          value: "${weightLess.deletedDate ?? 'N/A'} ${weightLess.deletedTime != null ? 'at ${weightLess.deletedTime}' : ''}",
                        ),
                      ],
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (weightLess.deleted)
                    PrimaryButton(
                      text: 'Restore Weight Loss',
                      onPressed: () => _restoreWeightLess(weightLess),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Weight Loss',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Weight Loss"),
                                  content: const Text(
                                    "Are you sure you want to delete this weight loss record? "
                                        "This action cannot be undone.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.read<WeightLessBloc>()
                                            .add(DeleteWeightLess(weightLess.id));
                                      },
                                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Weight Loss',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateWeightLessScreen(
                                    weightLessId: weightLess.id,
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

          if (state is WeightLessError) {
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
                    "Error Loading Weight Loss",
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
                      context.read<WeightLessBloc>().add(LoadWeightLessById(widget.weightLessId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No weight loss information available"),
          );
        },
      ),
    );
  }
}