import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Brand/BrandBloc.dart';
import '../../Bloc/Brand/BrandEvent.dart';
import '../../Bloc/Brand/BrandState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';

class UpdateBrandScreen extends StatefulWidget {
  final String brandId;

  const UpdateBrandScreen({super.key, required this.brandId});

  @override
  State<UpdateBrandScreen> createState() => _UpdateBrandScreenState();
}

class _UpdateBrandScreenState extends State<UpdateBrandScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<BrandBloc>().add(LoadBrandById(widget.brandId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Brand",
      body: BlocConsumer<BrandBloc, BrandState>(
        listener: (context, state) {
          if (state is BrandLoadedSingle && !_initialDataLoaded) {
            final brand = state.brand;
            _nameController.text = brand.name;
            _codeController.text = brand.code;
            _initialDataLoaded = true;
          }

          if (state is BrandUpdated) {
            SuccessSnackBar.show(context, message: "Brand Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is BrandError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is BrandLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading brand data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Brand Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _nameController,
                  label: 'Brand Name *',
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _codeController,
                  label: 'Brand Code *',
                ),
                const SizedBox(height: 8),
                Text(
                  "Note: Brand code must be unique",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _updateBrand,
                    text: _isLoading ? 'Updating...' : 'Update Brand',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateBrand() async {
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (_codeController.text.trim().isEmpty) {
      WarningSnackBar.show(context, message: "Brand code cannot be empty");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<BrandBloc>().add(UpdateBrand(widget.brandId, updatedData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}