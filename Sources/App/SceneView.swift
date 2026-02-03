import SwiftUI

struct SceneView: View {
    @ObservedObject var vm: StoryViewModel

    var body: some View {
        VStack(spacing: 12) {
            statusStrip

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if let title = vm.currentScene.title {
                        Text(title).font(.title2).bold()
                    }

                    Text(vm.currentScene.text)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider().padding(.vertical, 6)

                    VStack(spacing: 10) {
                        ForEach(Resolver.availableChoices(for: vm.currentScene, state: vm.state, pack: vm.pack), id: \.id) { choice in
                            Button {
                                vm.choose(choice)
                            } label: {
                                Text(choice.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }

            logStrip
        }
    }

    private var statusStrip: some View {
        HStack(spacing: 12) {
            Text("Phase: \(vm.phase)")
            Spacer()
            Text("HP: \(vm.state.health)")
            Text("Fatigue: \(vm.state.fatigue)")
        }
        .font(.footnote)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemBackground))
    }

    private var logStrip: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let last = vm.state.log.last {
                Text(last)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
