# SDCA Canteen App 🍔🥤

A smart canteen ordering system designed for St. Dominic College of Asia (SDCA). This application bridges the gap between students/faculty and canteen staff, offering a seamless ordering experience through both a manual shopping cart and an AI-powered chatbot.

## 🌟 Features

### For Students & Faculty 🎓
- **Smart Menu**: Browse food and drinks by category (Main, Beverage, Snack, Dessert).
  - **Real descriptions**: Each item shows its actual description from database
  - **Category badges**: Visual category labels for easy identification
  - **Search & Filter**: Find items quickly by name or category
- **AI Chatbot Assistant** 🤖:
  - Order food naturally (e.g., "I want 2 burgers and a taho").
  - Multi-item orders in one message
  - Ask for prices and menu availability.
  - **Syncs with Cart**: Items ordered via chat are automatically added to your shopping cart.
  - **Session-based**: Remembers your order as you build it
- **Manual Ordering**:
  - Add items to cart directly from the menu.
  - Adjust quantities and review total price.
  - Place orders for pickup (pay-on-pickup model).
- **Order Tracking**: View the status of your current and past orders (Pending, Preparing, Ready, Completed).
- **Profile Management**: View and manage your account details.
- **Secure Login**: Role-based authentication ensures users access correct dashboard

### For Canteen Staff 👨‍🍳
- **Orders Dashboard**: Real-time view of all incoming orders with complete details:
  - **Order number** and **customer name**
  - **Full item list** with quantities (e.g., "2x Cheeseburger")
  - **Individual prices** per item
  - **Total amount** prominently displayed
  - **Status badge** (Pending, Preparing, Ready, Completed)
- **Status Management**: Update order status with a single tap:
  - 🟠 **Pending** -> 🔵 **Preparing** -> 🟢 **Ready** -> ⚫ **Completed**
- **Menu Management**:
  - **Add Items**: Create new menu items with name, description, price, category, and image URL
  - **Edit Items**: Update existing menu items with pre-filled forms
  - **Delete Items**: Remove items with confirmation dialog
  - **Real-time refresh**: See changes reflected immediately (with loading indicators)
  - **Concurrent operation protection**: Buttons disabled during refresh to prevent errors
- **Secure Access**: Only canteen staff can access management features

## 🔒 Security Features
- **Role-Based Access Control**: Users must log in through their designated portal
- **Login Validation**: Clear error messages if wrong portal is used
- **JWT Authentication**: Secure token-based authentication
- **Protected Routes**: Backend middleware ensures only authorized users access staff features

## 🛠️ Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, Express.js
- **Database**: MongoDB Atlas
- **Hosting**: Render.com (Backend)
- **State Management**: Flutter Provider pattern
- **AI/NLP**: Natural library for intent recognition (Chatbot)
- **Authentication**: JWT tokens with role validation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Backend server running (see backend repository)

### Installation
1. Clone the repository.
2. Navigate to the project directory:
   ```bash
   cd frontend_canteen
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```
5. Select platform (Chrome recommended for web)

## 📱 Usage
- **Login**: Use your student/faculty or staff credentials through the correct portal
  - Student: Student login page
  - Faculty: Faculty login page
  - Staff: Canteen staff login page
- **Navigation**: Use the sidebar for easy access to Menu, Cart, Profile, and Orders.
- **Chat**: Click the floating chat bubble to talk to the AI assistant.
- **Ordering**: Either browse menu visually or use chatbot for quick orders

## 🧪 Test Accounts
- **Student**: `j.zone@sdca.edu.ph` / `200percent`
- **Faculty**: `faculty.member@sdca.edu.ph` / `faculty123`
- **Staff**: `staff.member@sdca.edu.ph` / `staff123`

## 📋 Recent Updates
- ✅ Added role validation to prevent unauthorized dashboard access
- ✅ Enhanced order cards with complete item details for staff
- ✅ Fixed faculty profile loading issue
- ✅ Fixed chatbot cart duplication bug
- ✅ Improved menu item display with dynamic descriptions
- ✅ Added loading states and error prevention mechanisms

## 🎯 Key Highlights
1. **Dual Ordering Methods**: Traditional cart + AI chatbot
2. **Complete Order Details**: Staff see exactly what to prepare
3. **Security First**: Multi-layer authentication and role validation
4. **User-Friendly**: Immediate feedback and clear error messages
5. **Production-Ready**: Error handling, loading states, and data consistency

## 📞 Support
For issues or questions, contact the development team.

---
**Built with ❤️ for SDCA Community**
