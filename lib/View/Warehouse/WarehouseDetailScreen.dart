import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/Warehouse/WarehouseModel.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateWarehouseScreen.dart';

class WarehouseDetailScreen extends StatefulWidget {
  final String warehouseId;

  const WarehouseDetailScreen({super.key, required this.warehouseId});

  @override
  State<WarehouseDetailScreen> createState() => _WarehouseDetailScreenState();
}

class _WarehouseDetailScreenState extends State<WarehouseDetailScreen> {
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(LoadWarehouseById(widget.warehouseId));
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId') ?? '';
      _currentUserName = prefs.getString('userName') ?? '';
    });
  }

  void _restoreWarehouse(WarehouseModel warehouse) {
    context.read<WarehouseBloc>().add(RestoreWarehouse(warehouse.id));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Warehouse Details",
      onBackPressed: () {
        final warehouseBloc = context.read<WarehouseBloc>();
        Navigator.of(context).pop();
        warehouseBloc.add(LoadWarehouse());
      },
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseDeleted) {
            SuccessSnackBar.show(context, message: "Warehouse Deleted Successfully!");
            context.read<WarehouseBloc>().add(LoadWarehouse());
            Navigator.pop(context);
          }

          if (state is WarehouseRestored) {
            SuccessSnackBar.show(context, message: "Warehouse Restored Successfully!");
            context.read<WarehouseBloc>().add(LoadWarehouseById(widget.warehouseId));
          }

          if (state is WarehouseUpdated) {
            SuccessSnackBar.show(context, message: "Warehouse Updated Successfully");
            context.read<WarehouseBloc>().add(LoadWarehouseById(widget.warehouseId));
          }

          if (state is WarehouseError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is WarehouseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WarehouseLoadedSingle) {
            final warehouse = state.warehouse;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warehouse Header Card with Deleted Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: warehouse.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: warehouse.deleted ? Colors.red : color.primaryColor,
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
                                color: warehouse.deleted ? Colors.red : color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.warehouse_outlined,
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
                                    warehouse.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: warehouse.status == 'ACTIVE'
                                              ? Colors.green.shade100
                                              : Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          warehouse.status,
                                          style: AppText.BodyText().copyWith(
                                            color: warehouse.status == 'ACTIVE'
                                                ? Colors.green
                                                : Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (warehouse.deleted) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "DELETED",
                                            style: AppText.BodyText().copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (warehouse.deleted) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.red.shade200),
                          Row(
                            children: [
                              Icon(Icons.delete_outline, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Deleted by ${warehouse.deletedByName} on ${warehouse.deletedDate}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Contact Information Section
                  Text(
                    "Contact Details",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.email,
                    title: "Email",
                    value: warehouse.email,
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.phone,
                    title: "Mobile",
                    value: warehouse.mobile,
                  ),

                  const SizedBox(height: 28),

                  // Location Information Section
                  Text(
                    "Location Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.flag,
                    title: "Country",
                    value: warehouse.country,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.location_city_outlined,
                          title: "City",
                          value: warehouse.city,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.pin_drop_outlined,
                          title: "Area",
                          value: warehouse.area,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Audit Information
                  Text(
                    "Audit Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${warehouse.created_date} at ${warehouse.created_time}",
                  ),
                  const SizedBox(height: 12),


                  if (warehouse.updated_date != null && warehouse.updated_date!.isNotEmpty)
                    InfoCard(
                      icon: Icons.update_outlined,
                      title: "Last Updated",
                      value: "${warehouse.updated_date} at ${warehouse.updated_time}",
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (warehouse.deleted)
                    PrimaryButton(
                      text: 'Restore Warehouse',
                      onPressed: () => _restoreWarehouse(warehouse),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Warehouse',
                            onPressed: () => context
                                .read<WarehouseBloc>()
                                .add(DeleteWarehouse(warehouse.id)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Warehouse',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateWarehouseScreen(
                                      warehouseId: warehouse.id),
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

          if (state is WarehouseError) {
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
                    "Error Loading Warehouse",
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
                      context.read<WarehouseBloc>().add(LoadWarehouseById(widget.warehouseId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No warehouse information available"),
          );
        },
      ),
    );
  }
}