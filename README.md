# Finance Companion

A personal finance management app built with Flutter. Track your income, expenses, and savings goals with beautiful charts and smooth navigation.

## Features

- **Home Dashboard with Summary**: See your balance, income, and expenses at a glance.
- **Visual Elements**: Charts and progress bars for trends and goal tracking.
- **Transaction Tracking**: Add, view, edit, and delete transactions.
- **Transaction Filtering & Search**: Filter by type/category and search by text.
- **Goal/Challenge Feature**: Set, track, and manage savings goals.
- **Insights Screen**: Visualize your financial trends.
- **Smooth Navigation**: Bottom navigation bar for easy access to all screens.
- **Empty, Loading, and Error States**: User-friendly feedback for all app states.
- **Local Data Persistence**: All data is stored locally using SQLite.
- **State Management**: Robust BLoC pattern for all business logic.
- **Swipe-to-Delete**: Remove transactions and goals with a swipe.
- **Edit via Modal Bottom Sheet**: Edit items in a modern, user-friendly way.
- **Date Picker**: Select dates for transactions and goals.
- **Category Color Coding**: Visual distinction for income and expenses.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd finance_app
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/`
  - `blocs/` — BLoC state management for transactions and goals
  - `data/` — SQLite repositories
  - `models/` — Data models
  - `screens/` — UI screens (dashboard, transactions, goals, insights)
  - `widgets/` — Reusable UI components

## Dependencies
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [sqflite](https://pub.dev/packages/sqflite)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [equatable](https://pub.dev/packages/equatable)

## Assumptions
- The app is intended for single-user, local use (no authentication or cloud sync).
- All data is stored locally on the device using SQLite.
- Categories are fixed but can be extended in the code.

## Additional Features
- Swipe-to-delete for transactions and goals
- Progress bars for goals
- Error logging and debug prints

## Documentation & Clarity
- The codebase is organized by feature and follows best practices for state management and separation of concerns.
- Each screen and BLoC is documented with clear naming and structure.
- Setup instructions are provided above for quick onboarding.
- Features are listed and explained for clarity.

## License

MIT License
