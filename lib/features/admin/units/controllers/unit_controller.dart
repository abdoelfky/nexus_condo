import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/admin/units/controllers/unit_repo.dart';
import 'package:nexus_condo/features/admin/units/data/unit.dart';


final unitRepositoryProvider = Provider<UnitRepository>(
      (ref) => UnitRepository(FirebaseFirestore.instance),
);

final unitsProvider = FutureProvider<List<Unit>>((ref) async {
  final repository = ref.watch(unitRepositoryProvider);
  return await repository.fetchUnits();
});

