import SwiftUI
import Translation

struct TranslatorView: View {
    @State private var model = TranslatorViewModel()
    @FocusState private var draftFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                LanguageBar(model: model)
                    .padding(.horizontal)

                conversation

                statusLine
                    .padding(.horizontal)

                controls
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .navigationTitle("Bridge2Babble")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $model.autoSpeak) {
                        Image(systemName: model.autoSpeak ? "speaker.wave.2" : "speaker.slash")
                    }
                    .toggleStyle(.button)
                    .accessibilityLabel("Speak translations aloud")
                    .accessibilityIdentifier("autoSpeakToggle")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HandoffPreview(model: model)
                    } label: {
                        Label("Handoff", systemImage: "cross.case")
                    }
                    .disabled(model.turns.isEmpty)
                    .accessibilityIdentifier("handoffButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") { model.clearConversation() }
                        .disabled(model.turns.isEmpty)
                        .accessibilityIdentifier("clearButton")
                }
            }
            .translationTask(model.translationConfiguration) { session in
                await model.runTranslationTask(with: session)
            }
            .task {
                await model.refreshStatus()
                #if DEBUG
                // `-autoSample` plays the sample phrase on launch (quick simulator smoke check).
                if ProcessInfo.processInfo.arguments.contains("-autoSample") { await model.playSample() }
                #endif
            }
        }
    }

    private var conversation: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if model.turns.isEmpty {
                        ContentUnavailableView(
                            "Start a conversation",
                            systemImage: "bubble.left.and.text.bubble.right",
                            description: Text("Tap the mic and speak, or type below. Conversation data stays on this iPhone and expires automatically.")
                        )
                        .padding(.top, 40)
                        .accessibilityIdentifier("emptyState")
                    }
                    ForEach(Array(model.turns.enumerated()), id: \.element.id) { index, turn in
                        TurnRow(turn: turn, index: index) {
                            Task { await model.speak(turn) }
                        }
                        .id(turn.id)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: model.turns.count) {
                if let last = model.turns.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
    }

    private var statusLine: some View {
        VStack(alignment: .leading, spacing: 4) {
        if let heard = model.lastHeard, isError {
            Text("Heard: \(heard)")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("lastHeardLabel")
        }
        HStack {
            if model.phase.isBusy { ProgressView().controlSize(.small) }
            Text("Status: \(model.phase.label)")
                .font(.footnote)
                .foregroundStyle(isError ? .red : .secondary)
                .accessibilityIdentifier("statusLabel")
            Spacer()
        }
        }
    }

    private var isError: Bool {
        if case .error = model.phase { return true }
        return false
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                TextField("Type in \(model.source.name)…", text: $model.draft)
                    .textFieldStyle(.roundedBorder)
                    .focused($draftFocused)
                    .submitLabel(.send)
                    .onSubmit { Task { await model.translateDraft() } }
                    .accessibilityIdentifier("translateTextField")
                Button("Translate") {
                    draftFocused = false
                    Task { await model.translateDraft() }
                }
                .buttonStyle(.bordered)
                .disabled(model.draft.trimmingCharacters(in: .whitespaces).isEmpty || model.phase.isBusy)
                .accessibilityIdentifier("translateButton")
            }

            HStack(spacing: 16) {
                #if DEBUG
                Button {
                    Task { await model.playSample() }
                } label: {
                    Label("Sample phrase", systemImage: "play.circle")
                        .font(.footnote)
                }
                .disabled(model.phase.isBusy || model.source.sampleClip == nil)
                .accessibilityIdentifier("samplePhraseButton")
                #endif

                Spacer()

                Button {
                    draftFocused = false
                    Task { await model.toggleListening() }
                } label: {
                    Image(systemName: model.isListening ? "stop.fill" : "mic.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 84, height: 84)
                        .background(model.isListening ? Color.red : Color.accentColor, in: Circle())
                        .shadow(radius: 4, y: 2)
                }
                .disabled(model.phase.isBusy && !model.isListening)
                .accessibilityLabel(model.isListening ? "Stop and translate" : "Start speaking")
                .accessibilityIdentifier("micButton")

                Spacer()

                // Balances the sample button so the mic stays centered.
                Color.clear.frame(width: 100, height: 1)
            }
        }
    }
}

#Preview {
    TranslatorView()
}
