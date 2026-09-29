import 'package:flutter/material.dart';
import 'main.dart'; // Import main.dart agar variabel ordersList dapat diakses

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
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    _qtyController.dispose(); // Membebaskan memori controller saat widget di-destroy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // TAMPILAN GAMBAR
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    height: 250,
                    width: double.infinity,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: widget.image.startsWith('http')
                          ? Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      )
                          : Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Batu mulia asli bersertifikat resmi. Memiliki pemotongan presisi tinggi dan kilau alami yang memikat. Sangat cocok untuk koleksi maupun perhiasan mewah.',
                          style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Jumlah Pembelian:',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
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

            // Tombol Back
            Positioned(
              top: 24,
              left: 24,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E293B),
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
              'quantity': _qtyController.text.isEmpty ? '1' : _qtyController.text,
            });

            // 2. Menampilkan SnackBar pemberitahuan
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berhasil ditambahkan ke pesanan!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text(
            'Beli Sekarang',
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF0F172A),
      child: const Center(
        child: Icon(Icons.diamond, size: 80, color: Colors.amberAccent),
      ),
    );
  }
}