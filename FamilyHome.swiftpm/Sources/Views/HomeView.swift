import SwiftUI

/// The main menu. Each tile opens one of the sub menus.
enum MenuItem: String, CaseIterable, Identifiable, Hashable {
    case tasks, lawnCare, locations, shopping, family

    var id: Self { self }

    var title: String {
        switch self {
        case .tasks: "Tasks"
        case .lawnCare: "Lawn Care"
        case .locations: "Locations"
        case .shopping: "Shopping"
        case .family: "Family"
        }
    }

    var icon: String {
        switch self {
        case .tasks: "checklist"
        case .lawnCare: "leaf.fill"
        case .locations: "location.fill"
        case .shopping: "cart.fill"
        case .family: "person.3.fill"
        }
    }

    var color: Color {
        switch self {
        case .tasks: .blue
        case .lawnCare: .green
        case .locations: .red
        case .shopping: .orange
        case .family: .purple
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .tasks: TasksView()
        case .lawnCare: LawnCareView()
        case .locations: LocationsView()
        case .shopping: ShoppingListView()
        case .family: FamilyView()
        }
    }
}

struct HomeView: View {
    @Environment(FamilyStore.self) private var store

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    summaryCard

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(MenuItem.allCases) { item in
                            NavigationLink(value: item) {
                                MenuTile(item: item, subtitle: subtitle(for: item))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Family Home")
            .navigationDestination(for: MenuItem.self) { item in
                item.destination
            }
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(greeting)
                .font(.title2.bold())
            Label("\(store.openTaskCount) open tasks for the family", systemImage: "checklist")
            if let next = store.nextLawnTask {
                Label("\(next.title) — \(next.nextDue.friendlyDay)", systemImage: next.symbol)
            }
        }
        .font(.subheadline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(colors: [.green, .teal], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning ☀️"
        case 12..<17: "Good afternoon 🌤️"
        default: "Good evening 🌙"
        }
    }

    private func subtitle(for item: MenuItem) -> String {
        switch item {
        case .tasks: "\(store.openTaskCount) open"
        case .lawnCare: store.nextLawnTask.map { "Next: \($0.nextDue.friendlyDay)" } ?? "Nothing scheduled"
        case .locations: "\(store.members.count) sharing"
        case .shopping: "\(store.uncheckedItemCount) to buy"
        case .family: "\(store.members.count) members"
        }
    }
}

struct MenuTile: View {
    let item: MenuItem
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(item.color.gradient, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
        .environment(FamilyStore())
}
