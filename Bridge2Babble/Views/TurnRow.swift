import SwiftUI

struct TurnRow: View {
    let turn: Turn
    let index: Int
    let onSpeak: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("\(turn.source.flag) \(turn.source.name)")
                if turn.viaSpeech {
                    Image(systemName: "waveform").accessibilityLabel("spoken")
                }
                Spacer()
                Label(turn.engine.rawValue, systemImage: "lock.iphone")
                    .accessibilityIdentifier("turnEngine_\(index)")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Text(turn.original)
                .font(.body)
                .accessibilityIdentifier("turnOriginal_\(index)")

            Divider()

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(turn.target.flag) \(turn.target.name)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(turn.translation)
                        .font(.title3.weight(.semibold))
                        .accessibilityIdentifier("turnTranslation_\(index)")
                }
                Spacer()
                Button(action: onSpeak) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Play translation \(index + 1)")
                .accessibilityIdentifier("speakButton_\(index)")
            }
        }
        .padding(14)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("turnRow_\(index)")
    }
}
