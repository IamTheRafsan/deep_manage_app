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
import 'ViewBrandScreen.dart';

class AddBrandScreen extends StatefulWidget {
  const AddBrandScreen({super.key});

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Brand",
      body: BlocConsumer<BrandBloc, BrandState>(
        listener: (context, state) {
          if (state is BrandCreated) {
            SuccessSnackBar.show(context, message: "Brand Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewBrandScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is BrandError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
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
                    onPressed: _isLoading ? null : _createBrand,
                    text: _isLoading ? 'Creating...' : 'Create Brand',
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

  Future<void> _createBrand() async {
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
    final brandData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<BrandBloc>().add(CreateBrand(brandData));
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