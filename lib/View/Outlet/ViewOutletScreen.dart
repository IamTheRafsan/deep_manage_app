// lib/Screens/Outlet/ViewOutletScreen.dart
import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Outlet/OutletBloc.dart';
import '../../Bloc/Outlet/OutletState.dart';
import '../../Bloc/Outlet/OutletEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'OutletDetailScreen.dart';

class ViewOutletScreen extends StatefulWidget {
  const ViewOutletScreen({super.key});

  @override
  State<ViewOutletScreen> createState() => _ViewOutletScreenState();
}

class _ViewOutletScreenState extends State<ViewOutletScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<OutletBloc>().add(LoadOutlet(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Outlets",
      body: BlocBuilder<OutletBloc, OutletState>(
        builder: (context, state) {
          if (state is OutletLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is OutletLoaded) {
            final outlets = state.outlets;

            if (outlets.isEmpty) {
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
                            "Showing deleted outlets",
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
                      context.read<OutletBloc>().add(LoadOutlet(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: outlets.length,
                      itemBuilder: (context, index) {
                        final outlet = outlets[index];

                        return ViewCard(
                          title: outlet.name.isNotEmpty ? outlet.name : "Unnamed Outlet",
                          subtitle: "${outlet.city}, ${outlet.area}\n${outlet.email}",
                          icon: Icons.store_outlined,
                          dateText: outlet.created_date ?? '',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OutletDetailScreen(outletId: outlet.id),
                              ),
                            );
                            context.read<OutletBloc>().add(LoadOutlet(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is OutletError) {
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
                    "Error Loading Outlets",
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
                      context.read<OutletBloc>().add(LoadOutlet(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No outlets available"),
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
              showDeleted ? Icons.delete_outline : Icons.store_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Outlets Found" : "No Outlets Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted outlets to show"
                : "Create your first outlet to get started",
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