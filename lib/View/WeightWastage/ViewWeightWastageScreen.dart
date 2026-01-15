import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/WeightWastage/WeightWastageBloc.dart';
import '../../Bloc/WeightWastage/WeightWastageState.dart';
import '../../Bloc/WeightWastage/WeightWastageEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Cards/ViewCard.dart';
import '../../Component/CircularIndicator/CustomCircularIndicator.dart';
import 'WeightWastageDetailScreen.dart';

class ViewWeightWastageScreen extends StatefulWidget {
  const ViewWeightWastageScreen({super.key});

  @override
  State<ViewWeightWastageScreen> createState() => _ViewWeightWastageScreenState();
}

class _ViewWeightWastageScreenState extends State<ViewWeightWastageScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<WeightWastageBloc>().add(LoadWeightWastages(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Weight Wastage Records",
      body: BlocBuilder<WeightWastageBloc, WeightWastageState>(
        builder: (context, state) {
          if (state is WeightWastageLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is WeightWastageLoaded) {
            final weightWastages = state.weightWastages;

            if (weightWastages.isEmpty) {
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
                        const Icon(Icons.info, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Showing deleted weight wastage records",
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
                      context.read<WeightWastageBloc>().add(LoadWeightWastages(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: weightWastages.length,
                      itemBuilder: (context, index) {
                        final weightWastage = weightWastages[index];

                        // Calculate total weight wastage
                        final totalWeightWastage = weightWastage.weightWastageItems.fold(
                          0.0,
                              (sum, item) => sum + item.quantity,
                        );

                        return ViewCard(
                          title: "Purchase Id: ${weightWastage.purchaseReference ?? 'N/A'}",
                          subtitle: "Weight Wastage Record",
                          icon: Icons.water_damage_outlined,
                          dateText: weightWastage.createdDate ?? '',
                          // amount: totalWeightWastage,
                          // amountSuffix: "units",
                          //isDeleted: weightWastage.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WeightWastageDetailScreen(
                                  weightWastageId: weightWastage.id,
                                ),
                              ),
                            );
                            context.read<WeightWastageBloc>().add(LoadWeightWastages(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is WeightWastageError) {
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
                    "Error Loading Weight Wastage Records",
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
                      context.read<WeightWastageBloc>().add(LoadWeightWastages(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No weight wastage records available"),
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
              showDeleted ? Icons.delete_outline : Icons.water_damage_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Weight Wastage Records Found" : "No Weight Wastage Records Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted weight wastage records to show"
                : "Record your first weight wastage to get started",
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