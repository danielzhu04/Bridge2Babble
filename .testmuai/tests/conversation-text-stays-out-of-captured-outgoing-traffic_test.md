---
assurance:
  id: t-6
  base: sha256:f17ddaacf65852c4d8736238fc420b904fcd2aea84643a54f1433dcd49980778
target: simulator
---

# Conversation text stays out of captured outgoing traffic

> Translate the named English allergy question and establish the conversation is not transmitted or synced to a server and no cloud account is created.

## Step 1

Launch Bridge2Babble on the iPhone simulator in an environment capturing the app's own network traffic; from its entry screen, open the translation conversation and select English as source and Spanish as destination.

## Step 2 @verifies ac-1, ac-8

Enter “Do you have any allergies to medication?” in the typed phrase input and translate it; inspect the conversation and captured outgoing app traffic, then assert the original question appears in the conversation but no outgoing transmission contains a conversation turn.
