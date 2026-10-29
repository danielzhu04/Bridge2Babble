---
assurance:
  id: t-2
  base: sha256:471913d9a6b2c10e8877bd95664bc8a1ddc36e7b98785a6e2f4a6defb0bca416
target: simulator
---

# Empty typed input disables Translate

> With no typed input, Translate is disabled.

## Step 1

Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination.

## Step 2 @verifies ac-10

On the conversation's typed phrase input, remove any existing input so the field is empty, then assert Translate is disabled.
