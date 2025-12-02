import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../profile_page.dart';
import '../my_orders_page.dart';
import '../staff_dashboard.dart';
import '../menu.dart';
import '../cart_page.dart';

class SidebarWidget extends StatelessWidget {
  final String? token;
  final Map<String, dynamic>? userData;
  final String currentPage; // 'menu', 'profile', 'orders', 'staff_dashboard', 'cart'

  const SidebarWidget({
    super.key,
    required this.token,
    this.userData,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStaff = userData?['userType'] == 'canteen_staff';

    return Container(
      width: 90,
      color: const Color(0xFF0A57A3),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Logo
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.restaurant_menu,
                color: Color(0xFF0A57A3), size: 32),
          ),
          const SizedBox(height: 40),

          if (isStaff) ...[
            // STAFF SIDEBAR
            _buildIconButton(
              context,
              Icons.receipt_long,
              isActive: currentPage == 'staff_dashboard',
              onTap: () {
                if (currentPage != 'staff_dashboard') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffDashboard(
                        token: token!,
                        userData: userData,
                        initialTab: 0,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 35),
            _buildIconButton(
              context,
              Icons.fastfood,
              isActive: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StaffDashboard(
                      token: token!,
                      userData: userData,
                      initialTab: 1,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 35),
            _buildIconButton(
              context,
              Icons.person,
              isActive: currentPage == 'profile',
              onTap: () {
                if (currentPage != 'profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        token: token!,
                        userData: userData,
                      ),
                    ),
                  );
                }
              },
            ),
          ] else ...[
            // STUDENT/FACULTY SIDEBAR
            _buildIconButton(
              context,
              Icons.home,
              isActive: currentPage == 'menu',
              onTap: () {
                if (currentPage != 'menu') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodHomePage(
                        token: token!,
                        userData: userData,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            _buildIconButton(
              context,
              Icons.person,
              isActive: currentPage == 'profile',
              onTap: () {
                if (currentPage != 'profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        token: token!,
                        userData: userData,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            
            // Cart Icon with Badge
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildIconButton(
                      context,
                      Icons.shopping_cart,
                      isActive: currentPage == 'cart',
                      onTap: () {
                        if (currentPage != 'cart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(
                                token: token!,
                                userData: userData,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white, thickness: 1),
            ),
            _buildIconButton(
              context,
              Icons.history,
              isActive: currentPage == 'orders',
              onTap: () {
                if (currentPage != 'orders') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrdersPage(
                        token: token!,
                        userData: userData,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],

          const Spacer(),
          _buildIcon(isStaff ? Icons.settings : Icons.menu),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Non-clickable icon
  Widget _buildIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 30);
  }

  // Clickable icon button
  Widget _buildIconButton(
    BuildContext context,
    IconData icon, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
