---
assurance:
  id: t-3
  base: sha256:ad532218bebd62113117c896bb22bdcb810e1294124e5a4a165a1a1e7d7654ab
target: simulator
---

# Running translation disables Translate

> While a typed translation is running, Translate is disabled.

## Step 1

Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination.

## Step 2 @verifies ac-11

Enter “Do you have any allergies to medication?” in the typed phrase input and start translation; while it is running, then assert Translate is disabled.
