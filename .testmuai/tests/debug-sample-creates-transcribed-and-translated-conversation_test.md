---
assurance:
  id: t-4
  base: sha256:b0e4c874df65b442ea963170321dde612dda9c3511ed22816f2a1c225016e622
target: simulator
---

# Debug Sample creates transcribed and translated conversation turn

> Run bundled Sample phrase through transcription and translation without a microphone and show the resulting turn.

## Step 1

Launch a debug build of Bridge2Babble on the iPhone simulator; from its entry screen, open the translation conversation and select English as source and Spanish as destination.

## Step 2 @verifies ac-14, ac-15

In the conversation, run the Sample phrase action using its bundled audio rather than holding the microphone, then assert the conversation displays a transcription of the Sample audio and its translation.
