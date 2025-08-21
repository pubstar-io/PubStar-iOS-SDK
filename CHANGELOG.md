# Changelog
All notable changes to **PubStar iOS Mobile AD SDK** will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Minimum requirements (from README): iOS >= 13.0, Swift >= 4.0

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
  - `PubStarUtils.getHostingViewController()` for SwiftUI and UIKit.
  - SwiftUI helper `getViewControllerPubStar { controller in ... }`.

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

