# ConnActivityMobile

## contributing
- use dart format
- for testing: add own fingerprint of sign-key to project (android only) via firebase-console

get sha-1 and sha-256 fingerprint: ```keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android```

## signing
For now, dev-builds will be signed by each developers own key. A different key will be used for builds uploaded to Google Play. Builds by GitHub actions cannot communicate with firebase, etc.
