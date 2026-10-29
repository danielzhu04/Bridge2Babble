---
mode: testing
max_steps: 50
timeout: 900
target: ios
app: APP1016040991792873567451356
os_version: '27'
device_name: iPhone 18 Pro
variables:
  global.spanish_clinic_phrase:
    value: ¿Tiene alergias a algún medicamento?
    secret: false
    syntax: '{{spanish_clinic_phrase}}'
    type: global
---

# Session: cloud-apple-intelligence-iphone18

## Step 1
Launch Bridge2Babble on this real iPhone 18 Pro. Do not download Apple Translation language resources. Confirm English is the source and Spanish is the destination. Enter the synthetic phrase 'Do you have any allergies to medication?' and tap Translate. Verify whether a Spanish translation appears and is labeled or reported as using Apple Intelligence. If it does not, record the exact visible Apple Intelligence availability or translation error. Do not enter any patient data.
