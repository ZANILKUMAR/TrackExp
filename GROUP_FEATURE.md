# Group Feature Implementation

## Overview
The Group feature has been successfully added to the TrackExp expense tracking application. This feature allows users to organize their transactions into logical groups (e.g., "Tour Expenses", "Wedding Expenses", "Project Budget") for better expense management and tracking.

## What's New

### 1. Group Model
- **Location:** `lib/models/group.dart`
- **Features:**
  - Name and optional description
  - Custom color and icon selection
  - Created timestamp
  - Hive storage with TypeId 2

### 2. Group Management Screen
- **Location:** `lib/screens/group_management_screen.dart`
- **Features:**
  - View all groups with transaction count and total amount
  - Create new groups with custom names, descriptions, colors, and icons
  - Edit existing groups
  - Delete groups (transactions remain, just become ungrouped)
  - Access via Settings → Manage Groups

### 3. Transaction Grouping
- **Updates:**
  - Transaction model now includes optional `groupId` field
  - Add/Edit Transaction screen has a new "Group (Optional)" dropdown
  - Transactions can be assigned to groups when creating or editing
  - Groups can be cleared by selecting "None"

### 4. Group Filtering
- **Location:** `lib/screens/transactions_list_screen.dart`
- **Features:**
  - New "Group" tab in filter dialog
  - Filter options:
    - All Transactions (no filter)
    - Ungrouped (transactions without a group)
    - Individual groups
  - Active filter chips show selected group
  - Filter summary includes grouped transactions

### 5. Database Updates
- **Location:** `lib/repositories/database_service.dart`
- New groups box initialized with Hive
- ExpenseGroupAdapter registered for storage

## How to Use

### Creating a Group
1. Go to Settings
2. Tap "Manage Groups"
3. Tap the "+" button in the app bar
4. Enter group name (e.g., "Tour Expenses")
5. Optionally add description (e.g., "Trip to Goa 2025")
6. Select an icon and color
7. Tap "Create"

### Assigning Transactions to Groups
1. Create or edit a transaction
2. Select a group from the "Group (Optional)" dropdown
3. Save the transaction
4. The transaction is now associated with that group

### Filtering by Group
1. Go to Transactions list
2. Tap the filter icon
3. Select the "Group" tab
4. Choose a group or "Ungrouped"
5. Apply filters to see filtered transactions

### Managing Groups
- **Edit:** Tap the edit icon on any group card
- **Delete:** Tap the delete icon (transactions won't be deleted, just ungrouped)
- **View Details:** Each group card shows:
  - Number of transactions
  - Total expense amount for that group

## Technical Implementation

### Files Added
- `lib/models/group.dart` - Group model
- `lib/models/group.g.dart` - Generated Hive adapter
- `lib/repositories/group_repository.dart` - Group data operations
- `lib/providers/group_provider.dart` - State management for groups
- `lib/screens/group_management_screen.dart` - Group management UI

### Files Modified
- `lib/models/transaction.dart` - Added groupId field
- `lib/models/transaction.g.dart` - Updated Hive adapter
- `lib/repositories/database_service.dart` - Added groups box initialization
- `lib/providers/transaction_provider.dart` - Added group filter provider
- `lib/screens/add_transaction_screen.dart` - Added group selection dropdown
- `lib/screens/transactions_list_screen.dart` - Added group filtering UI
- `lib/screens/settings_screen.dart` - Added group management navigation

### State Management
- Uses Riverpod for state management
- StreamProvider for reactive group updates
- StateNotifier for CRUD operations
- Filter state provider for transaction filtering

### Data Persistence
- Groups stored in Hive local database
- Transactions reference groups by ID
- Deleting a group doesn't delete associated transactions
- Transactions become "ungrouped" when their group is deleted

## Benefits

1. **Better Organization:** Group related expenses together (tours, projects, events)
2. **Easy Tracking:** See total spending per group at a glance
3. **Flexible Filtering:** Filter transactions by group quickly
4. **Visual Identification:** Custom colors and icons for each group
5. **Optional Feature:** Groups are completely optional - transactions work fine without them

## Example Use Cases

1. **Tour Expenses:** Track all expenses during a trip
2. **Wedding Expenses:** Organize wedding-related costs
3. **Project Budget:** Track project-specific expenses
4. **Event Planning:** Manage expenses for an event
5. **Monthly Bills:** Group recurring monthly bills together
6. **Health Expenses:** Track medical and health-related costs

## Notes

- Groups are optional - not all transactions need to be in a group
- A transaction can only belong to one group at a time
- Deleting a group is safe - it doesn't delete transactions
- Groups can be filtered along with other filters (date, type, category)
- The feature is fully integrated with existing export/import functionality
