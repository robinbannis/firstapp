import SwiftUI
import MapKit

struct LocationsView: View {
    @Environment(FamilyStore.self) private var store
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $position) {
                ForEach(store.members) { member in
                    Annotation(member.name, coordinate: member.coordinate) {
                        Text(member.emoji)
                            .font(.title2)
                            .padding(6)
                            .background(Circle().fill(member.color.gradient))
                            .overlay(Circle().stroke(.white, lineWidth: 2))
                            .shadow(radius: 3)
                    }
                }
            }
            .frame(height: 320)

            List {
                Section {
                    ForEach(store.members) { member in
                        Button {
                            focus(on: member)
                        } label: {
                            HStack(spacing: 12) {
                                Text(member.emoji)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(member.color.opacity(0.2), in: Circle())
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(member.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text("\(member.placeName) · \(member.lastSeen.formatted(.relative(presentation: .named)))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "location.circle")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                } header: {
                    Text("Family")
                } footer: {
                    Text("Sample locations. Real location sharing needs each person's permission and a shared backend (e.g. CloudKit or Firebase).")
                }
            }
        }
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Show All") {
                withAnimation { position = .automatic }
            }
        }
    }

    private func focus(on member: FamilyMember) {
        withAnimation {
            position = .region(MKCoordinateRegion(
                center: member.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}

#Preview {
    NavigationStack {
        LocationsView()
    }
    .environment(FamilyStore())
}
