---
mode: testing
max_steps: 50
timeout: 480
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

# Session: iphone18-ai-readiness-probe-2

## Step 1
Launch Bridge2Babble on the allocated iPhone 18 Pro. Do not download Apple Translation resources. With English as source and Spanish as destination, enter the synthetic phrase 'Do you have any allergies to medication?' and tap Translate. Record only whether Apple Intelligence produces a Spanish translation. If not, record the exact readiness message. Do not enter patient data.
