# macOS Device Testing

This project is developed on Windows, but iPhone testing requires macOS because Apple signing, packaging, and device install are handled by Xcode.

## Goal

Use macOS only as a build/sign/install station for testing the app on a real iPhone.

## What Must Be On macOS

Xcode needs the complete project folder, not just a compiled executable, because it must:

- compile the Swift sources
- bundle local resources
- create the iOS app package
- sign the app with an Apple development team
- install the signed app on the connected iPhone

## One-Time Setup

1. Install Xcode from the Mac App Store.
2. Open Xcode once and accept any first-run setup prompts.
3. Add your Apple ID in `Xcode > Settings > Accounts`.
4. Copy or clone this repo onto the Mac.

If using git:

```bash
git clone <repo-url> AsianLanguage
cd AsianLanguage
open AsianLanguage.xcodeproj
```

If using a copied folder, copy the whole repo folder, including:

- `AsianLanguage.xcodeproj`
- `Sources`
- `Resources`
- `Tests`
- project docs and tool files

## First Phone Run

1. Connect the iPhone to the Mac by USB.
2. Trust the Mac on the iPhone if prompted.
3. Open `AsianLanguage.xcodeproj` in Xcode.
4. Select the `AsianLanguage` scheme.
5. Select the connected iPhone as the run destination.
6. In the app target signing settings, choose your Apple development team.
7. Press `Cmd+R` or choose `Product > Run`.

Xcode will build, sign, install, and launch the app on the phone.

## Repeat Testing After Windows Changes

After making changes on Windows:

1. Push or copy the updated project to the Mac.
2. On the Mac, update the repo.

```bash
cd AsianLanguage
git pull
open AsianLanguage.xcodeproj
```

3. Press `Cmd+R` in Xcode with the iPhone selected.

## What To Report Back

When a phone build fails, bring back the first real error, especially:

- Swift compiler error with file and line number
- signing or provisioning error text
- runtime crash message
- screenshot of incorrect app behavior

Do not paste the full Xcode log unless the first error is unclear.

## Notes

- A standalone iOS executable cannot be copied to an iPhone and run directly.
- A signed `.ipa` can be distributed through TestFlight or other Apple-supported signing flows, but creating that package still requires macOS/Xcode or Apple build infrastructure.
- Development remains Windows-first; macOS is only required for iOS build, signing, simulator, and device testing.
