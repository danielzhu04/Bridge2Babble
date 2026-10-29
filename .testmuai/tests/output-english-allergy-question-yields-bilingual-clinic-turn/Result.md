---
test: ../english-allergy-question-yields-bilingual-clinic-turn_test.md
status: failed
started: 2026-10-24T20:26:07.841Z
duration_s: 403
session_id: aae7f10d-dc4d-4c3f-a4f5-78ec3104265e
---

# English allergy question yields bilingual clinic turn — Result

## Step 1 ✓ passed (48.9s)
md5: 414ff0b15eacc8595ef6e8f418f8f17e
Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination, then assert both selected languages are supported and selected.

## Step 2 ✗ failed (310.6s)
md5: 97f85bb9df4002f06c813c3358244843
Reason: AP determined agent is stuck — no viable actions remain — bug verdict: Language download was used before completion [automation_bug/timing_sync, confidence 0.96]
In the conversation's typed phrase input, enter “Do you have any allergies to medication?” and translate it, then assert the conversation displays the original question and a Spanish translation asking whether the patient has any medication allergies.
