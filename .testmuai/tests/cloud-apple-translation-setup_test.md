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

# Session: cloud-apple-translation-setup

## Step 1
Launch Bridge2Babble on this real iPhone. Confirm English is selected as the source language and Spanish is selected as the destination language. Do not use Apple Intelligence. If the app says the language pair needs a download, tap its Download or Prepare Offline control and allow the system translation download if it is offered. Wait for completion, then verify whether the status becomes 'Ready offline' using Apple Translation. If downloading is unavailable or fails, record the exact visible error or readiness status. Do not enter any patient data.
