---
assurance:
  id: t-1
  base: sha256:bb896a9e953c1c799d10030895751cd382622f33609b919f31e47740f7e010c9
target: simulator
---

# English allergy question yields bilingual clinic turn

> With English as source and Spanish as destination, type the named allergy question and show its original plus meaning-preserving Spanish translation in the conversation.

## Step 1 @verifies ac-6, ac-7

Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination, then assert both selected languages are supported and selected.

## Step 2 @verifies ac-8, ac-9

In the conversation's typed phrase input, enter “Do you have any allergies to medication?” and translate it, then assert the conversation displays the original question and a Spanish translation asking whether the patient has any medication allergies.
