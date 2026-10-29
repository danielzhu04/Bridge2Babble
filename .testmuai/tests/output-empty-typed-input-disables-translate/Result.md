---
test: ../empty-typed-input-disables-translate_test.md
status: passed
started: 2026-10-24T21:55:37.461Z
duration_s: 134
session_id: af5f9b89-e5b6-4f6b-817a-2ff518c0ca21
---

# Empty typed input disables Translate — Result

## Step 1 ✓ passed (72.9s)
md5: 3a33842b53c385d485899c01884a0741
Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination.

## Step 2 ✓ passed (33.8s)
md5: 7fd1b9fa9713a5def35c18e9c4f6a268
On the conversation's typed phrase input, remove any existing input so the field is empty, then assert Translate is disabled.
