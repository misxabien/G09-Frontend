# SDCA Canteen App 🍔🥤

A smart canteen ordering system designed for St. Dominic College of Asia (SDCA). This application bridges the gap between students/faculty and canteen staff, offering a seamless ordering experience through both a manual shopping cart and an AI-powered chatbot.

## 🌟 Features

### For Students & Faculty 🎓
- **Smart Menu**: Browse food and drinks by category (Main, Beverage, Snack, Dessert).
- **AI Chatbot Assistant** 🤖:
  - Order food naturally (e.g., "I want a burger and fries").
  - Ask for prices and menu availability.
  - **Syncs with Cart**: Items ordered via chat are automatically added to your shopping cart.
- **Manual Ordering**:
  - Add items to cart directly from the menu.
  - Adjust quantities and review total price.
  - Place orders for pickup.
- **Order Tracking**: View the status of your current and past orders (Pending, Preparing, Ready, Completed).
- **Profile Management**: View and manage your account details.

### For Canteen Staff 👨‍🍳
- **Orders Dashboard**: Real-time view of all incoming orders.
- **Status Management**: Update order status with a single tap:
  - 🟠 **Pending** -> 🔵 **Preparing** -> 🟢 **Ready** -> ⚫ **Completed**
- **Menu Management**:
  - **Add Items**: Easily add new dishes to the menu with images and prices.
  - **View Menu**: See all active menu items.

## 🛠️ Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, Express.js
- **Database**: MongoDB
- **AI/NLP**: Natural library for intent recognition (Chatbot)

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

## 📱 Usage
- **Login**: Use your student/faculty or staff credentials.
- **Navigation**: Use the sidebar for easy access to Menu, Cart, Profile, and Orders.
- **Chat**: Click the floating chat bubble to talk to the AI assistant.
