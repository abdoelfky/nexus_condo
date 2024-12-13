import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/PrimaryTextFormField.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/add_unit/controllers/add_unit_controller.dart';

class AddUnitScreen extends ConsumerStatefulWidget {
  const AddUnitScreen({Key? key}) : super(key: key);

  @override
  _AddUnitScreenState createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends ConsumerState<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitNumberController = TextEditingController();
  final _spaceController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _detailsController = TextEditingController();
  final _pricePerMonthController = TextEditingController();
  final _pricePerYearController = TextEditingController();

  final List<File> _images = [];

  @override
  void dispose() {
    _unitNumberController.dispose();
    _spaceController.dispose();
    _roomNumberController.dispose();
    _detailsController.dispose();
    _pricePerMonthController.dispose();
    _pricePerYearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_images.length >= 8) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_images.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Please upload at least one image'),
  //           backgroundColor: AppColors.errorColor),
  //     );
  //     return;
  //   }
  //
  //   final addUnitController = ref.read(addUnitControllerProvider.notifier);
  //   Future<String> _uploadImage(File image) async {
  //     try {
  //       final storageRef = FirebaseStorage.instance
  //           .ref()
  //           .child('units/${DateTime.now().millisecondsSinceEpoch}');
  //       final uploadTask = await storageRef.putFile(image);
  //       return await storageRef.getDownloadURL();
  //     } catch (e) {
  //       throw Exception('Failed to upload image: $e');
  //     }
  //   }
  //
  //   try {
  //     // Upload images and get their URLs
  //     final List<String> imageUrls = [];
  //     for (final image in _images) {
  //       final url = await _uploadImage(image);
  //       imageUrls.add(url);
  //     }
  //
  //     // Save unit details along with image URLs
  //     await addUnitController.addUnit(
  //       unitNo: _unitNumberController.text.trim(),
  //       unitDetails: _detailsController.text.trim(),
  //       unitRoomNo: _roomNumberController.text.trim(),
  //       unitPricePerY: _pricePerYearController.text.trim(),
  //       unitPricePerM: _pricePerMonthController.text.trim(),
  //       unitSpace: _spaceController.text.trim(),
  //       imageUrls: imageUrls, // Pass URLs instead of file paths
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Unit added successfully'),
  //           backgroundColor: AppColors.successColor),
  //     );
  //
  //     // Clear fields
  //     _unitNumberController.clear();
  //     _spaceController.clear();
  //     _roomNumberController.clear();
  //     _detailsController.clear();
  //     _pricePerMonthController.clear();
  //     _pricePerYearController.clear();
  //     setState(() {
  //       _images.clear();
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Error: ${e.toString()}'),
  //           backgroundColor: AppColors.errorColor),
  //     );
  //   }
  // }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image'),backgroundColor: AppColors.errorColor,),
      );
      return;
    }

    final addUnitController = ref.read(addUnitControllerProvider.notifier);

    try {
      // Convert image files to URLs (you'll need to implement the upload logic)
      final imageUrls = _images.map((image) => image.path).toList();

      await addUnitController.addUnit(
        unitNo: _unitNumberController.text.trim(),
        unitDetails: _detailsController.text.trim(),
        unitRoomNo: _roomNumberController.text.trim(),
        unitPricePerY: _pricePerYearController.text.trim(),
        unitPricePerM: _pricePerMonthController.text.trim(),
        unitSpace: _spaceController.text.trim(),
        imageUrls: imageUrls,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit added successfully'),backgroundColor: AppColors.successColor),
      );

      // Clear fields
      _unitNumberController.clear();
      _spaceController.clear();
      _roomNumberController.clear();
      _detailsController.clear();
      _pricePerMonthController.clear();
      _pricePerYearController.clear();
      setState(() {
        _images.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'),backgroundColor: AppColors.errorColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addUnitControllerProvider);

    return Scaffold(
      appBar: PrimaryAppBar(title: 'Add Unit'),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: Dimensions.imgHeightLarge,
                      width: Dimensions.imgWidthLarge,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: _images.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(_images.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _images.isEmpty
                          ? const Icon(Icons.add_photo_alternate, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: Dimensions.fontSizeDefault),
                  if (_images.isNotEmpty)
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  Text('${_images.length} / 8'),
                  if (_images.length < 8)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.nexusGreen,
                        // Green color at the botton
                        borderRadius: BorderRadius.circular(15),
                        // Match button border radius
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.nexusShadowGreen, // Shadow color
                            offset: Offset(0, 5), // Shadow position (bottom)
                            blurRadius: 2, // Shadow blur radius
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          // Make button background transparent
                          elevation: 0,
                          // Remove default button elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15), // Match border radius
                          ),
                          minimumSize: Size(Dimensions.paddingSizeExtraLarge,
                              50), // Same width as TextFormField
                        ),
                        child: const Text(
                          'Add More Images',
                          style: TextStyle(color: AppColors.whiteTextColor),
                        ),
                      ),
                    ),
                  const SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _unitNumberController,
                      label: 'Unit Number',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter an Unit Number'
                          : null,
                      prefixIcon: Icons.numbers_outlined,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _spaceController,
                      label: 'Space',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a Space number'
                          : null,
                      prefixIcon: Icons.format_line_spacing_rounded,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _roomNumberController,
                      label: 'rooms',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a rooms count'
                          : null,
                      prefixIcon: Icons.meeting_room_rounded,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _detailsController,
                      label: 'details',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a unit details'
                          : null,
                      prefixIcon: Icons.house_outlined,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _pricePerMonthController,
                      label: 'Price Per Month',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter The Price Per Month'
                          : null,
                      prefixIcon: Icons.currency_pound_outlined,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: PrimaryTextFormField(
                      controller: _pricePerYearController,
                      label: 'Price Per Year',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter The Price Per Year'
                          : null,
                      prefixIcon: Icons.currency_pound_outlined,
                    ),
                  ),
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Add Unit',
                            onPressed: _submit,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
