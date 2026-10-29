---
mode: testing
max_steps: 50
timeout: 600
target: ios
app: APP10160332171792877410015558
os_version: '18'
device_name: iPhone 13
variables:
  global.spanish_clinic_phrase:
    value: ¿Tiene alergias a algún medicamento?
    secret: false
    syntax: '{{spanish_clinic_phrase}}'
    type: global
---

# Session: bridge2babble-ios18-semantic-gated

## Step 1
Launch Bridge2Babble on an iPhone 13 running iOS 18. Use only the synthetic phrase ‘Do you have any allergies to medication?’ and do not enter patient data. First read the exact language readiness label. If it says ‘Ready offline · Apple Translation’, do not tap any Download control or language preparation control: enter the synthetic phrase, tap Translate, verify the conversation shows the original phrase and a Spanish translation preserving the medication-allergy meaning, then open Handoff and verify the bilingual turn plus the machine-translated and unverified safety notice. If the readiness label does not say ‘Ready offline · Apple Translation’, store its exact text as ‘readiness_message’, do not tap Download, do not attempt translation, and report this as an environment-readiness result.
