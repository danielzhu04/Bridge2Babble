# Bridge2Babble — MVP requirements

## Product purpose

Bridge2Babble is a free native iPhone push-to-talk translator for volunteer-run free clinics and people who need everyday language help. A volunteer and patient take turns holding the microphone, speaking, and receiving a transcription, translation, and spoken translation. The MVP demonstrates English–Spanish clinical intake and medication/allergy screening, while its language architecture supports other installed offline language pairs.

## Privacy and clinical boundaries

- Translation, speech recognition, and speech playback are performed on the iPhone using Apple on-device capabilities when the needed language resources are available.
- Conversations do not leave the device. The app does not create a cloud account, transmit the conversation, or sync it to a server.
- Conversation turns live only in memory. A conversation is automatically deleted after 30 minutes of inactivity, and the user can clear it at any time.
- A clinician handoff is a local, same-device review screen, not a separate clinician login, cloud service, medical record, EHR export, or diagnosis tool.
- The handoff must visibly say that it is machine-translated and unverified. It supports—but never replaces—a qualified interpreter for consent, diagnosis, urgent decisions, or other high-stakes communication.

## Core translation flow

1. The user selects a source and destination language from supported languages.
2. The user can type a phrase and tap Translate. Translate is disabled while the input is empty or a translation is running.
3. The app adds the original phrase and its translation to the on-device conversation.
4. The user can hold the microphone to record a turn. After recording stops, the app transcribes, translates, and shows the results in the conversation.
5. In debug builds, a Sample phrase action runs a bundled audio clip through the same transcription and translation pipeline so the flow can be verified in an iOS simulator without a microphone.
6. Each translated turn can be replayed with a speaker control. An auto-speak preference controls whether new translations play automatically.
7. The user can swap the source and destination languages and can clear the conversation.

## Offline language readiness

- For a selected language pair, the UI reports one of: Ready offline, Needs download, or Not supported.
- The language-download action appears only when a download is needed.
- Once a supported language pack is installed, the user can translate without a network connection.

## Local clinic handoff preview

- The Handoff control is unavailable until at least one conversation turn exists.
- The preview shows a safety notice, encounter purpose (clinic intake and medication-allergy screening), the selected language pair, on-device status, an automatic deletion time, and the bilingual conversation turns.
- The preview includes clinician review guidance but must not infer diagnoses, create a clinical record, or claim that the translation was verified.

## Acceptance focus for the first Kane slice

The first automated slice should establish that an English phrase, “Do you have any allergies to medication?”, can be typed, translated to Spanish, shown in the conversation, and made available through the local handoff preview with the machine-translated/unverified notice. Translation phrasing may vary when it preserves the meaning.

Subsequent Kane-designed coverage should cover push-to-talk through the debug Sample phrase path, language swap, language-readiness states, replay and auto-speak, disabled/clear guard rails, and automatic deletion.

## Kane hybrid verification environment

- Use only synthetic phrases in Kane runs; no patient conversation or other sensitive data may be entered into TestMu AI.
- Simulator test members use the iOS simulator target on iPhone 17 Pro, iOS 26.5, with the app package at `build/Bridge2Babble.zip`.
- Simulator coverage may prove controls, navigation, guard rails, and other observable UI behavior. It must not claim that a meaning-preserving translation was proven when the simulator lacks the Apple translation or Apple Intelligence model assets.
- A separate real-cloud-iPhone test member uses the iOS target and a signed `build/Bridge2Babble.ipa` to prove the English allergy question produces a meaning-preserving Spanish translation and the resulting local handoff preview shows the unverified-translation notice.
- The real-device test must report the allocated device and its model-readiness result. If the required Apple model assets are unavailable, classify the run as an environment issue rather than changing the app or weakening its assertion.
