# Family Home 🏡

A sample iPhone app for sharing home life with your family, written in SwiftUI.

## What's in it

The home screen is a menu of tiles, and each one opens a section:

| Section | What it does |
|---|---|
| **Tasks** | Chores and to-dos. Assign each one to a family member, set a due date and priority, tick it off, and filter by person. |
| **Lawn Care** | Recurring yard jobs (mow every 7 days, water every 2…). Tap **Done** and the next date is worked out for you. Overdue jobs show in red. |
| **Locations** | A map with each family member's pin and when they were last seen. Tap a person to zoom to them. |
| **Shopping** | A shared shopping list you can check off. |
| **Family** | Everyone in the family and how many open tasks each person has. |

Everything uses **sample data kept in memory**, so changes reset when the app restarts.

## How to run it

You need a Mac with **Xcode 15 or later**, or **Swift Playgrounds** on an iPad or Mac.

1. Download this repo (**Code → Download ZIP** on GitHub, or `git clone`).
2. Double-click **`FamilyHome.swiftpm`**. It opens in Xcode or Swift Playgrounds.
3. Choose an iPhone simulator (or your own iPhone) and press **Run ▶**.

To run it on your own iPhone from Xcode, sign in with your Apple ID under
*Xcode → Settings → Accounts* and choose your team in the app's signing settings.

## Project layout

```
FamilyHome.swiftpm/
├── Package.swift            App settings (name, icon, location permission)
└── Sources/
    ├── FamilyHomeApp.swift  App entry point
    ├── Models.swift         FamilyMember, HomeTask, LawnTask, ShoppingItem
    ├── FamilyStore.swift    All app data and sample data
    └── Views/               One file for each screen
```

## Next steps to make it real

- **Sharing between phones:** keep the data in **CloudKit** (Apple's iCloud database, free with a
  developer account) or **Firebase**, so every family member sees the same tasks and lists.
- **Saving data:** use **SwiftData** so changes stay after the app restarts.
- **Live location:** use **Core Location** to read each person's location (with their permission)
  and send it to the shared backend.
- **Reminders:** send local notifications when a task or lawn job is due.
- **Sign in:** add **Sign in with Apple** and family invites.
