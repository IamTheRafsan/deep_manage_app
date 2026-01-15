import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/WeightLess/WeightLessBloc.dart';
import '../../Bloc/WeightLess/WeightLessState.dart';
import '../../Bloc/WeightLess/WeightLessEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Cards/ViewCard.dart';
import '../../Component/CircularIndicator/CustomCircularIndicator.dart';
import 'WeightLessDetailScreen.dart';

class ViewWeightLessScreen extends StatefulWidget {
  const ViewWeightLessScreen({super.key});

  @override
  State<ViewWeightLessScreen> createState() => _ViewWeightLessScreenState();
}

class _ViewWeightLessScreenState extends State<ViewWeightLessScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<WeightLessBloc>().add(LoadWeightLesses(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Weight Loss Records",
      body: BlocBuilder<WeightLessBloc, WeightLessState>(
        builder: (context, state) {
          if (state is WeightLessLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is WeightLessLoaded) {
            final weightLesses = state.weightLesses;

            if (weightLesses.isEmpty) {
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
                            "Showing deleted weight loss records",
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
                      context.read<WeightLessBloc>().add(LoadWeightLesses(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: weightLesses.length,
                      itemBuilder: (context, index) {
                        final weightLess = weightLesses[index];

                        // Calculate total weight loss
                        final totalWeightLoss = weightLess.weightLessItems.fold(
                          0.0,
                              (sum, item) => sum + item.quantity,
                        );

                        return ViewCard(
                          title: "Purchase Id: ${weightLess.purchaseReference ?? 'N/A'}",
                          subtitle: "Weight Loss Record",
                          icon: Icons.scale_outlined,
                          dateText: weightLess.createdDate ?? '',
                          // amount: totalWeightLoss,
                          // amountSuffix: "units",
                          // isDeleted: weightLess.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WeightLessDetailScreen(
                                  weightLessId: weightLess.id,
                                ),
                              ),
                            );
                            context.read<WeightLessBloc>().add(LoadWeightLesses(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is WeightLessError) {
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
                    "Error Loading Weight Loss Records",
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
                      context.read<WeightLessBloc>().add(LoadWeightLesses(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No weight loss records available"),
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
              showDeleted ? Icons.delete_outline : Icons.scale_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Weight Loss Records Found" : "No Weight Loss Records Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted weight loss records to show"
                : "Record your first weight loss to get started",
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