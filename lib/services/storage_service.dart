import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageService: menangani semua urusan simpan & baca data lokal
/// menggunakan SharedPreferences + serialisasi JSON.
class StorageService {
  static const String _kSaldoKey = 'total_saldo';
  static const String _kRiwayatKey = 'riwayat';

  // 1. Simpan Data ke Memory HP
  Future<void> simpanDataLokal(
    int totalSaldo,
    List<Map<String, dynamic>> riwayat,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_kSaldoKey, totalSaldo);

    // Encode List<Map> menjadi List<String> JSON,
    // karena SharedPreferences hanya bisa menyimpan tipe dasar.
    List<String> dataStringList =
        riwayat.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList(_kRiwayatKey, dataStringList);
  }

  // 2. Muat Data Saat Aplikasi Dibuka
  Future<Map<String, dynamic>> muatDataLokal() async {
    final prefs = await SharedPreferences.getInstance();

    int saldo = prefs.getInt(_kSaldoKey) ?? 0;
    List<String>? dataStringList = prefs.getStringList(_kRiwayatKey);

    List<Map<String, dynamic>> riwayat = [];
    if (dataStringList != null) {
      riwayat = dataStringList
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    }

    return {
      'saldo': saldo,
      'riwayat': riwayat,
    };
  }

  // 3. (Tambahan) Hapus semua data lokal - berguna saat testing/reset
  Future<void> hapusDataLokal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSaldoKey);
    await prefs.remove(_kRiwayatKey);
  }
}
