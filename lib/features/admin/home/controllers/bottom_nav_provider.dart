// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class BottomNavState {
//   final int selectedIndex;
//
//   BottomNavState({this.selectedIndex = 0});
// }
//
// class BottomNavNotifier extends StateNotifier<BottomNavState> {
//   BottomNavNotifier() : super(BottomNavState());
//
//   void selectIndex(int index) {
//     state = BottomNavState(selectedIndex: index);
//   }
// }
//
// final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, BottomNavState>((ref) {
//   return BottomNavNotifier();
// });
