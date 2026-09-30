import SwiftUI

struct LawnCareView: View {
    @Environment(FamilyStore.self) private var store
    @State private var showingAddTask = false

    private var sortedTasks: [LawnTask] {
        store.lawnTasks.sorted { $0.nextDue < $1.nextDue }
    }

    var body: some View {
        List {
            Section {
                ForEach(sortedTasks) { task in
                    LawnTaskRow(task: task) {
                        withAnimation { store.markDone(task) }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            store.delete(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            } header: {
                Text("Schedule")
            } footer: {
                Text("Tap Done after finishing a job and the next date is worked out automatically.")
            }
        }
        .navigationTitle("Lawn Care")
        .toolbar {
            Button {
                showingAddTask = true
            } label: {
                Label("Add Job", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddLawnTaskView()
                .environment(store)
        }
    }
}

struct LawnTaskRow: View {
    let task: LawnTask
    let onDone: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.symbol)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.green.gradient, in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.headline)
                Text("Every \(task.everyDays) days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(task.isOverdue ? "Overdue since \(task.nextDue.friendlyDay)" : "Next: \(task.nextDue.friendlyDay)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(task.isOverdue ? Color.red : Color.green)
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button("Done", action: onDone)
                .buttonStyle(.bordered)
                .tint(.green)
        }
    }
}

struct AddLawnTaskView: View {
    @Environment(FamilyStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    private let symbols = ["leaf.fill", "drop.fill", "scissors", "sparkles", "tree.fill", "wind", "ant.fill", "snowflake"]

    @State private var title = ""
    @State private var symbol = "leaf.fill"
    @State private var everyDays = 7
    @State private var lastDone = Date.now
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Job name (e.g. Rake leaves)", text: $title)

                Picker("Icon", selection: $symbol) {
                    ForEach(symbols, id: \.self) { name in
                        Image(systemName: name).tag(name)
                    }
                }

                Stepper("Every \(everyDays) days", value: $everyDays, in: 1...365)

                DatePicker("Last done", selection: $lastDone, displayedComponents: .date)

                TextField("Notes", text: $notes, axis: .vertical)
            }
            .navigationTitle("New Lawn Job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(LawnTask(title: title.trimmingCharacters(in: .whitespaces),
                                           symbol: symbol,
                                           everyDays: everyDays,
                                           lastDone: lastDone,
                                           notes: notes))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LawnCareView()
    }
    .environment(FamilyStore())
}
