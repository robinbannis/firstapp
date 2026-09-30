import SwiftUI

@main
struct FamilyHomeApp: App {
    @State private var store = FamilyStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(store)
        }
    }
}
