import 'package:get/get.dart';

class HomeController extends GetxController {
  // State reaktif untuk badge jumlah barang di keranjang.
  final cartCount = 0.obs;

  // Kategori yang sedang dipilih pada halaman Home.
  final selectedCategory = 'Semua'.obs;

  // Set menyimpan ID produk favorit agar tidak ada duplikasi.
  final favoriteIds = <String>{}.obs;

  final List<String> categories = const [
    'Semua',
    'Lifestyle',
    'Running',
    'Basketball',
    'Skate',
    'Casual',
  ];

  // Data katalog sementara. Format field dipertahankan agar kompatibel
  // dengan ProductCard dan DetailView dari starter kit.
  final List<Map<String, dynamic>> products = const [
    {
      'id': 'nike-air-jordan-1-retro-high',
      'title': 'Nike Air Jordan 1 Retro High',
      'category': 'Basketball',
      'price': 'Rp 2.499.000',
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
    },
    {
      'id': 'nike-air-force-1-07-triple-white',
      'title': 'Nike Air Force 1 07 Triple White',
      'category': 'Lifestyle',
      'price': 'Rp 1.549.000',
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80',
    },
    {
      'id': 'adidas-ultraboost-light-running',
      'title': 'Adidas Ultraboost Light Running',
      'category': 'Running',
      'price': 'Rp 2.899.000',
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&q=80',
    },
    {
      'id': 'puma-suede-classic-xxi-black',
      'title': 'Puma Suede Classic XXI Black',
      'category': 'Casual',
      'price': 'Rp 1.099.000',
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&q=80',
    },
    {
      'id': 'new-balance-574-core-grey',
      'title': 'New Balance 574 Core Grey',
      'category': 'Lifestyle',
      'price': 'Rp 1.499.000',
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&q=80',
    },
    {
      'id': 'vans-old-skool-classic-skate',
      'title': 'Vans Old Skool Classic Skate',
      'category': 'Skate',
      'price': 'Rp 999.000',
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&q=80',
    },
  ];

  // Getter ini membaca selectedCategory.value.
  // Obx yang mengakses getter ini akan bereaksi saat kategori berubah.
  List<Map<String, dynamic>> get filteredProducts {
    final category = selectedCategory.value;

    if (category == 'Semua') {
      return products;
    }

    return products
        .where((product) => product['category'] == category)
        .toList(growable: false);
  }

  void changeCategory(String category) {
    if (categories.contains(category)) {
      selectedCategory.value = category;
    }
  }

  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }

  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    if (quantity <= 0 || product['id'] == null) return;

    cartCount.value += quantity;
  }

  void openDetail(Map<String, dynamic> product) {
    Get.toNamed('/detail', arguments: product);
  }
}
