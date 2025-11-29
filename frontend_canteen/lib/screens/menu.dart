import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';

class FoodHomePage extends StatefulWidget {
  final String token; // <-- add this
  const FoodHomePage({super.key, required this.token});

  @override
  State<FoodHomePage> createState() => _FoodUIExactState();
}

class _FoodUIExactState extends State<FoodHomePage> {
  String selectedMeal = "Breakfast";
  List<dynamic> menuItems = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndMenu();
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

    menuItems = await ApiService.fetchMenu(token: token);
    setState(() {
      isLoading = false;
    });
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
                      _sidebarIcon(Icons.person),
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome!",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Let’s Order Your Food",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A57A3),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 330,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),

                        // Meal Tabs
                        Row(
                          children: [
                            _mealTab("Breakfast"),
                            const SizedBox(width: 15),
                            _mealTab("Lunch"),
                          ],
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
                              crossAxisCount: 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              final item = menuItems[index];
                              return _foodCard(
                                item['image'] ?? 'assets/cornbeef.png',
                                item['name'] ?? 'Food',
                                "${item['price'] ?? '0.00'} PHP",
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

  // Meal tab
  Widget _mealTab(String text) {
    bool active = selectedMeal == text;
    return GestureDetector(
      onTap: () => setState(() => selectedMeal = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0A57A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF0A57A3), width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF0A57A3),
            fontSize: 15,
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
            child: Image.asset(
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
