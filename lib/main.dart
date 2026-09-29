import 'package:flutter/material.dart';
import 'detail_page.dart';

// List Global untuk menyimpan item pesanan yang dibeli dari detail page
List<Map<String, String>> ordersList = [];

void main() {
  // Entry point aplikasi Flutter
  runApp(
    // MaterialApp sebagai widget utama pembungkus aplikasi
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(), // Menjadikan MainNavigation sebagai halaman awal
    ),
  );
}

// StatefulWidget untuk mengelola navigasi BottomNavigationBar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Index untuk menandai tab yang sedang aktif
  int _selectedIndex = 0;

  // List kumpulan halaman yang dipanggil berdasarkan _selectedIndex
  final List<Widget> _pages = const [
    CatalogPage(), // Index 0: Katalog
    PesananPage(), // Index 1: Pesanan
    ProfilPage(),  // Index 2: Profil Saya
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai wadah utama layout halaman
    return Scaffold(
      // Body menampilkan widget halaman sesuai tab yang dipilih
      body: _pages[_selectedIndex],
      // BottomNavigationBar untuk navigasi antarhalaman
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Mengubah index aktif dan merender ulang UI saat tab diklik
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1E293B),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 1. HALAMAN KATALOG
// =========================================================================
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  // Data dummy item batu mulia
  final List<Map<String, String>> gems = const [
    {
      'name': 'Batu Zamrud Colombia',
      'price': 'Rp 15.000.000',
      'category': 'Natural Emerald',
      'rating': '4.9',
      'image': 'assets/Zamrud_green.jpeg',
    },
    {
      'name': 'Batu Safir Biru Ceylon',
      'price': 'Rp 22.500.000',
      'category': 'Royal Blue Sapphire',
      'rating': '5.0',
      'image': 'assets/safirblue_jpeg',
    },
    {
      'name': 'Batu Delima Burma',
      'price': 'Rp 18.000.000',
      'category': 'Pigeon Blood Ruby',
      'rating': '4.9',
      'image': 'assets/red_ruby.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar bagian atas halaman katalog
      appBar: AppBar(
        title: const Text(
          'Katalog Batu Mulia',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      // SingleChildScrollView agar konten halaman dapat di-scroll
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField untuk pencarian produk
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari batu mulia...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Text judul sub-kategori
              const Text(
                'Koleksi Eksklusif',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // ListView.builder untuk merender daftar item batu mulia secara dinamis
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gems.length,
                itemBuilder: (context, index) {
                  final gem = gems[index];
                  final String imagePath = gem['image']!;

                  // Container pembungkus kartu item
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // InkWell memberi efek sentuhan dan event onTap
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Navigator.push untuk berpindah ke DetailPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              name: gem['name']!,
                              price: gem['price']!,
                              category: gem['category']!,
                              rating: gem['rating']!,
                              image: imagePath,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          // Stack menumpuk badge rating di atas gambar
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  imagePath,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        gem['rating']!,
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Expanded mengisi sisa ruang secara fleksibel
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gem['category']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  gem['name']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  gem['price']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0D9488),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pendukung untuk gambar placeholder jika gambar gagal dimuat
  Widget _buildPlaceholder() {
    return Container(
      width: 110,
      height: 110,
      color: Colors.grey.shade200,
      child: const Icon(Icons.diamond, size: 50, color: Color(0xFF1E293B)),
    );
  }
}

// =========================================================================
// 2. HALAMAN PESANAN
// =========================================================================
class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar Halaman Pesanan
      appBar: AppBar(
        title: const Text(
          'Daftar Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      // Kondisi ternary: Menampilkan pesan kosong atau daftar pesanan jika ada
      body: ordersList.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Color(0xFF1E293B),
              ),
              SizedBox(height: 16),
              Text(
                'Belum Ada Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Pesanan koleksi batu mulia Anda akan ditampilkan di halaman ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          final order = ordersList[index];
          // Card untuk menampilkan kontainer berbentuk kartu pesanan
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // ListTile membuat tata letak rapi dengan leading, title, subtitle, dan trailing
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  order['image'] ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.diamond, color: Color(0xFF1E293B)),
                  ),
                ),
              ),
              title: Text(
                order['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Jumlah: ${order['quantity']}x'),
                  const SizedBox(height: 2),
                  Text(
                    order['price'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Berhasil',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// 3. HALAMAN PROFIL
// =========================================================================
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai wadah utama halaman profil
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar bagian atas halaman profil
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      // SingleChildScrollView agar konten bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // CircleAvatar untuk foto/ikon profil bundar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Text nama lengkap
            const Text(
              'Muhammad Revaldo Setya Gunawan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Text program studi
            Text(
              'Informatika - Universitas Mulawarman',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            // Card pembungkus informasi detail akun
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.badge, color: Color(0xFF1E293B)),
                    title: Text('NIM'),
                    subtitle: Text('2309106124'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF1E293B)),
                    title: Text('Email'),
                    subtitle: Text('praktikan@informatika.unmul.ac.id'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Color(0xFF1E293B)),
                    title: Text('Lokasi'),
                    subtitle: Text('Samarinda, Kalimantan Timur'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}