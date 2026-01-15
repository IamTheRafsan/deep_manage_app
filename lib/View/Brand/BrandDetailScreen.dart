import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Brand/BrandBloc.dart';
import '../../Bloc/Brand/BrandEvent.dart';
import '../../Bloc/Brand/BrandState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateBrandScreen.dart';

class BrandDetailScreen extends StatefulWidget {
  final String brandId;

  const BrandDetailScreen({super.key, required this.brandId});

  @override
  State<BrandDetailScreen> createState() => _BrandDetailScreenState();
}

class _BrandDetailScreenState extends State<BrandDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrandBloc>().add(LoadBrandById(widget.brandId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Brand Details",
      onBackPressed: () {
        final brandBloc = context.read<BrandBloc>();
        Navigator.of(context).pop();
        brandBloc.add(LoadBrand());
      },
      body: BlocConsumer<BrandBloc, BrandState>(
        listener: (context, state) {
          if (state is BrandDeleted) {
            SuccessSnackBar.show(context, message: "Brand Deleted Successfully!");
            context.read<BrandBloc>().add(LoadBrand());
            Navigator.pop(context);
          }

          if (state is BrandUpdated) {
            SuccessSnackBar.show(context, message: "Brand Updated Successfully");
            context.read<BrandBloc>().add(LoadBrandById(widget.brandId));
          }

          if (state is BrandError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BrandLoadedSingle) {
            final brand = state.brand;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.primaryColor,
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
                                color: color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.branding_watermark_outlined,
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
                                    brand.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Code: ${brand.code}",
                                      style: AppText.BodyText().copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Brand Information Section
                  Text(
                    "Brand Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.code_outlined,
                    title: "Brand Code",
                    value: brand.code,
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${brand.created_date} at ${brand.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${brand.updated_date} at ${brand.updated_time}",
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Brand',
                          onPressed: () {
                            context.read<BrandBloc>().add(DeleteBrand(brand.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update Brand',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateBrandScreen(
                                  brandId: brand.id,
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

          if (state is BrandError) {
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
                    "Error Loading Brand",
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
                      context.read<BrandBloc>().add(LoadBrandById(widget.brandId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No brand information available"),
          );
        },
      ),
    );
  }
}