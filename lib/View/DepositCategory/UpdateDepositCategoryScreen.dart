import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryBloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryEvent.dart';
import '../../Bloc/DepositCategory/DepositCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';

class UpdateDepositCategoryScreen extends StatefulWidget {
  final String depositCategoryId;

  const UpdateDepositCategoryScreen({super.key, required this.depositCategoryId});

  @override
  State<UpdateDepositCategoryScreen> createState() => _UpdateDepositCategoryScreenState();
}

class _UpdateDepositCategoryScreenState extends State<UpdateDepositCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<DepositCategoryBloc>().add(LoadDepositCategoryById(widget.depositCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Deposit Category",
      body: BlocConsumer<DepositCategoryBloc, DepositCategoryState>(
        listener: (context, state) {
          if (state is DepositCategoryLoadedSingle && !_initialDataLoaded) {
            final category = state.depositCategory;
            _nameController.text = category.name;
            _initialDataLoaded = true;
          }

          if (state is DepositCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Deposit Category Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is DepositCategoryError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is DepositCategoryLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading category data...",
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
                  "Deposit Category Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _nameController,
                  label: 'Category Name *',
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _updateDepositCategory,
                    text: _isLoading ? 'Updating...' : 'Update Category',
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

  Future<void> _updateDepositCategory() async {
    if (_nameController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter category name");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<DepositCategoryBloc>().add(UpdateDepositCategory(widget.depositCategoryId, updatedData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}