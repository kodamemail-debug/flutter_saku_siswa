import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> _transaksi = [];
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();

  void _tambahTransaksi() {
    final judul = _judulController.text;
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;

    if (judul.isEmpty || jumlah <= 0) return;

    setState(() {
      _transaksi.add({
        'judul': judul,
        'jumlah': jumlah,
        'tanggal': DateTime.now(),
      });
    });

    _judulController.clear();
    _jumlahController.clear();
    Navigator.of(context).pop();
  }

  void _tampilkanModalInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tambah Transaksi Baru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Keterangan (misal: Jajan / Uang Saku)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _tambahTransaksi,
              child: const Text('Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPengeluaran = _transaksi.fold(0, (sum, item) => sum + item['jumlah']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Saku Siswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Card Ringkasan Total
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Total Transaksi', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalPengeluaran.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Daftar Transaksi
          Expanded(
            child: _transaksi.isEmpty
                ? const Center(child: Text('Belum ada data transaksi'))
                : ListView.builder(
                    itemCount: _transaksi.length,
                    itemBuilder: (ctx, index) {
                      final item = _transaksi[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.attach_money),
                          ),
                          title: Text(item['judul']),
                          trailing: Text(
                            'Rp ${item['jumlah'].toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanModalInput,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}