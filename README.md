# Ruddarr

> Ruddarr is a beautifully designed, open source, companion app for Radarr and Sonarr instances written in SwiftUI.
> Ruddarr 是一款设计精美、开源的 Radarr/Sonarr 配套应用，使用 SwiftUI 构建。

- [App Store](https://apps.apple.com/app/ruddarr/id6476240130)
- [Discord](https://discord.gg/UksvtDQUBA)

## Features / 功能

- Manage movies and TV series / 管理电影和剧集
- Browse upcoming releases in the calendar / 日历中浏览即将发布的资源
- Receive fine-grained notifications / 接收细粒度推送通知
- View activity queue tasks and history events / 查看活动队列和历史事件
- Switch between multiple instances / 多实例切换
- Customize the app color scheme and appearance / 自定义配色和外观
- Automate actions using Siri Shortcuts / 使用 Siri 捷径自动化操作
- Connect to reverse proxies using custom HTTP headers / 通过自定义 HTTP 头连接反向代理
- Use Spotlight search to quickly jump to media / 使用 Spotlight 快速跳转到媒体
- Fully localized, ready to be translated / 完整本地化，支持多语言翻译

## TrollStore Build / 巨魔构建

本项目包含 GitHub Actions 工作流，可自动构建适用于 TrollStore 的无签名 IPA 包。

This project includes a GitHub Actions workflow that builds an unsigned IPA for TrollStore installation.

### 工作流自动修改 / Workflow Modifications

工作流在构建过程中自动进行以下修改，以确保在 TrollStore 环境下正常运行：

The workflow automatically applies the following patches during the build:

| 修改 / Change | 文件 / File | 说明 / Description |
|---|---|---|
| 注入备用图标 | `Info.plist` | 无签名编译丢失 `CFBundleAlternateIcons`，通过 PlistBuddy 注入 |
| 强制解锁订阅 | `Subscription.swift` | `entitledToService()` 等方法强制返回 `true`，解锁全部图标和通知选项 |
| 禁用 CloudKit | `Ruddarr.swift` | 检测无 `embedded.mobileprovision` 时自动设置 `dependencies.cloudkit = .mock` |
| 替换 CloudStorage | `AppSettings.swift` | `@CloudStorage` → `@AppStorage`，实例数据改用 UserDefaults 存储 |
| 禁用通知 | 多处 | 无合法推送证书，强制关闭通知开关和 Webhook 同步 |
| 清洗权限文件 | `.entitlements` | 剔除 `aps-environment` 及全部 iCloud/CloudKit 权限 |
| 原生 codesign 重签 | `.app` | 使用 macOS 自带工具对主程序和扩展进行 Ad-Hoc 重签 |

### 构建产物 / Build Artifacts

Push 到 `develop` 或 `main` 分支后，GitHub Actions 会自动构建并将 `Ruddarr.ipa` 上传为 Artifact。

After pushing to `develop` or `main`, GitHub Actions builds and uploads `Ruddarr.ipa` as an artifact.

### 本地开发 / Local Development

要在本地构建（无 iCloud / 推送权限），需手动进行以下操作：

To build locally without iCloud / push capabilities, apply these changes manually:

1. 取消 CloudKit mock 注释 / Uncomment CloudKit mock in `Ruddarr.swift:init()`：
```swift
dependencies.cloudkit = .mock
```

2. 替换实例存储方式 / Change instance storage in `AppSettings.swift`：
```diff
- @CloudStorage("instances") var instances: [Instance] = []
+ @AppStorage("instances") var instances: [Instance] = []
```

3. 在 Xcode 中移除 iCloud 和 Push Notification 能力 / Remove iCloud and Push Notification capabilities in Xcode：
```
Ruddarr → Signing & Capabilities → Targets → Ruddarr
```

## Localization / 本地化

Help [translate Ruddarr](https://crowdin.com/project/ruddarr) into any language. Check the `#translators` channel [on Discord](https://discord.gg/UksvtDQUBA).

协助[翻译 Ruddarr](https://crowdin.com/project/ruddarr)为任何语言。查阅 [Discord](https://discord.gg/UksvtDQUBA) 上的 `#translators` 频道。

Unfortunately, [some messages](https://github.com/ruddarr/app/issues/433) cannot be localized by Ruddarr.

## Notifications / 通知

通知服务的代码同样[开源](https://github.com/ruddarr/apns-worker)。

The notification service is also [open source](https://github.com/ruddarr/apns-worker).

> **TrollStore 注意：** 推送通知在无证书签名的环境下不可用。设备缺少合法的 APNs 凭据和配置文件，应用已自动禁用相关功能以避免服务器错误。

> **TrollStore Note:** Push notifications are unavailable without valid code signing. The app disables notification features automatically on unsigned builds.

## URL Schemes

Ruddarr supports the `ruddarr://` URL Scheme to open specific tabs, items or perform actions. All supported schemes are listed in [`QuickActions.swift`](https://github.com/ruddarr/app/blob/develop/Ruddarr/Dependencies/QuickActions.swift).

## Development / 开发

Xcode 需登录 Apple Account：

Xcode must be signed into an Apple Account:

```
Xcode → Settings → Accounts
```

为 `Ruddarr` 和 `NotificationService` targets 选择 Team：

Select the Apple Account's team for the `Ruddarr` and `NotificationService` targets:

```
Ruddarr → Signing & Capabilities → Targets → {target} → Signing → Team
```

### Sentry Symbols

创建 `.sentryclirc` 文件 / Create a `.sentryclirc` file:

```yml
[auth]
token=sntrys_eyJp...
```

### 重置 Xcode / Reset Xcode

```bash
sudo xcode-select -s /Applications/Xcode.app
xcrun simctl --set previews delete all
```

## Project Structure / 项目结构

```
Ruddarr/
├── Dependencies/     # 依赖注入和服务抽象
├── Models/           # 数据模型 (Instance, Movie, Series, Queue)
├── Services/         # 业务服务 (Notifications, Subscription, Telemetry)
├── Utilities/        # 工具函数和扩展
├── Views/            # SwiftUI 视图
│   ├── Settings/     # 设置面板（实例管理、图标、通知）
│   ├── Movies/       # 电影相关视图
│   ├── Series/       # 剧集相关视图
│   ├── Calendar/     # 日历视图
│   └── Activity/     # 活动和队列视图
├── Assets.xcassets/  # 资源文件（图标、颜色）
├── Preview Content/  # SwiftUI 预览数据
└── Info.plist        # 应用配置
NotificationService/  # 通知服务扩展
```
