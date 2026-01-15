import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/WeightWastage/WeightWastageBloc.dart';
import '../../Bloc/WeightWastage/WeightWastageEvent.dart';
import '../../Bloc/WeightWastage/WeightWastageState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/WeightWastage/WeightWastageModel.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateWeightWastageSceen.dart';

class WeightWastageDetailScreen extends StatefulWidget {
  final String weightWastageId;

  const WeightWastageDetailScreen({super.key, required this.weightWastageId});

  @override
  State<WeightWastageDetailScreen> createState() => _WeightWastageDetailScreenState();
}

class _WeightWastageDetailScreenState extends State<WeightWastageDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WeightWastageBloc>().add(LoadWeightWastageById(widget.weightWastageId));
  }

  void _restoreWeightWastage(WeightWastageModel weightWastage) {
    context.read<WeightWastageBloc>().add(RestoreWeightWastage(weightWastage.id));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Weight Wastage Details",
      onBackPressed: () {
        final weightWastageBloc = context.read<WeightWastageBloc>();
        Navigator.of(context).pop();
        weightWastageBloc.add(LoadWeightWastages());
      },
      body: BlocConsumer<WeightWastageBloc, WeightWastageState>(
        listener: (context, state) {
          if (state is WeightWastageDeleted) {
            SuccessSnackBar.show(context, message: "Weight Wastage Deleted Successfully!");
            context.read<WeightWastageBloc>().add(LoadWeightWastages());
            Navigator.pop(context);
          }

          if (state is WeightWastageRestored) {
            SuccessSnackBar.show(context, message: "Weight Wastage Restored Successfully!");
            context.read<WeightWastageBloc>().add(LoadWeightWastageById(widget.weightWastageId));
          }

          if (state is WeightWastageUpdated) {
            SuccessSnackBar.show(context, message: "Weight Wastage Updated Successfully");
            context.read<WeightWastageBloc>().add(LoadWeightWastageById(widget.weightWastageId));
          }

          if (state is WeightWastageError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is WeightWastageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WeightWastageLoadedSingle) {
            final weightWastage = state.weightWastage;

            // Calculate totals
            final totalItems = weightWastage.weightWastageItems.length;
            final totalWeightWastage = weightWastage.weightWastageItems.fold(
              0.0,
                  (sum, item) => sum + item.quantity,
            );

            // Calculate percentage wastage if we have original quantities
            double totalOriginalQuantity = 0.0;
            for (var item in weightWastage.weightWastageItems) {
              if (item.originalQuantity != null) {
                totalOriginalQuantity += item.originalQuantity!;
              }
            }

            final percentageWastage = totalOriginalQuantity > 0
                ? (totalWeightWastage / totalOriginalQuantity * 100)
                : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight Wastage Header Card with Deleted Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: weightWastage.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: weightWastage.deleted ? Colors.red : Colors.orange,
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
                                color: weightWastage.deleted ? Colors.red : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.water_damage_outlined,
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
                                    "Weight Wastage Record #${weightWastage.id}",
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Purchase: ${weightWastage.purchaseReference ?? 'N/A'}",
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                  if (weightWastage.deleted) ...[
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
                                      "Total Weight Wastage",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${totalWeightWastage.toStringAsFixed(2)} units",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Percentage Wastage",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${percentageWastage.toStringAsFixed(1)}%",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: percentageWastage > 10 ? Colors.orange : Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

                  // Weight Wastage Information
                  Text(
                    "Weight Wastage Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.shopping_cart_outlined,
                    title: "Purchase Reference",
                    value: weightWastage.purchaseReference ?? "N/A",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.person_outline,
                    title: "Recorded By",
                    value: weightWastage.userName ?? "N/A",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.description_outlined,
                    title: "Reason",
                    value: weightWastage.reason,
                  ),

                  const SizedBox(height: 28),

                  // Weight Wastage Items
                  Text(
                    "Weight Wastage Items",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (weightWastage.weightWastageItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "No weight wastage items found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: weightWastage.weightWastageItems.length,
                      itemBuilder: (context, index) {
                        final item = weightWastage.weightWastageItems[index];
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
                                              ? Colors.orange.shade50
                                              : itemPercentage > 10
                                              ? Colors.blue.shade50
                                              : Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: itemPercentage > 30
                                                ? Colors.orange.shade200
                                                : itemPercentage > 10
                                                ? Colors.blue.shade200
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
                                                ? Colors.orange.shade800
                                                : itemPercentage > 10
                                                ? Colors.blue.shade800
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
                                                    ? Colors.orange
                                                    : itemPercentage > 10
                                                    ? Colors.blue
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
                                                  ? Colors.orange
                                                  : itemPercentage > 10
                                                  ? Colors.blue
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
                                          'Weight Wastage',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity.toStringAsFixed(2)} units',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
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

                  if (weightWastage.createdDate != null)
                    InfoCard(
                      icon: Icons.calendar_today_outlined,
                      title: "Created Date",
                      value: "${weightWastage.createdDate ?? 'N/A'} ${weightWastage.createdTime != null ? 'at ${weightWastage.createdTime}' : ''}",
                    ),

                  if (weightWastage.updatedDate != null && weightWastage.updatedDate!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated",
                          value: "${weightWastage.updatedDate} ${weightWastage.updatedTime != null ? 'at ${weightWastage.updatedTime}' : ''}",
                        ),
                      ],
                    ),

                  // Deletion info if deleted
                  if (weightWastage.deleted && weightWastage.deletedDate != null)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.delete_outline,
                          title: "Deleted",
                          value: "${weightWastage.deletedDate ?? 'N/A'} ${weightWastage.deletedTime != null ? 'at ${weightWastage.deletedTime}' : ''}",
                        ),
                      ],
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (weightWastage.deleted)
                    PrimaryButton(
                      text: 'Restore Weight Wastage',
                      onPressed: () => _restoreWeightWastage(weightWastage),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Weight Wastage',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Weight Wastage"),
                                  content: const Text(
                                    "Are you sure you want to delete this weight wastage record? "
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
                                        context.read<WeightWastageBloc>()
                                            .add(DeleteWeightWastage(weightWastage.id));
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
                            text: 'Update Weight Wastage',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateWeightWastageScreen(
                                    weightWastageId: weightWastage.id,
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

          if (state is WeightWastageError) {
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
                    "Error Loading Weight Wastage",
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
                      context.read<WeightWastageBloc>().add(LoadWeightWastageById(widget.weightWastageId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No weight wastage information available"),
          );
        },
      ),
    );
  }
}