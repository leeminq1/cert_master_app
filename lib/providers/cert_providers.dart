import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

final allCertsProvider = StreamProvider<List<Cert>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.certDao.watchAllCerts();
});

final certByIdProvider =
    FutureProvider.family<Cert?, String>((ref, certId) async {
  final db = ref.watch(databaseProvider);
  return db.certDao.getCertById(certId);
});

final certProgressProvider =
    FutureProvider.family<int, String>((ref, certId) async {
  final db = ref.watch(databaseProvider);
  return db.qStateDao.countCompletedByCert(certId);
});
