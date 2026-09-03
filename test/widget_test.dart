import 'package:flutter_test/flutter_test.dart';
import 'package:saku_siswa/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const MyApp());

    // Pastikan judul Dashboard muncul
    expect(find.text('Dashboard Saku Siswa'), findsOneWidget);
  });
}