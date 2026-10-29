---
mode: testing
max_steps: 50
timeout: 300
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

# Session: bridge2babble-cloud-readiness-current-ipa

## Step 1
Launch Bridge2Babble on a real cloud iPhone. Use no patient data and do not tap Download. Verify English is the source language and Spanish is the destination language. Store the exact visible language readiness label as 'readiness_message', then verify the label states that this language pair needs a download. This is an environment-readiness check only; do not attempt translation or change app settings.
