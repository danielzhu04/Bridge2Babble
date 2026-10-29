import SwiftUI

/// An intentionally local, review-only handoff. This is not an EHR export,
/// a medical record, or a substitute for a qualified interpreter.
struct HandoffPreview: View {
    let model: TranslatorViewModel

    var body: some View {
        List {
            Section("Safety") {
                Label("Machine-translated, unverified", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .accessibilityIdentifier("handoffUnverifiedLabel")
                Text("Use a qualified interpreter for consent, diagnosis, treatment decisions, or urgent care.")
                    .font(.footnote)
            }

            Section("Encounter") {
                LabeledContent("Purpose", value: "Clinic intake & medication-allergy screening")
                LabeledContent("Language pair", value: "\(model.source.name) → \(model.target.name)")
                LabeledContent("Processing", value: "On device")
                if let expiry = model.handoffExpiresAt {
                    LabeledContent("Auto-delete", value: expiry.formatted(date: .omitted, time: .shortened))
                        .accessibilityIdentifier("handoffExpiryLabel")
                }
            }

            Section("Conversation turns") {
                ForEach(Array(model.turns.enumerated()), id: \.element.id) { index, turn in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Turn \(index + 1) · \(turn.source.name) → \(turn.target.name)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(turn.original)
                        Text(turn.translation)
                            .fontWeight(.semibold)
                    }
                    .accessibilityIdentifier("handoffTurn_\(index)")
                }
            }

            Section("Clinician review") {
                Text("Review the original and translated turns with the patient. Confirm medication and allergy details directly; this preview does not infer a diagnosis or create a clinical record.")
                    .font(.footnote)
            }
        }
        .navigationTitle("Local handoff")
        .navigationBarTitleDisplayMode(.inline)
    }
}
