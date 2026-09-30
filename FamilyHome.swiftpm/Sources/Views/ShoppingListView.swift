import SwiftUI

struct ShoppingListView: View {
    @Environment(FamilyStore.self) private var store
    @State private var newItem = ""

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Add an item", text: $newItem)
                        .submitLabel(.done)
                        .onSubmit(addItem)
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(newItem.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }

            Section("Items") {
                ForEach(store.shoppingItems) { item in
                    Button {
                        withAnimation { store.toggle(item) }
                    } label: {
                        HStack {
                            Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                .foregroundStyle(item.isChecked ? Color.green : Color.secondary)
                            Text(item.name)
                                .strikethrough(item.isChecked)
                                .foregroundStyle(item.isChecked ? Color.secondary : Color.primary)
                        }
                    }
                }
                .onDelete { offsets in
                    store.shoppingItems.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Shopping")
        .toolbar {
            Button("Clear Checked") {
                withAnimation { store.clearCheckedItems() }
            }
            .disabled(!store.shoppingItems.contains(where: { $0.isChecked }))
        }
    }

    private func addItem() {
        store.addShoppingItem(named: newItem)
        newItem = ""
    }
}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
    .environment(FamilyStore())
}
