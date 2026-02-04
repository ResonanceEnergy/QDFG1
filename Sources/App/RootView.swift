import SwiftUI

struct RootView: View {
    @AppStorage("lastPackId") private var lastPackId = "merged"
    @State private var currentPackId = ""
    @State private var vm: StoryViewModel?
    @State private var showPackSelection = false

    init() {
        _currentPackId = State(initialValue: lastPackId)
        loadVM()
    }

    var body: some View {
        if let vm = vm {
            NavigationView {
                VStack(spacing: 12) {
                    classPicker
                    SceneView(vm: vm)
                }
                .navigationTitle(vm.pack.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Packs") {
                            showPackSelection = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showPackSelection) {
                PackSelectionView(selectedPackId: $currentPackId) {
                    lastPackId = currentPackId
                    loadVM()
                }
            }
        } else {
            Text("Loading...")
        }
    }

    private func loadVM() {
        do {
            if currentPackId == "merged" {
                let pack = try Storage.loadMergedPacks(named: [
                    "prologue_pack.json",
                    "ch1_hub_pack.json",
                    "ch1_npcs_pack.json",
                    "ch1_wilderness_pack.json",
                    "ch2_echo_pack.json"
                ])
                vm = StoryViewModel(pack: pack)
            } else {
                let pack = try Storage.loadPack(named: currentPackId)
                vm = StoryViewModel(pack: pack)
            }
        } catch {
            vm = nil
        }
    }

    private var classPicker: some View {
        HStack {
            ForEach(vm?.pack.definitions.classes ?? [], id: \.id) { c in
                Button {
                    vm?.setClass(c.id)
                } label: {
                    Text(c.displayName)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(vm?.state.heroClassId == c.id ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.top, 8)
    }
}

struct PackSelectionView: View {
    @Binding var selectedPackId: String
    let onSelect: () -> Void

    let packIds = ["merged", "prologue_pack.json", "ch1_hub_pack.json", "ch1_npcs_pack.json", "ch1_wilderness_pack.json", "ch2_echo_pack.json"] // Hardcoded list of bundled packs

    var body: some View {
        NavigationView {
            List(packIds, id: \.self) { packId in
                Button(action: {
                    selectedPackId = packId
                    onSelect()
                }) {
                    Text(packId)
                }
            }
            .navigationTitle("Select Pack")
        }
    }
}
