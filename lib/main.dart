import 'package:flutter/material.dart';

void main() {
  // Widget utama untuk menjalankan aplikasi Flutter
  runApp(const MyApp());
}

// Widget StatelessWidget sebagai root utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp menyediakan konfigurasi tema dan navigasi aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Batu Mulia',
      // ThemeData mengatur konfigurasi tema warna
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: false,
      ),
      // Home mengarahkan ke halaman utama (MainPage)
      home: const MainPage(),
    );
  }
}

// Model data Batu Mulia untuk struktur objek produk
class Gemstone {
  final String id;
  final String name;
  final String category;
  final String rating;
  final int price;
  final String image;
  int quantity;

  Gemstone({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

// Widget StatefulWidget untuk mengelola state halaman & keranjang belanja
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // State indeks tab navigasi bawah

  // List data produk batu mulia
  final List<Gemstone> _products = [
    Gemstone(
      id: '1',
      name: 'Batu Zamrud (Emerald)',
      category: 'Batu Permata',
      rating: '4.9',
      price: 15000000,
      image: 'assets/Zamrud_green.jpeg',
    ),
    Gemstone(
      id: '2',
      name: 'Batu Safir Biru (Blue Sapphire)',
      category: 'Batu Permata',
      rating: '4.8',
      price: 12500000,
      image: 'assets/safirblue.jpeg', // Diberi titik pada ekstensi .jpeg
    ),
    Gemstone(
      id: '3',
      name: 'Batu Ruby Merah Delima',
      category: 'Batu Permata',
      rating: '5.0',
      price: 18000000,
      image: 'assets/red_ruby.jpeg',
    ),
  ];

  // List keranjang belanja
  final List<Gemstone> _cartItems = [];

  // Fungsi menambah produk ke keranjang
  void _addToCart(Gemstone product) {
    setState(() {
      int index = _cartItems.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(
          Gemstone(
            id: product.id,
            name: product.name,
            category: product.category,
            rating: product.rating,
            price: product.price,
            image: product.image,
            quantity: 1,
          ),
        );
      }
    });

    // Widget ScaffoldMessenger untuk menampilkan notifikasi SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} dimasukkan ke keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Fungsi menambah kuantitas item
  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  // Fungsi mengurangi kuantitas item
  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  // Getter menghitung total harga keranjang
  int get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Fungsi checkout berpindah ke halaman sukses
  void _checkout() {
    if (_cartItems.isEmpty) return;

    int total = _totalPrice;

    // Navigator untuk navigasi ke SuccessPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(
          totalAmount: total,
          onReset: () {
            setState(() {
              _cartItems.clear();
              _selectedIndex = 0;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List berisi tampilan tiap tab aplikasi
    final List<Widget> pages = [
      BerandaPage(products: _products, onAddToCart: _addToCart),
      KeranjangPage(
        cartItems: _cartItems,
        totalPrice: _totalPrice,
        onIncrement: _incrementQuantity,
        onDecrement: _decrementQuantity,
        onCheckout: _checkout,
      ),
      const ProfilPage(),
    ];

    // Widget Scaffold menyediakan struktur dasar layout (body & bottom nav)
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      // Widget SafeArea memastikan konten berada di area aman layar
      body: SafeArea(child: pages[_selectedIndex]),
      // Widget BottomNavigationBar untuk menu navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0F172A),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          // Widget BottomNavigationBarItem untuk tab Beranda
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          // Widget BottomNavigationBarItem untuk tab Keranjang
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          // Widget BottomNavigationBarItem untuk tab Profil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. HALAMAN BERANDA
// -----------------------------------------------------------------------------
class BerandaPage extends StatelessWidget {
  final List<Gemstone> products;
  final Function(Gemstone) onAddToCart;

  const BerandaPage({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Widget Column menyusun elemen secara vertikal
    return Column(
      children: [
        // Widget Padding memberi jarak di sekitar TextField
        Padding(
          padding: const EdgeInsets.all(12.0),
          // Widget TextField untuk pencarian
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Batu Mulia...',
              prefixIcon: const Icon(Icons.search), // Widget Icon pencarian
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Widget Expanded mengisi sisa ruang layar
        Expanded(
          // Widget ListView.builder untuk membuat daftar scrollable
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              // Widget Container sebagai kartu tempat produk
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                // Widget Row menyusun gambar dan detail produk secara horizontal
                child: Row(
                  children: [
                    // Widget ClipRRect untuk membuat sudut gambar melengkung
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // Widget Image.asset menampilkan gambar dari assets
                      child: Image.asset(
                        product.image,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      ),
                    ),
                    const SizedBox(width: 12), // Widget SizedBox memberi jarak horizontal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Widget Text untuk nama produk
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          // Widget Text untuk harga produk
                          Text(
                            'Rp${product.price}',
                            style: const TextStyle(
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Widget ElevatedButton tombol tambah ke keranjang
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              minimumSize: const Size(double.infinity, 32),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => onAddToCart(product),
                            child: const Text(
                              'Masukkan Keranjang',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget pembantu jika gambar aset gagal dimuat
  Widget _buildPlaceholder() {
    return Container(
      width: 75,
      height: 75,
      color: const Color(0xFF0F172A),
      child: const Icon(Icons.diamond, color: Colors.amberAccent),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. HALAMAN KERANJANG
// -----------------------------------------------------------------------------
class KeranjangPage extends StatelessWidget {
  final List<Gemstone> cartItems;
  final int totalPrice;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final VoidCallback onCheckout;

  const KeranjangPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari di keranjang...',
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: cartItems.isEmpty
              ? const Center(
            // Widget Center untuk menempatkan pesan kosong di tengah
            child: Text('Keranjang Belanja Kosong'),
          )
              : ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.image,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp${item.price}',
                            style: const TextStyle(color: Color(0xFF0D9488)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Widget IconButton tombol kurangi kuantitas
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 22),
                          onPressed: () => onDecrement(index),
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Widget IconButton tombol tambah kuantitas
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 22),
                          onPressed: () => onIncrement(index),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Container area bar bagian bawah keranjang
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    'Rp$totalPrice',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              // Widget ElevatedButton tombol Checkout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: cartItems.isEmpty ? null : onCheckout,
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 65,
      height: 65,
      color: const Color(0xFF0F172A),
      child: const Icon(Icons.diamond, color: Colors.amberAccent),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. HALAMAN PROFIL
// -----------------------------------------------------------------------------
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Widget CircleAvatar foto profil lingkaran
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF0F172A),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Muhammad Revaldo Setya Gunawan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'NIM: 2309106124',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          Text(
            'Informatika - Universitas Mulawarman',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          // Widget Divider garis pemisah horizontal
          const Divider(),
          const SizedBox(height: 10),
          // Widget Card kontainer email
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // Widget ListTile format list dengan ikon
            child: const ListTile(
              leading: Icon(Icons.email, color: Color(0xFF0F172A)),
              title: Text('Email'),
              subtitle: Text('revaldo@mhs.unmul.ac.id'),
            ),
          ),
          // Widget Card kontainer praktikum
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const ListTile(
              leading: Icon(Icons.class_, color: Color(0xFF0F172A)),
              title: Text('Praktikum'),
              subtitle: Text('Pemrograman Bergerak - Modul 4'),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. HALAMAN SUKSES CHECKOUT
// -----------------------------------------------------------------------------
class SuccessPage extends StatelessWidget {
  final int totalAmount;
  final VoidCallback onReset;

  const SuccessPage({
    super.key,
    required this.totalAmount,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold menyediakan struktur latar belakang halaman
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      // Widget Center menempatkan konten di tengah layar
      body: Center(
        // Widget Padding memberi jarak tepi
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Widget Column menyusun elemen secara vertikal
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Widget CircleAvatar ikon centang sukses
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF0F172A),
                child: Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Widget Text label total
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Widget Text nominal angka total bayar
              Text(
                'Rp$totalAmount',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 32),
              // Widget SizedBox pengatur lebar tombol
              SizedBox(
                width: double.infinity,
                // Widget ElevatedButton tombol kembali ke beranda
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    onReset();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kembali',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}