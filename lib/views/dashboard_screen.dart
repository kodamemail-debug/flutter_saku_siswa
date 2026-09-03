import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StorageService _storageService = StorageService();

  // Saldo awal default jika belum pernah menyimpan data sebelumnya
  static const int _saldoAwalDefault = 50000;

  int _saldo = _saldoAwalDefault;
  List<Map<String, dynamic>> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  // Ambil data tersimpan saat aplikasi pertama kali dibuka
  Future<void> _muatData() async {
    final data = await _storageService.muatDataLokal();
    setState(() {
      // Kalau belum pernah ada data tersimpan, pakai saldo awal default
      final saldoTersimpan = data['saldo'] as int;
      _saldo = saldoTersimpan == 0 && (data['riwayat'] as List).isEmpty
          ? _saldoAwalDefault
          : saldoTersimpan;
      _riwayat = List<Map<String, dynamic>>.from(data['riwayat']);
      _isLoading = false;
    });
  }

  // Tambah 1 transaksi pengeluaran baru, lalu simpan ke lokal
  void _tambahPengeluaran(String judul, int nominal) {
    if (judul.trim().isEmpty || nominal <= 0) return;

    setState(() {
      _saldo -= nominal;
      _riwayat.insert(0, {
        'judul': judul,
        'nominal': nominal,
        'tanggal': DateTime.now().toIso8601String(),
      });
    });

    // setState() di atas memberi tahu Flutter untuk re-render UI,
    // lalu kita persist perubahan itu ke SharedPreferences.
    _storageService.simpanDataLokal(_saldo, _riwayat);
  }

  void _tampilkanModalInput() {
    final judulController = TextEditingController();
    final nominalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tambah Pengeluaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Keterangan Pengeluaran',
              ),
            ),
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final judul = judulController.text;
                  final nominal = int.tryParse(nominalController.text) ?? 0;
                  _tambahPengeluaran(judul, nominal);
                  Navigator.pop(ctx);
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('SakuSiswa')),
      body: Column(
        children: [
          // Kartu ringkasan saldo
          Card(
            margin: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Sisa Saldo'),
                  const SizedBox(height: 4),
                  Text(
                    'Rp $_saldo',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Daftar riwayat transaksi
          Expanded(
            child: _riwayat.isEmpty
                ? const Center(child: Text('Belum ada pengeluaran'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _riwayat.length,
                    itemBuilder: (context, index) {
                      final item = _riwayat[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.remove_circle_outline),
                          title: Text(item['judul']),
                          trailing: Text('- Rp ${item['nominal']}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tampilkanModalInput,
        child: const Icon(Icons.add),
      ),
    );
  }
}
