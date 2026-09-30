import SwiftUI
import Observation

/// Holds all app data. For now it's filled with sample data and lives in memory only;
/// swap this out for CloudKit or Firebase to actually share between family members' phones.
@Observable
final class FamilyStore {
    var members: [FamilyMember]
    var tasks: [HomeTask]
    var lawnTasks: [LawnTask]
    var shoppingItems: [ShoppingItem]

    init() {
        let robin = FamilyMember(name: "Robin", role: "Parent", emoji: "🧑", color: .blue,
                                 placeName: "Home", latitude: 37.3349, longitude: -122.0090,
                                 lastSeen: .now.addingTimeInterval(-120))
        let alex = FamilyMember(name: "Alex", role: "Parent", emoji: "👩", color: .purple,
                                placeName: "Work", latitude: 37.3318, longitude: -122.0312,
                                lastSeen: .now.addingTimeInterval(-900))
        let sam = FamilyMember(name: "Sam", role: "Kid", emoji: "👦", color: .orange,
                               placeName: "School", latitude: 37.3230, longitude: -122.0322,
                               lastSeen: .now.addingTimeInterval(-300))
        let maya = FamilyMember(name: "Maya", role: "Kid", emoji: "👧", color: .pink,
                                placeName: "Soccer practice", latitude: 37.3400, longitude: -122.0150,
                                lastSeen: .now.addingTimeInterval(-60))

        members = [robin, alex, sam, maya]

        tasks = [
            HomeTask(title: "Take out the trash", assigneeID: sam.id, dueDate: .daysFromNow(0), priority: .high),
            HomeTask(title: "Unload the dishwasher", assigneeID: maya.id, dueDate: .daysFromNow(0)),
            HomeTask(title: "Pay electric bill", assigneeID: alex.id, dueDate: .daysFromNow(2), priority: .high),
            HomeTask(title: "Clean the garage", assigneeID: robin.id, dueDate: .daysFromNow(5), priority: .low),
            HomeTask(title: "Feed the dog", assigneeID: maya.id, dueDate: .daysFromNow(-1), isDone: true)
        ]

        lawnTasks = [
            LawnTask(title: "Mow the lawn", symbol: "leaf.fill", everyDays: 7, lastDone: .daysFromNow(-5)),
            LawnTask(title: "Water flower beds", symbol: "drop.fill", everyDays: 2, lastDone: .daysFromNow(-3)),
            LawnTask(title: "Trim hedges", symbol: "scissors", everyDays: 30, lastDone: .daysFromNow(-12)),
            LawnTask(title: "Fertilize", symbol: "sparkles", everyDays: 60, lastDone: .daysFromNow(-40),
                     notes: "Use slow-release fertilizer in the fall.")
        ]

        shoppingItems = [
            ShoppingItem(name: "Milk"),
            ShoppingItem(name: "Eggs"),
            ShoppingItem(name: "Lawn mower gas"),
            ShoppingItem(name: "Bread", isChecked: true)
        ]
    }

    // MARK: Family

    func member(_ id: FamilyMember.ID?) -> FamilyMember? {
        members.first { $0.id == id }
    }

    // MARK: Tasks

    var openTaskCount: Int {
        tasks.filter { !$0.isDone }.count
    }

    func openTaskCount(for member: FamilyMember) -> Int {
        tasks.filter { !$0.isDone && $0.assigneeID == member.id }.count
    }

    func add(_ task: HomeTask) {
        tasks.append(task)
    }

    func toggle(_ task: HomeTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(_ task: HomeTask) {
        tasks.removeAll { $0.id == task.id }
    }

    // MARK: Lawn care

    var nextLawnTask: LawnTask? {
        lawnTasks.min { $0.nextDue < $1.nextDue }
    }

    func add(_ task: LawnTask) {
        lawnTasks.append(task)
    }

    func markDone(_ task: LawnTask) {
        guard let index = lawnTasks.firstIndex(where: { $0.id == task.id }) else { return }
        lawnTasks[index].lastDone = .now
    }

    func delete(_ task: LawnTask) {
        lawnTasks.removeAll { $0.id == task.id }
    }

    // MARK: Shopping

    var uncheckedItemCount: Int {
        shoppingItems.filter { !$0.isChecked }.count
    }

    func addShoppingItem(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        shoppingItems.append(ShoppingItem(name: trimmed))
    }

    func toggle(_ item: ShoppingItem) {
        guard let index = shoppingItems.firstIndex(where: { $0.id == item.id }) else { return }
        shoppingItems[index].isChecked.toggle()
    }

    func clearCheckedItems() {
        shoppingItems.removeAll { $0.isChecked }
    }
}
