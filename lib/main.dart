import 'package:flutter/material.dart';
import 'package:saku_siswa/views/dashboard_screen.dart'; // Import halaman dashboard[cite: 1]

void main() {
  runApp(const SakuSiswaApp()); //[cite: 1]
}

class SakuSiswaApp extends StatelessWidget {
  const SakuSiswaApp({super.key}); //[cite: 1]

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //[cite: 1]
      title: 'SakuSiswa', //[cite: 1]
      theme: ThemeData(
        useMaterial3: true, //[cite: 1]
        colorSchemeSeed: Colors.teal, //[cite: 1]
      ),
      home: const DashboardScreen(), // Memanggil DashboardScreen dari file terpisah[cite: 1]
    );
  }
}