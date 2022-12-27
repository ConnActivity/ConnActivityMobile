# ConnActivityMobile

## contributing
- use ```dart format```
- for testing: add own fingerprint of sign-key to project (android only) via firebase-console or use the provided debug.keystore from discord

get sha-1 and sha-256 fingerprint: ```keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android```

## android signing
For now, dev-builds will be signed by each developers own key or the debug.keystore provided on discord. A different key will be used for builds uploaded to Google Play. Builds by GitHub actions cannot communicate with firebase, etc.
