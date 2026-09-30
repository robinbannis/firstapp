import SwiftUI

struct TasksView: View {
    @Environment(FamilyStore.self) private var store
    @State private var filter: FamilyMember.ID?
    @State private var showingAddTask = false

    var body: some View {
        List {
            Section {
                Picker("Show tasks for", selection: $filter) {
                    Text("Everyone").tag(FamilyMember.ID?.none)
                    ForEach(store.members) { member in
                        Text("\(member.emoji) \(member.name)").tag(FamilyMember.ID?.some(member.id))
                    }
                }
            }

            Section("To Do") {
                let open = visibleTasks(done: false)
                if open.isEmpty {
                    Text("All caught up! 🎉")
                        .foregroundStyle(.secondary)
                }
                ForEach(open) { task in
                    row(for: task)
                }
            }

            let done = visibleTasks(done: true)
            if !done.isEmpty {
                Section("Done") {
                    ForEach(done) { task in
                        row(for: task)
                    }
                }
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            Button {
                showingAddTask = true
            } label: {
                Label("Add Task", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .environment(store)
        }
    }

    private func row(for task: HomeTask) -> some View {
        TaskRow(task: task, assignee: store.member(task.assigneeID)) {
            withAnimation { store.toggle(task) }
        }
        .swipeActions {
            Button(role: .destructive) {
                store.delete(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func visibleTasks(done: Bool) -> [HomeTask] {
        store.tasks
            .filter { $0.isDone == done && (filter == nil || $0.assigneeID == filter) }
            .sorted { $0.dueDate < $1.dueDate }
    }
}

struct TaskRow: View {
    let task: HomeTask
    let assignee: FamilyMember?
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isDone ? Color.green : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? Color.secondary : Color.primary)
                HStack(spacing: 4) {
                    if let assignee {
                        Text("\(assignee.emoji) \(assignee.name) ·")
                    }
                    Text(task.dueDate.friendlyDay)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if task.priority == .high && !task.isDone {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(FamilyStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var assigneeID: FamilyMember.ID?
    @State private var dueDate = Date.now
    @State private var priority = TaskPriority.normal

    var body: some View {
        NavigationStack {
            Form {
                TextField("What needs doing?", text: $title)

                Picker("Assign to", selection: $assigneeID) {
                    Text("Anyone").tag(FamilyMember.ID?.none)
                    ForEach(store.members) { member in
                        Text("\(member.emoji) \(member.name)").tag(FamilyMember.ID?.some(member.id))
                    }
                }

                DatePicker("Due", selection: $dueDate, displayedComponents: .date)

                Picker("Priority", selection: $priority) {
                    ForEach(TaskPriority.allCases) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(HomeTask(title: title.trimmingCharacters(in: .whitespaces),
                                           assigneeID: assigneeID,
                                           dueDate: dueDate,
                                           priority: priority))
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
        TasksView()
    }
    .environment(FamilyStore())
}
