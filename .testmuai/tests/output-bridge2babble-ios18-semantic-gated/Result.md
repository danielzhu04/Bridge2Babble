---
test: ../bridge2babble-ios18-semantic-gated_test.md
status: passed
started: 2026-10-24T21:53:08.358Z
duration_s: 57.2
session_id: 0007e53c-c460-43f7-ac4e-20b9aaa5fec6
---

# Session: bridge2babble-ios18-semantic-gated — Result

## Step 1 ✓ passed (57.2s)
md5: 8e1bf9c9aeea826ac821406b19fc7a84
Launch Bridge2Babble on an iPhone 13 running iOS 18. Use only the synthetic phrase ‘Do you have any allergies to medication?’ and do not enter patient data. First read the exact language readiness label. If it says ‘Ready offline · Apple Translation’, do not tap any Download control or language preparation control: enter the synthetic phrase, tap Translate, verify the conversation shows the original phrase and a Spanish translation preserving the medication-allergy meaning, then open Handoff and verify the bilingual turn plus the machine-translated and unverified safety notice. If the readiness label does not say ‘Ready offline · Apple Translation’, store its exact text as ‘readiness_message’, do not tap Download, do not attempt translation, and report this as an environment-readiness result.
