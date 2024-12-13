import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/help/controllers/help_notifier.dart';
import 'package:nexus_condo/features/help/data/complaintModel.dart';
import 'package:nexus_condo/features/help/controllers/faq_provider.dart'; // Import FAQ Provider

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _unitNoController = TextEditingController();
  final _complaintController = TextEditingController();

  List<bool> _isExpanded = [];

  @override
  Widget build(BuildContext context) {
    final helpNotifier = ref.read(helpProvider);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Help & Complaints',
      ),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Submit Your Complaint',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number', isPhone: true),
                    const SizedBox(height: 16),
                    _buildTextField(_unitNoController, 'Unit Number', isNumeric: true),
                    const SizedBox(height: 16),
                    _buildTextField(_complaintController, 'Your Complaint', maxLines: 5),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Submit',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final complaint = Complaint(
                            id: '',
                            name: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                            unitNo: _unitNoController.text.trim(),
                            message: _complaintController.text.trim(),
                            createdAt: DateTime.now(),
                          );

                          final success = await helpNotifier.submitComplaint(complaint);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Complaint submitted successfully!')),
                            );
                            _formKey.currentState?.reset();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to submit complaint.')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
               SizedBox(height: Dimensions.paddingSizeLarge),
              const Text(
                'Common Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeLarge),

              _buildFaqSection(), // FAQ Section
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    final faqAsyncValue = ref.watch(faqProvider);

    return faqAsyncValue.when(
      data: (faqs) {
        // Initialize _isExpanded for the first load
        if (_isExpanded.length != faqs.length) {
          _isExpanded = List.filled(faqs.length, false);
        }

        return ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _isExpanded[index] = !_isExpanded[index];
              print(_isExpanded[index]);

            });
          },
          children: faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            return ExpansionPanel(
              backgroundColor: AppColors.backgroundColor,
              headerBuilder: (context, isExpanded) {
                return GestureDetector(
                  onTap: ()
                  {
                    setState(() {
                      _isExpanded[index] = !_isExpanded[index];
                      print(_isExpanded[index]);

                    });
                  },
                  child: ListTile(
                    title: Text(
                      faq['question'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faq['answer'],
                  style: const TextStyle(color: AppColors.secondaryTextColor),
                ),
              ),
              isExpanded: _isExpanded[index],
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox(),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load FAQs: $error',
          style: const TextStyle(color: AppColors.errorColor),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPhone = false, bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType.phone
          : isNumeric
          ? TextInputType.number
          : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.primaryTextColor),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primaryTextColor),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.successColor, width: 2.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        hintStyle: const TextStyle(color: AppColors.whiteTextColor),
      ),
    );
  }
}
