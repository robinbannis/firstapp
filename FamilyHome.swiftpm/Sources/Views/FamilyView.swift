import SwiftUI

struct FamilyView: View {
    @Environment(FamilyStore.self) private var store
    @State private var showingInviteInfo = false

    var body: some View {
        List {
            Section("Members") {
                ForEach(store.members) { member in
                    HStack(spacing: 12) {
                        Text(member.emoji)
                            .font(.title)
                            .frame(width: 52, height: 52)
                            .background(member.color.opacity(0.2), in: Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                                .font(.headline)
                            Text(member.role)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        let open = store.openTaskCount(for: member)
                        Text(open == 1 ? "1 task" : "\(open) tasks")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(member.color.opacity(0.15), in: Capsule())
                            .foregroundStyle(member.color)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button {
                    showingInviteInfo = true
                } label: {
                    Label("Invite a family member", systemImage: "person.badge.plus")
                }
            }
        }
        .navigationTitle("Family")
        .alert("Coming soon", isPresented: $showingInviteInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Inviting family members will work once the app is connected to a shared backend like CloudKit.")
        }
    }
}

#Preview {
    NavigationStack {
        FamilyView()
    }
    .environment(FamilyStore())
}
