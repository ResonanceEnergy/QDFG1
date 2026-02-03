import SwiftUI

struct RootView: View {
    @StateObject private var vm: StoryViewModel

    init() {
        let pack = (try? Storage.loadPack(named: "prologue_pack"))!
        _vm = StateObject(wrappedValue: StoryViewModel(pack: pack))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                classPicker
                SceneView(vm: vm)
            }
            .navigationTitle(vm.pack.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") { vm.reset() }
                }
            }
        }
    }

    private var classPicker: some View {
        HStack {
            ForEach(vm.pack.definitions.classes, id: \.id) { c in
                Button {
                    vm.setClass(c.id)
                } label: {
                    Text(c.displayName)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(vm.state.heroClassId == c.id ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.top, 8)
    }
}
