import 'package:flutter/material.dart';

class MonoxideInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Karbon Monoksida (CO)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Karbon Monoksida (CO)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Karbon monoksida adalah gas yang tak berwarna, tak berbau, dan tak berasa. Ia terdiri dari satu atom karbon yang secara kovalen berikatan dengan satu atom oksigen. Dalam ikatan ini, terdapat dua ikatan kovalen dan satu ikatan kovalen koordinasi antara atom karbon dan oksigen.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Pembentukan dan Penggunaan:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Karbon monoksida dihasilkan dari pembakaran tak sempurna dari senyawa karbon, sering terjadi pada mesin pembakaran dalam.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Karbon monoksida terbentuk apabila terdapat kekurangan oksigen dalam proses pembakaran. Ia mudah terbakar dan menghasilkan lidah api berwarna biru, menghasilkan karbon dioksida.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Peran dalam Teknologi Modern:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Walaupun bersifat racun, CO memainkan peran penting dalam teknologi modern sebagai prekursor banyak senyawa karbon.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context); // Tutup halaman saat tombol ditekan
            //   },
            //   child: Text('Kembali'),
            // ),
          ],
        ),
      ),
    );
  }
}
