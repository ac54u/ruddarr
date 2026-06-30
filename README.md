# Ruddarr

Ruddarr is a beautifully designed, open source, companion app for Radarr and Sonarr instances written in SwiftUI.

Ruddarr 是一款专为 Radarr/Sonarr 设计的精美开源 SwiftUI 客户端。

- [App Store](https://apps.apple.com/app/ruddarr/id6476240130)
- [Join the Discord](https://discord.gg/UksvtDQUBA)

## Features / 功能

- Manage movies and TV series / 管理电影和剧集
- Browse upcoming releases in the calendar / 浏览日历中的即将发布
- Receive fine-grained notifications / 接收细粒度通知
- View activity queue tasks and history events / 查看活动队列和历史
- Switch between multiple instances / 多实例切换
- Customize the app color scheme and appearance / 自定义配色和外观
- Synchronize settings/instances via iCloud / iCloud 同步设置
- Automate actions using Siri Shortcuts / Siri 快捷指令自动化
- Connect to reverse proxies using custom HTTP headers / 自定义 HTTP 头连接反向代理
- Use Spotlight search to quickly jump to media / Spotlight 搜索快速跳转
- Fully localized, including Simplified Chinese (zh-Hans) / 完整中文本地化

## Building for TrollStore (iOS 17+) / 为 TrollStore 构建 (iOS 17+)

This fork adapts Ruddarr to run on iOS 17+ via TrollStore:

此分支将 Ruddarr 适配到 iOS 17+ 以通过 TrollStore 安装：

1. Clone and open `Ruddarr.xcodeproj` in Xcode
2. Select the `Ruddarr` scheme with `Any iOS Device` as destination / 选择 Ruddarr scheme，目标为 Any iOS Device
3. Build: `xcodebuild build -scheme Ruddarr -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO`
4. Find the `.app` in DerivedData, package as `.ipa`, and install via TrollStore / 在 DerivedData 中找到 .app，打包为 .ipa 通过 TrollStore 安装

Key changes from upstream / 相比上游的主要改动:
- Deployment target lowered to iOS 17.0 / 部署目标降至 iOS 17.0
- iOS 18/26+ APIs replaced with compatible equivalents / 替换 iOS 18/26+ 专有 API
- CloudKit calls disabled in debug builds (no entitlements) / 调试版禁用 CloudKit
- Subscription features unlocked in debug builds / 调试版解锁订阅功能
- Full Simplified Chinese (zh-Hans) translation / 完整简体中文本地化

## Notifications / 通知

Notifications require [Ruddarr+](https://apps.apple.com/app/ruddarr/id6476240130) subscription or debug build.

通知需要 Ruddarr+ 订阅或调试版。

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
