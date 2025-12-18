# Changelog
All notable changes to **Pubstar iOS Mobile AD SDK** will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Minimum requirements (from README): iOS >= 13.0, Swift >= 4.0

## [1.3.1] - 2025-11-25
### Fixed
- Resolved an issue where the SDK failed to fetch resources from the CDN under certain network conditions.
- Fixed a Pod installation conflict caused by duplicated imports of `Google-Mobile-Ads-SDK`, ensuring clean dependency resolution during integration.

## [1.3.0] - 2025-11-17
### Added
- **Modular Adapter Architecture**
  - Introduced a brand-new **Adapter Architecture** designed to make each ad network modular and optional.
  - Each ad network integration is packaged as an independent adapter, allowing:
    - Smaller final app size (only integrate the adapters you need).
    - Faster build time thanks to decoupled frameworks.
    - Ability to dynamically add new ad network partners without modifying the Pubstar core.
    - Cleaner separation of concerns between Pubstar Core and external ad networks.

- **Default Built-in Ad Network Partners**
  Pubstar 1.3.0 ships with three official adapters enabled by default:

  **1. Google AdMob Adapter**

  Supports Banner, Interstitial, Rewarded, AppOpen.

  **2. AppLovin MAX Adapter**

  Supports Banner, MREC, Interstitial, Rewarded.

  **3. Prebid Adapter**

  Supports Banner, Interstitial, Native via Prebid Demand.
  Designed to handle bidding workflow and demand fetching automatically.

- **Dynamic Adapter Discovery**

  Pubstar Core automatically detects which adapters are included in the host app.

  This allows developers to ship different app variants (Lite / Full / Region-specific) without code changes.

### Changed
- Refactored the entire project into a single public distribution artifact: `Pubstar.xcframework`

  Internally, Pubstar includes multiple private adapters (AdMob, AppLovin, Prebid), but developers only integrate one file.
All complex ad logic—including adapter selection, initialization, bidding, waterfalling, error handling— is automatically handled by the SDK.

- Updated documentation to reflect the simplified integration process:

  - Only install Pubstar.xcframework.

  - No need to manually integrate individual network SDKs or adapters.

  - Pubstar automatically manages everything under the hood.

- Improved internal load-flow coordination to optimize latency and fill rate across all supported networks.

- Unified placement configuration so developers configure ads once, while Pubstar manages the multi-network pipeline automatically.



## [1.2.2] - 2025-12-18
### Added
- **Prebid Mediation**
  - Added mediation support between Prebid and Google AdMob, AppLovin MAX, and Google Ad Manager (GAM).
  - Enables Prebid demand to compete in the mediation stack for supported formats without additional integration work.
  - Configuration is handled at the Pubstar level so existing placements can be upgraded to Prebid Mediation with minimal changes.

## [1.1.8] - 2025-05-25
### Added
- **SDK Initialization** via  
  `initAd()`.  
  - Listener: `InitAdListenerHandler` with `onDone` and `onError(ErrorCode)`.

- **Ad Loading** with  
  `load(context:key:)`.  
  `load(key:adRequest:)`.  
  `load(context:key:adLoaderListener:)`.  
  - Listener: `AdLoaderListener` with `onLoaded` and `onError(ErrorCode)`.

- **Ad Showing** with  
  `show(context:key:)`.  
  `show(context:key:view:)`.  
  `show(key:adRequest:)`.  
  `show(context:key:view:adShowedListener:)`.  
  - Listener: `AdShowedListener` with:
  - `onAdShowed`
  - `onAdHide(RewardModel)`
  - `onError(ErrorCode)`

- **Load and Show in one step** using  
  `loadAndShow(context:key:)`.
  `loadAndShow(context:key:view:)`.
  `loadAndShow(context:key:view:adLoaderListener:adShowedListener:)`.
  `loadAndShow(context:key:adRequest:)`.

- **Banner Ads** with  
  `BannerAdRequest.Builder(...)` supporting:
  - `isAllowLoadNext(_:)` (preload next after dismissal)
  - `withView(_:)` (attach to optional UIView)
  - `tag(_:)` (banner size/variant)
  - `adLoaderListener(_:)` and `adShowedListener(_:)`  
  Executed via `loadAndShow(key:adRequest:)`.

- **Native Ads** with  
  `NativeAdRequest.Builder(...)` supporting:
  - `sizeType(_:)` (banner size/variant) 
  - `withView(_:)` (attach to optional UIView)
  - `adLoaderListener(_:)`and `adShowedListener(_:)`  
  Executed via `loadAndShow(key:adRequest:)`.

- **Utilities for ViewController access**:
  - `PubstarUtils.getHostingViewController()` for SwiftUI and UIKit.
  - SwiftUI helper `getViewControllerPubstar { controller in ... }`.

- **Configuration documentation**:
  - Info.plist setup for `GADApplicationIdentifier`, `NSUserTrackingUsageDescription`, and `NSAppTransportSecurity`.

- **Troubleshooting guide**:
  - Fix for `Operation not permitted` build error by disabling `User Script Sandbox`.

- **CocoaPods installation**:
  - Official support with `pod 'Pubstar'`.

### Changed
- Documentation updated with unified API naming between SwiftUI and UIKit.
- Examples for using `UIViewRepresentable` to access `UIView` and `UIViewController` in SwiftUI.

### Fixed
- Clarified minimum requirements: iOS 13.0, Swift >= 4.0.
- Expanded listener usage examples to prevent null callbacks.

### Security
- Strongly recommended explicit `NSUserTrackingUsageDescription` configuration for ATT/Privacy compliance.

