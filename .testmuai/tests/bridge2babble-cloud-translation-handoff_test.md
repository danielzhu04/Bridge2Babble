---
mode: testing
max_steps: 50
timeout: 900
target: ios
app: APP10160332171792877410015558
os_version: '27'
device_name: iPhone 18 Pro
variables:
  global.spanish_clinic_phrase:
    value: ¿Tiene alergias a algún medicamento?
    secret: false
    syntax: '{{spanish_clinic_phrase}}'
    type: global
---

# Session: bridge2babble-cloud-translation-handoff

## Step 1
Launch Bridge2Babble on this real cloud iPhone. Use only the synthetic phrase ‘Do you have any allergies to medication?’; do not enter patient data. Confirm English is the source and Spanish is the destination. Prefer Apple Translation, not Apple Intelligence: if the app offers a language download, tap Download and accept the system prompt, then wait for the language status to show Ready offline. Enter the synthetic phrase, tap Translate, and verify the conversation shows the original phrase plus a Spanish translation that preserves the medication-allergy meaning. Open Handoff and verify it shows the bilingual turn and a visible notice that the translation is machine-translated and unverified. If an Apple language resource remains unavailable, record the exact visible readiness message and do not change the app.
