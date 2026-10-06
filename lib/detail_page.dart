import 'package:flutter/material.dart';
import 'main.dart'; // Import main.dart untuk mengakses variabel global ordersList

// StatefulWidget untuk Halaman Detail Produk Batu Mulia
class DetailPage extends StatefulWidget {
  final String name;
  final String price;
  final String category;
  final String rating;
  final String image;

  const DetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    required this.image,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Controller untuk mengontrol input jumlah kuantitas
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi nilai awal kuantitas pembelian dengan angka 1
    _qtyController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    // Membebaskan memori controller saat widget di-destroy
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: Menyediakan struktur tata letak dasar visual untuk halaman detail
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea: Memastikan konten berada di area layar yang aman
      body: SafeArea(
        // Stack: Menyusun widget secara bertumpuk (Konten Utama + Tombol Back Melayang)
        child: Stack(
          children: [
            // SingleChildScrollView: Memungkinkan halaman dapat di-scroll vertikal
            SingleChildScrollView(
              // Column: Menyusun widget gambar dan rincian produk secara vertikal
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Container: Pembungkus dan pemberi tata letak area gambar produk
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    height: 250,
                    width: double.infinity,
                    // BoxDecoration: Memberikan gaya visual sudut melengkung dan bayangan
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // ClipRRect: Memotong gambar agar mengikuti sudut border melengkung
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      // Pengondisian memuat gambar dari URL/Network atau Asset lokal
                      child: widget.image.startsWith('http')
                      // Image.network: Memuat gambar produk dari internet
                          ? Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                      // Image.asset: Memuat gambar produk dari file aset lokal
                          : Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      ),
                    ),
                  ),

                  // Padding: Memberikan jarak bagian dalam untuk konten teks rincian produk
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    // Column: Menyusun teks informasi produk secara urut dari atas ke bawah
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row: Menyusun kategori produk dan rating secara horizontal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text: Menampilkan nama kategori batu mulia
                            Text(
                              widget.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // Row: Menyusun ikon bintang dan angka rating secara horizontal
                            Row(
                              children: [
                                // Icon: Ikon bintang rating berwarna emas
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                // Text: Menampilkan nilai rating produk
                                Text(
                                  widget.rating,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Text: Menampilkan nama lengkap produk batu mulia
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Text: Menampilkan harga produk batu mulia
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Text: Sub-judul untuk bagian deskripsi produk
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Text: Menampilkan penjelasan rincian keaslian batu mulia
                        Text(
                          'Batu mulia asli bersertifikat resmi. Memiliki pemotongan presisi tinggi dan kilau alami yang memikat. Sangat cocok untuk koleksi maupun perhiasan mewah.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Row: Menyusun label 'Jumlah Pembelian' dan input TextField kuantitas
                        Row(
                          children: [
                            // Text: Label petunjuk input jumlah produk
                            const Text(
                              'Jumlah Pembelian:',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 16),
                            // SizedBox: Mengatur lebar khusus untuk kolom input kuantitas
                            SizedBox(
                              width: 80,
                              // TextField: Input interaktif angka kuantitas yang terikat ke _qtyController
                              child: TextField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Positioned: Mengatur posisi tombol navigasi kembali di pojok kiri atas
            Positioned(
              top: 24,
              left: 24,
              // CircleAvatar: Membentuk wadah lingkaran transparan untuk tombol back
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                // IconButton: Tombol interaktif untuk kembali ke halaman sebelumnya
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Navigator.pop: Mengembalikan pengguna ke halaman katalog
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Container: Bottom bar melayang untuk tombol konfirmasi aksi pembelian
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        // ElevatedButton: Tombol aksi utama untuk menambahkan data ke ordersList global
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // 1. Menambahkan item batu mulia ke list pesanan global
            ordersList.add({
              'name': widget.name,
              'price': widget.price,
              'image': widget.image,
              'quantity': _qtyController.text.isEmpty
                  ? '1'
                  : _qtyController.text,
            });

            // 2. Menampilkan SnackBar pemberitahuan feedback ke pengguna
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berhasil ditambahkan ke pesanan!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          // Text: Label teks pada tombol Beli Sekarang
          child: const Text(
            'Beli Sekarang',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk menampilkan placeholder visual jika gambar gagal dimuat
  Widget _buildPlaceholder() {
    // Container: Wadah berlatar belakang gelap untuk ikon placeholder
    return Container(
      color: const Color(0xFF0F172A),
      // Center: Meletakkan ikon tepat di tengah-tengah container
      child: const Center(
        // Icon: Menampilkan ikon permata sebagai representasi produk batu mulia
        child: Icon(Icons.diamond, size: 80, color: Colors.amberAccent),
      ),
    );
  }
}