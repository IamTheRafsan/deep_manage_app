// lib/Screens/Outlet/OutletDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Outlet/OutletBloc.dart';
import '../../Bloc/Outlet/OutletEvent.dart';
import '../../Bloc/Outlet/OutletState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateOutletScreen.dart';

class OutletDetailScreen extends StatefulWidget {
  final String outletId;

  const OutletDetailScreen({super.key, required this.outletId});

  @override
  State<OutletDetailScreen> createState() => _OutletDetailScreenState();
}

class _OutletDetailScreenState extends State<OutletDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OutletBloc>().add(LoadOutletById(widget.outletId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Outlet Details",
      onBackPressed: () {
        final outletBloc = context.read<OutletBloc>();
        Navigator.of(context).pop();
        outletBloc.add(LoadOutlet());
      },
      body: BlocConsumer<OutletBloc, OutletState>(
        listener: (context, state) {
          if (state is OutletDeleted) {
            SuccessSnackBar.show(context, message: "Outlet Deleted Successfully!");
            context.read<OutletBloc>().add(LoadOutlet());
            Navigator.pop(context);
          }

          if (state is OutletUpdated) {
            SuccessSnackBar.show(context, message: "Outlet Updated Successfully");
            context.read<OutletBloc>().add(LoadOutletById(widget.outletId));
          }

          if (state is OutletError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is OutletLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OutletLoadedSingle) {
            final outlet = state.outlet;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Outlet Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: outlet.deleted ? Colors.red.shade50 : color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: outlet.deleted ? Colors.red : color.primaryColor,
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
                                color: outlet.deleted ? Colors.red : color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.store_outlined,
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
                                    outlet.name.isNotEmpty ? outlet.name : "Unnamed Outlet",
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: outlet.status == 'ACTIVE'
                                              ? Colors.green.shade100
                                              : Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          outlet.status,
                                          style: AppText.BodyText().copyWith(
                                            color: outlet.status == 'ACTIVE'
                                                ? Colors.green
                                                : Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (outlet.deleted) ...[
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
                        if (outlet.deleted) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.red.shade200),
                          Row(
                            children: [
                              Icon(Icons.delete_outline, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Deleted by ${outlet.deletedByName} on ${outlet.deletedDate}",
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

                  // Warehouse Info
                  if (outlet.warehouseName != null && outlet.warehouseName!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Warehouse Information",
                          style: AppText.SubHeadingText(),
                        ),
                        const SizedBox(height: 16),
                        InfoCard(
                          icon: Icons.warehouse_outlined,
                          title: "Assigned Warehouse",
                          value: outlet.warehouseName!,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),

                  // Contact Information Section
                  Text(
                    "Contact Details",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.email,
                    title: "Email",
                    value: outlet.email,
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.phone,
                    title: "Mobile",
                    value: outlet.mobile,
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
                    value: outlet.country,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.location_city_outlined,
                          title: "City",
                          value: outlet.city,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.pin_drop_outlined,
                          title: "Area",
                          value: outlet.area,
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

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${outlet.created_date} at ${outlet.created_time}",
                  ),
                  const SizedBox(height: 12),

                  if (outlet.updated_date != null && outlet.updated_date!.isNotEmpty)
                    InfoCard(
                      icon: Icons.update_outlined,
                      title: "Last Updated",
                      value: "${outlet.updated_date} at ${outlet.updated_time}",
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  if (outlet.deleted)
                    PrimaryButton(
                      text: 'Outlet Deleted',
                      onPressed: null,
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Outlet',
                            onPressed: () => context
                                .read<OutletBloc>()
                                .add(DeleteOutlet(outlet.id)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Outlet',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateOutletScreen(
                                      outletId: outlet.id),
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

          if (state is OutletError) {
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
                    "Error Loading Outlet",
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
                      context.read<OutletBloc>().add(LoadOutletById(widget.outletId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No outlet information available"),
          );
        },
      ),
    );
  }
}