import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/auth/controllers/toggle_index_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
} // Control visibility of password field

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    {
      return Scaffold(
        body: BackgroundScreen(
          child: SingleChildScrollView(
            child: Column(
              children: [],
            ),
          ),
        ),
      );
    }
  }
}
