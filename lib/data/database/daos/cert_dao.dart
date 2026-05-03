import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'cert_dao.g.dart';

@DriftAccessor(tables: [Certs])
class CertDao extends DatabaseAccessor<AppDatabase> with _$CertDaoMixin {
  CertDao(super.db);

  Future<List<Cert>> getAllCerts() => select(certs).get();

  Stream<List<Cert>> watchAllCerts() => select(certs).watch();

  Future<Cert?> getCertById(String certId) =>
      (select(certs)..where((t) => t.certId.equals(certId))).getSingleOrNull();

  Future<int> countCerts() async {
    final count = await customSelect(
      'SELECT COUNT(*) as c FROM certs',
      readsFrom: {certs},
    ).getSingle();
    return count.read<int>('c');
  }

  Future<void> insertCert(CertsCompanion cert) =>
      into(certs).insertOnConflictUpdate(cert);
}
