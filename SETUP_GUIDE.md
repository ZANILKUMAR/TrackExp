# Finvix - Setup Guide

## 🚀 Quick Start Guide

### Prerequisites
1. Install Flutter SDK (3.0 or higher)
   ```bash
   flutter --version
   ```
2. Install Android Studio or Xcode (for iOS development)
3. Install an emulator or connect a physical device

### Installation Steps

1. **Navigate to the project directory**
   ```bash
   cd f:\MyProjects\TrackExp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (Required!)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   This will generate the necessary files:
   - `lib/models/category.g.dart`
   - `lib/models/transaction.g.dart`

4. **Check for any issues**
   ```bash
   flutter doctor
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

#### Android APK
```bash
flutter build apk --release
```
The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/                             # Data models
│   ├── category.dart                   # Category model with Hive annotations
│   ├── category.g.dart                 # Generated Hive adapter
│   ├── transaction.dart                # Transaction model
│   └── transaction.g.dart              # Generated Hive adapter
├── repositories/                       # Data access layer
│   ├── database_service.dart           # Hive initialization
│   ├── category_repository.dart        # Category CRUD operations
│   └── transaction_repository.dart     # Transaction CRUD operations
├── providers/                          # Riverpod state management
│   ├── category_provider.dart          # Category state providers
│   ├── transaction_provider.dart       # Transaction state & filtering
│   └── theme_provider.dart             # Dark mode provider
├── screens/                            # UI Screens
│   ├── dashboard_screen.dart           # Main dashboard with charts
│   ├── add_transaction_screen.dart     # Add/Edit transaction form
│   ├── transactions_list_screen.dart   # List with filters
│   ├── category_management_screen.dart # Category CRUD
│   └── settings_screen.dart            # Settings & export/import
├── widgets/                            # Reusable widgets
│   ├── summary_card.dart               # Dashboard summary cards
│   ├── pie_chart_widget.dart           # Category spending pie chart
│   ├── bar_chart_widget.dart           # Monthly trend bar chart
│   └── recent_transactions_widget.dart # Recent transactions list
└── utils/                              # Helper utilities
    ├── format_helper.dart              # Currency & date formatting
    └── export_import_service.dart      # JSON export/import logic
```

## 🎯 Features Implemented

### ✅ Core Features
- [x] Add/Edit/Delete Transactions (Income & Expense)
- [x] Category Management (CRUD operations)
- [x] Dashboard with Summary Cards
- [x] Category-wise Spending Pie Chart
- [x] Monthly Trend Bar Chart (Last 6 months)
- [x] Transaction Filtering (Type, Category)
- [x] Swipe-to-Delete Transactions
- [x] Export Data to JSON
- [x] Import Data from JSON

### ✅ Technical Features
- [x] 100% Offline (No Backend)
- [x] Hive Local Database
- [x] Riverpod State Management
- [x] Clean Architecture
- [x] Dark Mode Support
- [x] Material 3 Design
- [x] Responsive UI
- [x] Default Categories Pre-loaded

## 🏗️ Architecture

### State Management: Riverpod
**Why Riverpod over Provider?**
- **Compile-time safety**: Catches errors at compile time
- **No BuildContext**: Can be used anywhere
- **Better testing**: Easier to mock and test
- **Performance**: Automatic disposal and optimization
- **Type-safe**: Full type inference

### Data Flow
```
UI (Screens/Widgets)
    ↓
Providers (Riverpod)
    ↓
Repositories
    ↓
Hive Database (Local Storage)
```

## 🎨 UI/UX Features

1. **Navigation**: Bottom navigation with 3 tabs
   - Dashboard
   - Transactions
   - Settings

2. **Charts**:
   - Pie Chart: Category-wise expense breakdown
   - Bar Chart: 6-month income vs expense trend

3. **Filters**:
   - Filter by transaction type (Income/Expense)
   - Filter by category
   - Clear active filters easily

4. **Themes**:
   - Light mode (default)
   - Dark mode (toggle in settings)

## 📊 Data Models

### Transaction
```dart
{
  id: String (UUID)
  type: 'income' | 'expense'
  amount: double
  categoryId: String
  notes: String? (optional)
  date: DateTime
}
```

### Category
```dart
{
  id: String (UUID)
  name: String
  type: 'income' | 'expense'
  colorValue: int? (color as integer)
}
```

## 🔧 Troubleshooting

### Issue: "Target of URI hasn't been generated"
**Solution**: Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Permission errors on Android
**Solution**: Grant storage permissions in device settings or accept permission prompts

### Issue: Import/Export not working
**Solution**: 
- Check file permissions
- Ensure file picker package is properly installed
- For Android 11+, ensure proper storage access

## 📝 Usage Guide

### Adding a Transaction
1. Tap the **+** FAB button
2. Select type (Income/Expense)
3. Enter amount
4. Select category
5. Choose date (optional)
6. Add notes (optional)
7. Tap "Add Transaction"

### Managing Categories
1. Go to Settings
2. Tap "Manage Categories"
3. Use tabs to switch between Expense/Income
4. Tap **+** to add new category
5. Edit/Delete existing categories

### Exporting Data
1. Go to Settings
2. Tap "Export Data"
3. Data will be saved as JSON in device storage
4. Location will be shown in dialog

### Importing Data
1. Go to Settings
2. Tap "Import Data"
3. Select JSON file
4. Confirm import
5. Data will be merged with existing data

## 🚀 Future Enhancements (Not Implemented)

- [ ] Local PIN lock
- [ ] Multi-wallet support
- [ ] Budget alerts
- [ ] Recurring transactions
- [ ] Data backup to cloud
- [ ] Custom date range filters
- [ ] Search functionality
- [ ] Transaction attachments

## 📄 License
MIT License

## 💡 Tips
- Regularly export your data as backup
- Use meaningful category names
- Add notes for important transactions
- Review monthly trends to track spending habits
