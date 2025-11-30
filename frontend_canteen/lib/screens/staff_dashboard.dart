import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'services/api_service.dart';

class StaffDashboard extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? userData;
  final int? initialTab;

  const StaffDashboard({
    super.key, 
    required this.token, 
    this.userData,
    this.initialTab,
  });

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  late int selectedTab;
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8),
      body: Row(
        children: [
          // Sidebar
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
                _sidebarIconButton(Icons.receipt_long, 0),
                const SizedBox(height: 35),
                _sidebarIconButton(Icons.fastfood, 1),
                const SizedBox(height: 35),
                _sidebarIconButton(Icons.person, -1, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        token: widget.token,
                        userData: widget.userData,
                      ),
                    ),
                  );
                }),
                const Spacer(),
                Icon(Icons.settings, color: Colors.white, size: 30),
                const SizedBox(height: 25),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: selectedTab == 0 ? _buildOrdersView() : _buildMenuManagement(),
          ),
        ],
      ),
    );
  }

  Widget _sidebarIconButton(IconData icon, int tabIndex, {VoidCallback? onTap}) {
    bool isActive = selectedTab == tabIndex && tabIndex >= 0;
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onTap ?? () {
          if (tabIndex >= 0) {
            setState(() => selectedTab = tabIndex);
          }
        },
        icon: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  // Orders View
  Widget _buildOrdersView() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Orders Dashboard",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A57A3),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Manage incoming orders",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),

          // Status Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _statusChip("All", Colors.grey),
                const SizedBox(width: 10),
                _statusChip("Pending", Colors.orange),
                const SizedBox(width: 10),
                _statusChip("Preparing", Colors.blue),
                const SizedBox(width: 10),
                _statusChip("Ready", Colors.green),
                const SizedBox(width: 10),
                _statusChip("Completed", Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Orders List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.fetchAllOrders(token: widget.token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 20),
                        Text(
                          "No orders yet",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Orders will appear here in real-time",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final orders = snapshot.data!;
                final filteredOrders = selectedFilter == "All"
                    ? orders
                    : orders.where((order) =>
                        order['status'].toString().toLowerCase() ==
                        selectedFilter.toLowerCase()).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Text(
                      "No $selectedFilter orders",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);
    final orderNumber = order['orderNumber'] ?? 'N/A';
    final totalAmount = order['totalAmount'] ?? 0;
    final items = order['items'] as List? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A57A3),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1.5),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Total: ₱${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "${items.length} item(s)",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _statusChip(String label, Color color) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Menu Management View
  Widget _buildMenuManagement() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menu Management",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A57A3),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Add, edit, or remove menu items",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add new menu item
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Item"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A57A3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Menu Items Placeholder
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    "Menu management coming soon",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "You'll be able to add, edit, and delete menu items here",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
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
}
