import 'package:flutter/material.dart';
import 'services/api_service.dart';

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});

  @override
  State<FoodHomePage> createState() => _FoodUIExactState();
}

class _FoodUIExactState extends State<FoodHomePage> {
  String selectedMeal = "Breakfast";

    List<dynamic> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  void loadMenu() async {
    menuItems = await ApiService.fetchMenu();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8),
      body: Row(
        children: [
          // --------------------------------------------------------------
          // SIDEBAR (Exact width, spacing, icons, divider line)
          // --------------------------------------------------------------
          Container(
            width: 90,
            color: const Color(0xFF0A57A3),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Top circular logo
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

                // Divider line
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

          // --------------------------------------------------------------
          // RIGHT SIDE CONTENT
          // --------------------------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------------
                  // HEADER
                  // ------------------------------------------------------
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

                      // Search bar aligned to the right
                      SizedBox(
                        width: 330,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // ------------------------------------------------------
                  // RICE MEALS LABEL
                  // ------------------------------------------------------
                  const Text(
                    "Rice Meals",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A57A3),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ------------------------------------------------------
                  // BREAKFAST / LUNCH TABS
                  // ------------------------------------------------------
                  Row(
                    children: [
                      _mealTab("Breakfast"),
                      const SizedBox(width: 15),
                      _mealTab("Lunch"),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // ------------------------------------------------------
                  // MENU LABEL
                  // ------------------------------------------------------
                  const Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A57A3),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ------------------------------------------------------
                  // FOOD CARDS GRID (Exact width & height like design)
                  // ------------------------------------------------------
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.72, // controls card shape
                      children: [
                        _foodCard("assets/cornbeef.png", "CORN BEEF", "100.00 PHP"),
                        _foodCard("assets/hotdog.png", "HOTDOG", "85.00 PHP"),
                        _foodCard("assets/longganisa.png", "LONGGANISA", "85.00 PHP"),
                        _foodCard("assets/egg.png", "SCRAMBLE EGG", "20.00 PHP"),
                      ],
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

  // ------------------------------------------------------------------
  // SIDEBAR ICON
  // ------------------------------------------------------------------
  Widget _sidebarIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 30);
  }

  // ------------------------------------------------------------------
  // MEAL TAB BUTTON (Breakfast/Lunch)
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // FOOD CARD
  // ------------------------------------------------------------------
  Widget _foodCard(String image, String title, String price) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A57A3),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      child: Column(
        children: [
          // Circular image
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

          // Rating stars
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

          // Price
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
