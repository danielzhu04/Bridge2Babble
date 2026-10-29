---
assurance:
  id: t-7
  base: sha256:82bfcdff6a4ed5037d3d46e92bb797e4eee16e5ab04f368dd5c0f4e39765ed39
target: simulator
---

# Spanish typed phrase translates into English

> After selecting Spanish as source and English as destination, show the original Spanish phrase and English translation in the conversation.

## Step 1

Launch Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select Spanish as source and English as destination.

## Step 2 @verifies ac-19, ac-20

Enter {{spanish_clinic_phrase}} into the conversation's typed phrase input and translate it, then assert the original Spanish phrase and its English translation appear in the conversation.
