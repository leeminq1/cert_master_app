import 'dart:convert';
import 'package:flutter/services.dart';
import '../database/app_database.dart';
import '../models/cert_json.dart';

const _certFiles = [
  ('forklift',       'assets/data/forklift.json'),
  ('excavator',      'assets/data/excavator.json'),
  ('welding',        'assets/data/welding.json'),
  ('auto_mechanic',  'assets/data/auto_mechanic.json'),
  ('auto_func',      'assets/data/auto_func.json'),
  ('hazmat',         'assets/data/hazmat.json'),
  ('hazmat_func',    'assets/data/hazmat_func.json'),
  ('gas',            'assets/data/gas.json'),
  ('fire_mech',      'assets/data/fire_mech.json'),
  ('fire_elec',      'assets/data/fire_elec.json'),
  ('electric_eng',   'assets/data/electric_eng.json'),
  ('electric_ind',   'assets/data/electric_ind.json'),
  ('electric_func',  'assets/data/electric_func.json'),
  ('electronics',    'assets/data/electronics.json'),
  ('elevator',       'assets/data/elevator.json'),
  ('hvac',           'assets/data/hvac.json'),
  ('cooking',        'assets/data/cooking.json'),
  ('bread',          'assets/data/bread.json'),
  ('confection',     'assets/data/confection.json'),
  ('it_func',        'assets/data/it_func.json'),
  ('computer',       'assets/data/computer.json'),
  ('career',         'assets/data/career.json'),
  ('landscape',      'assets/data/landscape.json'),
];

Future<void> seedIfEmpty(AppDatabase db) async {
  final count = await db.certDao.countCerts();
  if (count >= _certFiles.length) return;

  for (final (certId, path) in _certFiles) {
    try {
      final jsonStr = await rootBundle.loadString(path);
      final data = CertJson.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      await db.certDao.insertCert(data.toCompanion());
      await db.questionDao.insertQuestions(
        data.items.map((q) => q.toCompanion(certId)).toList(),
      );
    } catch (e, st) {
      // ignore: avoid_print
      print('SEED ERROR [$certId]: $e\n$st');
    }
  }

  await db.settingsDao.set('seeded', '1');
}
