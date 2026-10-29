---
mode: testing
max_steps: 50
timeout: 600
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

# Session: bridge2babble-cloud-ready-translation-handoff

## Step 1
Launch Bridge2Babble on a real cloud iPhone where English to Spanish already shows Ready offline with Apple Translation. Use only the synthetic phrase ‘Do you have any allergies to medication?’ and do not enter patient data. Verify English is the source and Spanish is the destination. Enter the synthetic phrase, tap Translate, and verify the conversation shows the original phrase and a Spanish translation preserving the medication-allergy meaning. Open Handoff and verify the bilingual turn is visible and the safety notice says the translation is machine-translated and unverified.
