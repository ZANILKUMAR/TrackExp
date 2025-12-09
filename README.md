# 💰 TrackExp - Personal Finance Tracker

> A complete, production-ready offline-first Flutter mobile application for tracking personal finances.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Overview

TrackExp is a comprehensive personal finance tracker that helps you manage your income and expenses, visualize spending patterns, and maintain complete control over your financial data - all without requiring an internet connection or backend server.

## ✨ Features

### 📊 Core Functionality
- ✅ **Transaction Management**: Add, edit, and delete income/expense transactions
- ✅ **Custom Categories**: Create and manage your own categories with colors
- ✅ **Smart Filtering**: Filter transactions by type, category, and date
- ✅ **Swipe to Delete**: Quick deletion with confirmation dialogs
- ✅ **Form Validation**: All inputs validated for data integrity

### 📈 Visual Analytics
- ✅ **Dashboard**: Monthly income, expenses, and savings summaries
- ✅ **Pie Chart**: Category-wise spending breakdown with percentages
- ✅ **Bar Chart**: 6-month income vs expense trends
- ✅ **Recent Transactions**: Quick view of latest activities

### 💾 Data Management
- ✅ **Export to JSON**: Backup your data with timestamped files
- ✅ **Import from JSON**: Restore or merge data from backups
- ✅ **100% Offline**: No internet connection required
- ✅ **Local Storage**: All data stored securely on your device using Hive

### 🎨 User Experience
- ✅ **Dark Mode**: Toggle between light and dark themes
- ✅ **Material 3**: Modern, clean, and intuitive interface
- ✅ **Responsive Design**: Works on various screen sizes
- ✅ **Pre-loaded Categories**: 12 default categories to get started
- ✅ **Color Coding**: 16 preset colors for category customization

## 🛠️ Tech Stack

| Component | Technology | Why? |
|-----------|-----------|------|
| **Framework** | Flutter 3.0+ | Cross-platform (Android + iOS) |
| **Language** | Dart | Type-safe, high-performance |
| **State Management** | Riverpod 2.4+ | Compile-time safety, better testability |
| **Local Database** | Hive 2.2+ | Fast, lightweight NoSQL database |
| **Charts** | FL Chart 0.65+ | Feature-rich, customizable visualizations |
| **Architecture** | Clean Architecture | Maintainable, scalable, testable code |

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/                             # Data models with Hive annotations
│   ├── category.dart                   # Category model
│   ├── category.g.dart                 # Generated Hive adapter
│   ├── transaction.dart                # Transaction model
│   └── transaction.g.dart              # Generated Hive adapter
├── repositories/                       # Data access layer
│   ├── database_service.dart           # Hive initialization
│   ├── category_repository.dart        # Category CRUD operations
│   └── transaction_repository.dart     # Transaction CRUD operations
├── providers/                          # Riverpod state management
│   ├── category_provider.dart          # Category state & providers
│   ├── transaction_provider.dart       # Transaction state, filters & summaries
│   └── theme_provider.dart             # Dark mode state
├── screens/                            # UI Screens
│   ├── dashboard_screen.dart           # Main dashboard with charts
│   ├── add_transaction_screen.dart     # Add/Edit transaction form
│   ├── transactions_list_screen.dart   # Transactions list with filters
│   ├── category_management_screen.dart # Category CRUD interface
│   └── settings_screen.dart            # Settings & export/import
├── widgets/                            # Reusable UI components
│   ├── summary_card.dart               # Dashboard summary cards
│   ├── pie_chart_widget.dart           # Category spending pie chart
│   ├── bar_chart_widget.dart           # Monthly trend bar chart
│   └── recent_transactions_widget.dart # Recent transactions display
└── utils/                              # Helper utilities
    ├── format_helper.dart              # Currency & date formatting
    └── export_import_service.dart      # JSON export/import logic
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0 or higher
- Android Studio / Xcode (for emulators)
- A device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd TrackExp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (Required!)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Google Play Store)
flutter build appbundle --release

# iOS (Mac only)
flutter build ios --release
```

## 📖 Documentation

- 📘 **[Setup Guide](SETUP_GUIDE.md)** - Detailed setup and installation instructions
- 📗 **[User Guide](USER_GUIDE.md)** - End-user documentation and features
- 📙 **[Commands Reference](COMMANDS.md)** - Quick command reference
- 📕 **[Project Summary](PROJECT_SUMMARY.md)** - Technical overview and architecture
- 📋 **[Checklist](CHECKLIST.md)** - Complete implementation checklist

## 🏗️ Architecture

TrackExp follows **Clean Architecture** principles with clear separation of concerns:

```
UI (Screens/Widgets)
    ↓
Providers (Riverpod State Management)
    ↓
Repositories (Data Access Layer)
    ↓
Hive Database (Local Storage)
```

### Why Riverpod over Provider?

- ✅ **Compile-time safety**: Catches errors before runtime
- ✅ **No BuildContext required**: Can be used anywhere in the code
- ✅ **Better testability**: Easier to mock and unit test
- ✅ **Performance**: Automatic disposal and optimization
- ✅ **Type-safe**: Full type inference support

### Why Hive over SQLite?

- ✅ **10x faster**: Significantly better performance for simple data
- ✅ **No SQL**: Easy key-value API, no complex queries
- ✅ **Type-safe**: Compile-time type checking with code generation
- ✅ **Lightweight**: No native dependencies
- ✅ **Perfect for offline**: Designed for local-first apps

## 🎨 Screenshots

*Dashboard*
- Monthly summaries with income, expenses, and savings
- Interactive pie chart showing category breakdown
- 6-month trend analysis with bar chart

*Transactions*
- Filterable list of all transactions
- Swipe-to-delete functionality
- Quick edit by tapping

*Categories*
- Manage custom categories
- Color-coded for easy identification
- Separate income and expense categories

## 🔒 Privacy & Security

- **100% Offline**: No internet connection or backend server required
- **No Tracking**: Zero analytics, telemetry, or data collection
- **No Login**: No user accounts or authentication needed
- **Local Storage**: All data stays on your device
- **User Control**: Export and delete your data anytime

## 📊 Project Statistics

- **Total Files**: 32+ source files
- **Lines of Code**: ~2,500+ Dart code
- **Documentation**: ~2,000+ lines across 6 documents
- **Screens**: 5 main screens
- **Widgets**: 4 reusable components
- **Features**: 100% of requested features implemented

## 🚧 Roadmap

Future enhancements (not yet implemented):
- [ ] PIN lock for app security
- [ ] Recurring transactions
- [ ] Budget goals and alerts
- [ ] Transaction search functionality
- [ ] Multi-wallet support (Cash, Bank, UPI)
- [ ] Receipt/bill attachments
- [ ] Multi-currency support
- [ ] Custom date range filters
- [ ] Cloud backup option (optional)

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Riverpod** - For excellent state management
- **Hive** - For fast local storage
- **FL Chart** - For beautiful charts

## 📞 Support

For questions, issues, or suggestions:
- Read the documentation files
- Check the inline code comments
- Review the Flutter/Riverpod/Hive official docs

---

**Made with ❤️ using Flutter**

⭐ If you find this project helpful, please give it a star!
