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
    StreamProvider.family<int, String>((ref, certId) {
  final db = ref.watch(databaseProvider);
  // qState 행이 있는 문항 수 = 열람·채점·다음 버튼 모두 포함
  return db.qStateDao.watchAllForCert(certId).map((states) => states.length);
});
