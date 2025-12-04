import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'profile_page.dart';
import 'widgets/chatbot_widget.dart';
import 'my_orders_page.dart';
import 'widgets/sidebar_widget.dart';
import '../providers/cart_provider.dart';

class FoodHomePage extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? userData;
  const FoodHomePage({super.key, required this.token, this.userData});

  @override
  State<FoodHomePage> createState() => _FoodUIExactState();
}

class _FoodUIExactState extends State<FoodHomePage> {
  String selectedCategory = "All";
  List<dynamic> menuItems = [];
  List<dynamic> filteredMenuItems = [];
  bool isLoading = true;
  String? token;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    token = widget.token; // Use the token passed from login
    loadMenu(); // Load menu immediately
  }

  // Load JWT token and then fetch menu
  void _loadTokenAndMenu() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');

    if (token != null) {
      await loadMenu();
    } else {
      // No token → maybe redirect to login
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch menu from API using token
  Future<void> loadMenu() async {
    setState(() {
      isLoading = true;
    });

    print('🔄 Fetching menu from API...');
    menuItems = await ApiService.fetchMenu(token: token);
    print('✅ Received ${menuItems.length} menu items');
    print('📦 First item: ${menuItems.isNotEmpty ? menuItems[0] : "EMPTY"}');
    
    setState(() {
      isLoading = false;
      _applyFilters();
    });
  }

  // Filter menu items based on category and search query
  void _applyFilters() {
    String query = searchController.text.toLowerCase();
    
    filteredMenuItems = menuItems.where((item) {
      // Category filter
      bool matchesCategory = selectedCategory == "All" || 
          item['category'].toString().toLowerCase() == selectedCategory.toLowerCase();
      
      // Search filter
      bool matchesSearch = query.isEmpty || 
          item['name'].toString().toLowerCase().contains(query);
      
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Row(
              children: [
                // Sidebar Widget
                SidebarWidget(
                  token: token,
                  userData: widget.userData,
                  currentPage: 'menu',
                ),


                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome!",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Let's Order Your Food",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A57A3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _applyFilters();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),

                        // Category Tabs
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _categoryTab("All"),
                              const SizedBox(width: 10),
                              _categoryTab("Main"),
                              const SizedBox(width: 10),
                              _categoryTab("Beverage"),
                              const SizedBox(width: 10),
                              _categoryTab("Snack"),
                              const SizedBox(width: 10),
                              _categoryTab("Dessert"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Menu Grid
                        const Text(
                          "Menu",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A57A3),
                          ),
                        ),
                        const SizedBox(height: 25),

                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: filteredMenuItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredMenuItems[index];
                              return _foodCard(item);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
                // Chatbot Widget
                ChatBotWidget(token: token!),
              ],
            ),
    );
  }

  // Category tab
  Widget _categoryTab(String text) {
    bool active = selectedCategory == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0A57A3) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF0A57A3), width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF0A57A3),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Food card
  Widget _foodCard(Map<String, dynamic> item) {
    final String image = item['imageUrl'] ?? '';
    final String title = item['name'] ?? 'Food';
    final double price = (item['price'] is int) 
        ? (item['price'] as int).toDouble() 
        : (item['price'] ?? 0.0);
    final String id = item['_id'] ?? '';
    final String description = item['description'] ?? 'Delicious food item';
    final String category = item['category'] ?? 'other';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A57A3),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: image.startsWith('http')
                ? Image.network(
                    image,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey,
                        child: const Icon(Icons.fastfood, color: Colors.white, size: 50),
                      );
                    },
                  )
                : Image.asset(
                    image,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₱${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF0A57A3), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addItem(
                      id,
                      title,
                      price,
                      image,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$title added to cart'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: const Color(0xFF0A57A3),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
