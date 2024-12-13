import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/home/presentation/widgets/custom_app_bar.dart';

import 'data/Info.dart';

class InfoScreen extends StatefulWidget {
  final String? title;
  final String? data;

  InfoScreen({Key? key, required this.data, required this.title})
      : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<InfoModel> _loadInfoData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('info')
          .doc(widget.data)
          .get();

      InfoModel body = InfoModel.fromMap(doc.data() as Map<String, dynamic>);
      return body;
    } catch (error) {
      // Handle Firestore read error here
      print('Firestore read error: $error');
      throw error; // Rethrow the error to be caught by FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PrimaryAppBar(title: widget.title ?? 'INFO'),
      body: BackgroundScreen(
        child: FutureBuilder<InfoModel>(
          future: _loadInfoData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              InfoModel body = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section (if available)
                    if (widget.title != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: Text(
                          widget.title!,
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: Dimensions.fontSizeExtraLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Content Body Section
                    ...body.body.map((text) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: Text(
                          text!,
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                          textDirection: TextDirection.ltr,
                          softWrap: true,
                        ),
                      );
                    }).toList(),

                    // Divider for extra separation
                    Divider(
                      color: AppColors.primaryTextColor.withOpacity(0.2),
                      thickness: 1,
                    ),

                    // You can add a footer or additional content here, if needed
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
