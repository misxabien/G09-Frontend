import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';
import 'profile_page.dart';

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
          : Row(
              children: [
                // Sidebar (unchanged)
                Container(
                  width: 90,
                  color: const Color(0xFF0A57A3),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.restaurant_menu,
                            color: Color(0xFF0A57A3), size: 32),
                      ),
                      const SizedBox(height: 40),
                      _sidebarIcon(Icons.home),
                      const SizedBox(height: 35),
                      _sidebarIconButton(Icons.person, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              token: token!,
                              userData: widget.userData,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 35),
                      _sidebarIcon(Icons.shopping_cart),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Divider(color: Colors.white, thickness: 1),
                      ),
                      _sidebarIcon(Icons.history),
                      const SizedBox(height: 45),
                      const Spacer(),
                      _sidebarIcon(Icons.menu),
                      const SizedBox(height: 25),
                    ],
                  ),
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
                              return _foodCard(
                                item['imageUrl'] ?? '',
                                item['name'] ?? 'Food',
                                "₱${item['price'] ?? '0.00'}",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Sidebar icon
  Widget _sidebarIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 30);
  }

  // Sidebar icon button (clickable)
  Widget _sidebarIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 30),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
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
  Widget _foodCard(String image, String title, String price) {
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
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Icon(Icons.star, color: Colors.yellow, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1 cup of rice and side dish",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
