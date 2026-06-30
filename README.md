# Ruddarr

Ruddarr is a beautifully designed, open source, companion app for Radarr and Sonarr instances written in SwiftUI.

- [App Store](https://apps.apple.com/app/ruddarr/id6476240130)
- [Join the Discord](https://discord.gg/UksvtDQUBA)

## Features

- Manage movies and TV series
- Browse upcoming releases in the calendar
- Receive fine-grained notifications
- View activity queue tasks and history events
- Switch between multiple instances
- Customize the app color scheme and appearance
- Synchronize settings/instances between iCloud
- Automate actions using Siri Shortcuts
- Connect to reverse proxies using custom HTTP headers
- Use Spotlight search to quickly jump to media
- Fully localized, including Simplified Chinese (zh-Hans)

## Building for TrollStore (iOS 17+)

This fork adapts Ruddarr to run on iOS 17+ via TrollStore:

1. Clone and open `Ruddarr.xcodeproj` in Xcode
2. Select the `Ruddarr` scheme with `Any iOS Device` as destination
3. Build with: `xcodebuild build -scheme Ruddarr -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO`
4. Find the `.app` in DerivedData, package as `.ipa`, and install via TrollStore

Key changes from upstream:
- Deployment target lowered to iOS 17.0
- iOS 18/26+ APIs replaced with compatible equivalents
- CloudKit calls disabled in debug builds (no entitlements)
- Subscription features unlocked in debug builds
- Full Simplified Chinese (zh-Hans) translation

## Notifications

Notifications require [Ruddarr+](https://apps.apple.com/app/ruddarr/id6476240130) subscription or debug build.

The notification service code is also [open source](https://github.com/ruddarr/apns-worker).

## URL Schemes

Ruddarr supports the `ruddarr://` URL Scheme to open specific tabs, items or perform actions. All supported schemes are listed in the [`QuickActions.swift`](https://github.com/ruddarr/app/blob/develop/Ruddarr/Dependencies/QuickActions.swift)

## Development

To build the app locally Xcode must be signed into an Apple Account:

```
Xcode → Settings → Accounts
```

Next, select the Apple Account's team for the `Ruddarr` and `NotificationService` targets:

```
Ruddarr → Signing & Capabilities → Targets → {target} -> Signing -> Team
```

Now choose between **a)** creating a provisioning profile on your account for the `iCloud` and `Push Notification` capabilities and skipping the next steps, or **b)** continuing on and removing the capabilities from:

```
Ruddarr → Signing & Capabilities → Targets → Ruddarr
```

Then uncomment the CloudKit mock in `Ruddarr::init()`:

```swift
dependencies.cloudkit = .mock
```

Lastly, change `@CloudStorage` to `@AppStorage` in `AppSettings`:

```diff
- @CloudStorage("instances") var instances: [Instance] = []
+ @AppStorage("instances") var instances: [Instance] = []
```

That's it. Select a run destination and build it. 

### Sentry Symbols

Create a `.sentryclirc` file:

```yml
[auth]
token=sntrys_eyJp...
```

### Reset Xcode

```bash
sudo xcode-select -s /Applications/Xcode.app
xcrun simctl --set previews delete all
```
