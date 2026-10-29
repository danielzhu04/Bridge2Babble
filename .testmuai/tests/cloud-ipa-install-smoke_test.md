---
mode: testing
max_steps: 50
timeout: 900
target: ios
app: APP1016040991792873567451356
os_version: '26'
device_name: iPhone 17 Pro
variables:
  global.spanish_clinic_phrase:
    value: ¿Tiene alergias a algún medicamento?
    secret: false
    syntax: '{{spanish_clinic_phrase}}'
    type: global
---

# Session: cloud-ipa-install-smoke

## Step 1
Launch Bridge2Babble on this real iPhone. Allow microphone and speech-recognition permissions if prompted. Verify English is selected as the source language and Spanish as the destination language. Enter the synthetic phrase 'Do you have any allergies to medication?' in the typed input and tap Translate. Report whether the conversation shows the original phrase plus a Spanish translation, or whether the app reports a model or language-readiness error. Do not enter or retain any real patient data.
