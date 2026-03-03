# BoldTracker – Development Log

## 📅 Phase 1 – Basic UI & Local Persistence

### 🎯 Objective
Build a simple SwiftUI app to track daily "bold actions" and maintain a streak counter.

---

## ✅ What Has Been Implemented

### 1️⃣ Basic SwiftUI Interface
- Title: "Daily Bold Tracker"
- Current streak counter display
- "Hoy fui audaz 💥" button
- Reset button (development only)

Concepts practiced:
- VStack layout
- Text styling
- Button actions
- State persistence with @AppStorage

---

### 2️⃣ Streak Persistence with @AppStorage

Implemented local storage using:

- `@AppStorage("streakCount")`
- `@AppStorage("lastBoldDate")`

This allows the app to:
- Persist streak count between launches
- Persist last registered date

Learned:
- Difference between @State and @AppStorage
- How SwiftUI stores primitive types in UserDefaults

---

### 3️⃣ Date Handling Refactor (Important Improvement)

Initially:
- Dates were stored as `String`
- Used DateFormatter for conversion
- Compared formatted date strings

Problem:
- Date format depends on locale
- Requires conversion between String and Date
- Risk of formatting bugs

Refactor:
- Replaced String date with `TimeInterval` (Double)
- Store `Date().timeIntervalSince1970`
- Convert back to Date when needed

New approach:
- More robust
- Locale independent
- Cleaner date comparison

Concepts learned:
- What `Date` actually represents internally
- What `TimeInterval` is
- How to compare dates using `Calendar`
- Why `startOfDay(for:)` avoids time-based bugs

---

### 4️⃣ Streak Logic

Current logic:
- If last recorded date was yesterday → increment streak
- If more than 1 day passed → reset streak to 1
- If already marked today → do nothing

Edge cases considered:
- First time opening app
- Multiple taps in same day
- Breaking streak

---

## 🧠 Key Concepts Learned So Far

- SwiftUI View structure
- Property wrappers (@AppStorage)
- State persistence
- Date vs String handling
- Basic calendar date comparison
- Avoiding mutable state errors in SwiftUI

---

## 🚧 Next Possible Steps

- Move logic into a ViewModel (MVVM structure)
- Disable button if already marked today
- Add simple animation or visual feedback
- Add streak history (Array of Date)
- Add statistics view

---

## Personal Reflection

Realized the importance of revisiting Swift fundamentals.
Decision made to move forward progressively instead of rushing architecture.

Focus now:
- Solid understanding of data types
- State management
- Clean incremental improvements
