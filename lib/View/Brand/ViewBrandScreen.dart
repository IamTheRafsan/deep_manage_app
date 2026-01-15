import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Brand/BrandBloc.dart';
import '../../Bloc/Brand/BrandState.dart';
import '../../Bloc/Brand/BrandEvent.dart';
import '../../Model/Brand/BrandModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'BrandDetailScreen.dart';

class ViewBrandScreen extends StatefulWidget {
  const ViewBrandScreen({super.key});

  @override
  State<ViewBrandScreen> createState() => _ViewBrandScreenState();
}

class _ViewBrandScreenState extends State<ViewBrandScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrandBloc>().add(LoadBrand());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Brands",
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is BrandLoaded) {
            final List<BrandModel> brands = state.brands;

            if (brands.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BrandBloc>().add(LoadBrand());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];

                  return ViewCard(
                    title: brand.name,
                    subtitle: "Code: ${brand.code}",
                    icon: Icons.branding_watermark_outlined,
                    dateText: "${brand.created_date}",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BrandDetailScreen(brandId: brand.id),
                        ),
                      );
                      context.read<BrandBloc>().add(LoadBrand());
                    },
                  );
                },
              ),
            );
          } else if (state is BrandError) {
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
                    "Error Loading Brands",
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
                      context.read<BrandBloc>().add(LoadBrand());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No brands available"),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.branding_watermark_outlined,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Brands Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Create your first brand to get started",
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