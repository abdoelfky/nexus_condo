import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/admin/services/rental_bills/controllers/RentalRepository.dart';

final rentalRepositoryProvider = Provider<RentalRepository>((ref) => RentalRepository());

final unitsProvider = StreamProvider((ref) {
  final repository = ref.watch(rentalRepositoryProvider);
  return repository.fetchUnits();
});

final rentalBillsProvider = StreamProvider((ref) {
  final repository = ref.watch(rentalRepositoryProvider);
  return repository.fetchRentalBills();
});
