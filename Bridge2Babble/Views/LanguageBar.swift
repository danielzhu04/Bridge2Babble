import SwiftUI

struct LanguageBar: View {
    @Bindable var model: TranslatorViewModel

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                LanguageMenu(title: "From", selection: $model.source, identifier: "sourceLanguagePicker")
                Button {
                    model.swapLanguages()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title3.weight(.semibold))
                        .frame(width: 44, height: 44)
                        .background(.thinMaterial, in: Circle())
                }
                .accessibilityLabel("Swap languages")
                .accessibilityIdentifier("swapLanguagesButton")
                .disabled(model.phase.isBusy)
                LanguageMenu(title: "To", selection: $model.target, identifier: "targetLanguagePicker")
            }

            HStack(spacing: 8) {
                Image(systemName: statusIcon)
                    .foregroundStyle(statusColor)
                Text("\(model.source.name) → \(model.target.name): \(model.languageStatus.label)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("languageStatusLabel")
                Spacer()
                if model.languageStatus.canDownload {
                    Button("Download") { model.prepareOffline() }
                        .font(.footnote.weight(.semibold))
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                        .accessibilityIdentifier("downloadLanguagesButton")
                        .disabled(model.phase.isBusy)
                }
            }
        }
    }

    private var statusIcon: String {
        switch model.languageStatus {
        case .ready: "checkmark.circle"
        case .needsDownload(.some): "checkmark.circle"
        case .needsDownload(.none): "arrow.down.circle"
        case .unsupported: "exclamationmark.triangle"
        case .checking: "hourglass"
        }
    }

    private var statusColor: Color {
        switch model.languageStatus {
        case .ready, .needsDownload(.some): .green
        case .needsDownload(.none): .orange
        case .unsupported: .red
        case .checking: .secondary
        }
    }
}

private struct LanguageMenu: View {
    let title: String
    @Binding var selection: AppLanguage
    let identifier: String

    var body: some View {
        Menu {
            ForEach(AppLanguage.all) { language in
                Button("\(language.flag) \(language.name)") { selection = language }
            }
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text("\(selection.flag) \(selection.name)")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .accessibilityLabel("\(title) language: \(selection.name)")
        .accessibilityIdentifier(identifier)
    }
}
