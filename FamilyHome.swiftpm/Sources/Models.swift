import SwiftUI
import CoreLocation

struct FamilyMember: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var role: String
    var emoji: String
    var color: Color
    var placeName: String
    var latitude: Double
    var longitude: Double
    var lastSeen: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum TaskPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"

    var id: Self { self }
}

struct HomeTask: Identifiable {
    let id = UUID()
    var title: String
    var assigneeID: FamilyMember.ID?
    var dueDate: Date
    var priority: TaskPriority = .normal
    var isDone = false
}

struct LawnTask: Identifiable {
    let id = UUID()
    var title: String
    var symbol: String
    var everyDays: Int
    var lastDone: Date
    var notes: String = ""

    var nextDue: Date {
        Calendar.current.date(byAdding: .day, value: everyDays, to: lastDone) ?? lastDone
    }

    var isOverdue: Bool {
        nextDue < Calendar.current.startOfDay(for: .now)
    }
}

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked = false
}

extension Date {
    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: .now) ?? .now
    }

    /// "Today", "Tomorrow", "Yesterday", or a short date like "Sat, Oct 4".
    var friendlyDay: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return "Today" }
        if calendar.isDateInTomorrow(self) { return "Tomorrow" }
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        return formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }
}
