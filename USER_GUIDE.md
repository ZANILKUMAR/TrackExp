# TrackExp - Features & User Guide

## 📱 App Overview
TrackExp is a complete offline-first personal finance tracker built with Flutter. It helps you track income and expenses, visualize spending patterns, and manage your financial data locally on your device.

## ✨ Key Features

### 1. Dashboard 📊
**What you'll see:**
- **Summary Cards**: Monthly income, expenses, and savings at a glance
- **Pie Chart**: Visual breakdown of spending by category
- **Bar Chart**: 6-month trend showing income vs expenses
- **Recent Transactions**: Quick view of your latest 5 transactions

**Navigation:**
- Use left/right arrows to switch between months
- All data updates automatically when you add or edit transactions

### 2. Add Transaction ➕
**How to add:**
1. Tap the **+** (plus) button on Dashboard or Transactions screen
2. Select transaction type:
   - **Income** (salary, business, investments, etc.)
   - **Expense** (food, transport, shopping, etc.)
3. Enter the amount (₹)
4. Select a category from the list
5. Choose the date (defaults to today)
6. Add notes (optional - for extra details)
7. Tap "Add Transaction"

**Editing:**
- Tap any transaction in the list to edit it
- All fields can be updated

### 3. Transactions List 📋
**Features:**
- View all transactions sorted by date (newest first)
- Swipe left to delete a transaction
- Tap to edit any transaction
- Filter by:
  - Transaction type (Income/Expense)
  - Category
  - Both combined

**Using Filters:**
1. Tap the filter icon (top right)
2. Select your filter criteria
3. Active filters appear as chips at the top
4. Tap the X on any chip to remove that filter

### 4. Categories 🏷️
**Managing Categories:**
1. Go to Settings → "Manage Categories"
2. Switch between Expense and Income tabs
3. View all categories with their colors

**Adding a Category:**
1. Tap the **+** button
2. Enter category name
3. Select type (Expense/Income)
4. Choose a color (for visual identification)
5. Tap "Add"

**Editing/Deleting:**
- Tap edit icon to modify a category
- Tap delete icon to remove it
- You can't delete categories that have transactions

### 5. Export & Import 💾
**Export Your Data:**
1. Go to Settings
2. Tap "Export Data"
3. Data is saved as JSON file
4. File location is shown in the dialog
5. Share or backup this file for safekeeping

**Import Data:**
1. Go to Settings
2. Tap "Import Data"
3. Select a JSON file (previously exported)
4. Confirm the import
5. Data merges with existing data (doesn't replace)

**When to use:**
- Before resetting your phone
- To transfer data to a new device
- Regular backups (weekly/monthly)
- To restore accidentally deleted data

### 6. Dark Mode 🌙
Toggle between light and dark themes:
1. Go to Settings
2. Use the Dark Mode switch
3. Theme applies immediately

## 🎨 Pre-loaded Categories

### Expense Categories (with colors)
- 🍕 Food & Dining (Red)
- 🚗 Transportation (Teal)
- 🛍️ Shopping (Yellow)
- 🎬 Entertainment (Light Green)
- 🏥 Healthcare (Pink)
- 💡 Bills & Utilities (Blue)
- 📚 Education (Purple)
- 📦 Others (Gray)

### Income Categories
- 💼 Salary (Green)
- 💰 Business (Red)
- 📈 Investments (Purple)
- 💵 Others (Pink)

## 💡 Tips & Best Practices

### For Better Tracking
1. **Add transactions immediately** - Don't wait until end of day
2. **Use meaningful notes** - Helps you remember what the expense was for
3. **Review monthly** - Check your dashboard regularly to understand spending
4. **Set a routine** - Review your finances weekly
5. **Use categories wisely** - Don't create too many categories

### Data Management
1. **Export weekly** - Keep regular backups
2. **Store exports safely** - Use cloud storage or multiple devices
3. **Test imports** - Occasionally test that your backup files work
4. **Clean old data** - Delete test transactions after trying the app

### Category Organization
1. **Start with defaults** - Try the pre-loaded categories first
2. **Add only needed categories** - Too many makes selection harder
3. **Use colors wisely** - Similar categories can use similar colors
4. **Be consistent** - Use the same category for similar expenses

## 🔒 Privacy & Security

- **100% Offline**: No internet connection required
- **No login**: No account creation or login needed
- **Local storage only**: All data stays on your device
- **No tracking**: We don't collect any usage data
- **Your data, your control**: Export, import, or delete anytime

## 📊 Understanding the Charts

### Pie Chart (Category Breakdown)
- **Shows**: How much you spent in each category
- **Percentages**: Portion of total expenses per category
- **Colors**: Match the category colors you selected
- **Legend**: Shows category names on the right

### Bar Chart (Monthly Trends)
- **Shows**: Last 6 months of income vs expenses
- **Green bars**: Income amounts
- **Red bars**: Expense amounts
- **Hover**: Tap and hold to see exact amounts
- **Pattern recognition**: Spot months with unusual spending

## ❓ Common Questions

**Q: Can I use this without internet?**
A: Yes! The app is 100% offline and doesn't need internet at all.

**Q: Will I lose data if I uninstall?**
A: Yes, always export your data before uninstalling.

**Q: Can I have multiple accounts (personal/business)?**
A: Not currently. You can use categories to separate them.

**Q: How do I sync across devices?**
A: Export from one device, transfer the JSON file, and import on the other.

**Q: What if I enter a transaction by mistake?**
A: Swipe left on the transaction to delete it, or tap to edit.

**Q: Can I change currency from ₹ (INR)?**
A: Currently, the app uses ₹. You can edit the code to change it.

**Q: Is there a limit to transactions?**
A: No limit! Add as many as you need.

## 🐛 Known Limitations

1. No cloud sync (by design - offline first)
2. No recurring transactions (yet)
3. No budget limits/alerts (planned for future)
4. No transaction search (planned for future)
5. No custom date range filters (shows monthly data)
6. No multi-currency support

## 🎯 Roadmap (Future Features)

- 🔐 PIN lock for app security
- 🔄 Recurring transactions
- 🎯 Budget goals and alerts
- 🔍 Search transactions
- 📅 Custom date range filtering
- 💳 Multiple wallets (Cash, Bank, UPI)
- 📎 Attach receipts to transactions
- 📊 More chart types and analytics
- 🌍 Multi-currency support

## 📞 Support

This is an open-source project. For issues or feature requests:
- Check the README.md file
- Review the SETUP_GUIDE.md for technical details
- Report bugs by creating an issue on the repository

---

**Happy Tracking! 💰📊**

Made with ❤️ using Flutter
