import 'package:flutter/material.dart';

class MethaneInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Metana (CH₄)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metana (CH₄)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Metana adalah hidrokarbon paling sederhana yang berbentuk gas dengan rumus kimia CH₄. '
              'Metana murni tidak berbau, tetapi jika digunakan untuk keperluan komersial, biasanya ditambahkan sedikit bau belerang untuk mendeteksi kebocoran yang mungkin terjadi.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Sifat-sifat Penting:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Metana adalah komponen utama gas alam dan merupakan sumber bahan bakar utama.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. Pembakaran satu molekul metana dengan oksigen akan melepaskan satu molekul CO₂ (karbondioksida) dan dua molekul H₂O (air):',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '   CH₄ + 2O₂ → CO₂ + 2H₂O',
              style: TextStyle(fontSize: 18, fontFamily: 'monospace'),
            ),
            SizedBox(height: 20),
            Text(
              '3. Metana merupakan salah satu gas rumah kaca dengan konsentrasi di atmosfer yang meningkat seiring waktu:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '   - Konsentrasi metana pada tahun 1998: 1.745 nmol/mol',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '   - Konsentrasi metana pada tahun 2008: 1.800 nmol/mol',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context); // Close the page when button is pressed
            //   },
            //   child: Text('Kembali'),
            // ),
          ],
        ),
      ),
    );
  }
}
