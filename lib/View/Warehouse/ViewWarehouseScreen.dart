import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'WarehouseDetailScreen.dart';

class ViewWarehouseScreen extends StatefulWidget {
  const ViewWarehouseScreen({super.key});

  @override
  State<ViewWarehouseScreen> createState() => _ViewWarehouseScreenState();
}

class _ViewWarehouseScreenState extends State<ViewWarehouseScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Warehouses",
      body: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (context, state) {
          if (state is WarehouseLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is WarehouseLoaded) {
            final warehouses = state.warehouses;

            if (warehouses.isEmpty) {
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
                            "Showing deleted warehouses",
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
                      context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: warehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = warehouses[index];

                        return ViewCard(
                          title: warehouse.name,
                          subtitle: "${warehouse.city}, ${warehouse.area}\n${warehouse.email}",
                          icon: Icons.warehouse_outlined,
                          dateText: warehouse.created_date ?? '',
                          // status: warehouse.status,
                          // isDeleted: warehouse.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WarehouseDetailScreen(
                                   warehouseId: warehouse.id),
                              ),
                            );
                            context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is WarehouseError) {
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
                    "Error Loading Warehouses",
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
                      context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No warehouses available"),
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
              showDeleted ? Icons.delete_outline : Icons.warehouse_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Warehouses Found" : "No Warehouses Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted warehouses to show"
                : "Create your first warehouse to get started",
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