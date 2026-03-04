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

- Move logic into a ViewModel (MVVM structure) - DONE
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


## 📅 Phase 2 – Architecture Refactor (MVVM)

### 🎯 Objective
Separate UI logic from business logic using the MVVM pattern to improve scalability and maintainability.

---

## 🔄 Major Refactor – Introduced ViewModel

Created a new file:

- `BoldTrackerViewModel.swift`

Adopted the MVVM architecture pattern:

- View → Handles UI only
- ViewModel → Handles logic and persistence
- Model → Data types (Date, Int)

---

## 🧠 What Changed

### 1️⃣ Removed @AppStorage from the View

Previously:
- The View handled persistence directly using `@AppStorage`.
- The View calculated streak logic.
- The View handled date comparisons.

Problem:
- Too many responsibilities.
- Harder to scale.
- Violates separation of concerns.

Now:
- The View only displays data.
- The View calls ViewModel methods.
- The ViewModel owns the logic and storage.

---

### 2️⃣ Implemented ObservableObject

`BoldTrackerViewModel` now conforms to `ObservableObject`.

Key concept learned:
- `ObservableObject` allows SwiftUI to listen for state changes.
- `@Published` properties notify the View automatically.

Implemented:

```swift
@Published var streakCount = 0

This ensures the UI updates whenever the streak changes.

### 3️⃣ Replaced @AppStorage with Manual Persistence
Instead of using @AppStorage inside the ViewModel,
we now use UserDefaults directly.

Why?
- Clearer control over when data is saved
- Better architectural separation
- Avoided protocol conformance issues with ObservableObject
- More explicit state management

Implemented:
- Data loading in init()
- Centralized saving logic inside a private save() function

### 4️⃣ Introduced Initialization Logic

Added:
init() {
    streakCount = UserDefaults.standard.integer(forKey: "streakCount")
    lastBoldDateInterval = UserDefaults.standard.double(forKey: "lastBoldDate")
}

This ensures:
- Data is restored when the app launches
- State remains persistent across sessions

🧠 Architectural Concepts Learned
- What MVVM really means in practice
- Why Views should not contain business logic
- Difference between @StateObject and @ObservedObject
- Why @Published is required in ObservableObject
- How SwiftUI reacts to state changes
- Manual persistence with UserDefaults
- Separation of responsibilities

🏗 Current Architecture
DailyBoldTrackerView
        ↓
BoldTrackerViewModel (ObservableObject)
        ↓
UserDefaults (Persistence)

🚀 Benefits of This Refactor
- Cleaner code structure
- Easier to expand features
- More professional architecture
- Better long-term scalability
- Clear separation between UI and logic

📌 Personal Reflection
- This was the first major architectural decision in the project.
- Understanding MVVM required revisiting Swift fundamentals.

Key realization:
- Good architecture reduces confusion as the project grows.
- Learning this early prevents technical debt later.

## 📌 Next Steps

- Add "alreadyMarkedToday" computed property
- Disable button if already marked
- Introduce streak history
- Add simple statistics screen


### 📅 Phase 3 – Streak History & Visual Calendar

🎯 Objective
Extend the app from a simple counter to a historical tracking system with visualization.

🟢 1️⃣ Added Bold History
Introduced:
@Published var boldHistory: [Double] = []
Each entry:
Represents one successful bold day
Stored as startOfDay.timeIntervalSince1970

💾 Updated Persistence
Added history to:
init() loading
save() method
UserDefaults.standard.set(boldHistory, forKey: "boldHistory")

🧠 Data Normalization
Used:
Calendar.current.startOfDay(for: date)
Why:
Avoid duplicate entries
Avoid time-of-day inconsistencies
Ensure safe date comparison

🧠 Refactored markBoldAction()
Improved logic flow:
Check if today already exists in history
Calculate day difference from last recorded date
Update streak accordingly
Append to history
Save all changes
This prevents:
Premature returns
Inconsistent state
Missed persistence

🗓 2️⃣ Added Visual Calendar (Last 30 Days)
Implemented a GitHub-style activity grid.
Used:
LazyVGrid
7 flexible columns
Computed property for last 30 days
var last30Days: [Date]
For each day:
Normalize to startOfDay
Convert to TimeInterval
Check presence in boldHistory
Render green circle if true
Render gray circle if false

🧠 Concepts Reinforced
Date normalization
Calendar-based day comparison
Computed properties
Reactive UI updates
MVVM in real practice
Avoiding duplicated state mutation
Persistence management
Visualizing temporal data

🏗 Current Architecture
DailyBoldTrackerView
        ↓
BoldTrackerViewModel (ObservableObject)
        ↓
UserDefaults

Tracked State:
streakCount
lastBoldDateInterval
boldHistory[]
last30Days (computed)

📈 Project Evolution
The app evolved from:
“Simple daily streak counter”
Into:
“A behavior tracking system with historical visualization”

The architecture now supports:
Longest streak tracking
Monthly summaries
Performance metrics
Expanded statistics view

🔭 Next Exploration Ideas
Align calendar to real weeks
Add tap interaction to show selected date
Compute longest historical streak
Add monthly performance percentage
Introduce animations for new entries

🧠 Personal Reflection
This project moved from learning syntax to designing systems.
Key realizations:
Architecture matters early.
Temporal data introduces complexity.
Normalizing state prevents subtle bugs.
Reactive UI depends on proper state modeling.
BoldTracker is no longer a simple counter.
It is becoming a structured behavior tracking system.
