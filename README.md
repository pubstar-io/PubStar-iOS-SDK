# PubStar iOS Mobile AD SDK

PubStar Mobile AD SDK is a comprehensive software development kit designed to empower developers with robust tools and functionalities for integrating advertisements seamlessly into iOS mobile applications. Whether you're a seasoned developer or a newcomer to the world of app monetization, our SDK offers a user-friendly solution to maximize revenue streams while ensuring a non-intrusive and engaging user experience.

## TOC

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting problems](#troubleshooting-problems)
- [Release Notes](#release-notes)
- [ID Test Ad](#id-test-ad)
- [Support](#support)


## Requirements

- iOS >= 13.0
- Swift >= 4.0


## Installation

### CocoaPods

1. If you haven't set up CocoaPods, run `pod init` in your project directory.
2. In your Podfile, add Pubstar dependencies:

```ruby
target 'YourAppName' do
    # Add this line to use the latest version of PubStar SDK
    pod 'Pubstar'

end
```

3. Install the dependencies using `pod install`.
4. Open your project in Xcode with the `.xcworkspace` file.


## Configuration

### 1. Update your Info.plist

Update your app's Info.plist file to add two keys:

A GADApplicationIdentifier key with a string value of your AdMob app ID [found in the AdMob UI](https://support.google.com/admob/answer/7356431).

```xml
<key>GADApplicationIdentifier</key>
<string>Your AdMob app ID</string>
<key>NSUserTrackingUsageDescription</key>
<string>We use your data to show personalized ads and improve your experience.</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```


## Usage

Here's how to add Pubstar to your project (works for both SwiftUI and UIKit):

### API

The example app in this repository shows an example usage of every single API, consult the example app if you have questions, and if you think you see a problem make sure you can reproduce it using the example app before reporting it, thank you.

| Method                                                              | Return Type              |
| ------------------------------------------------------------------- | ------------------------ |
| [getHostingViewController()](#get-uiviewcontroller)                 | `func<UIViewController>` |
| [getViewControllerPubStar()](#get-uiviewcontroller)                 | `func<UIViewController>` |
| [initAd()](#initad)                                                 | `func<void>`             |
| [load()](#load)                                                     | `func<void>`             |
| [show()](#show)                                                     | `func<void>`             |
| [loadAndShow()](#loadandshow)                                       | `func<void>`             |
| [Banner](#banner)                                                   | `func<void>`             |
| [Native](#native)                                                   | `func<void>`             |


#### Get UIViewController
1 If you want to get the current UIViewController in SwiftUI, you can use the following code:

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()
```


2 If you want to use callback to get the UIViewController, you can use the following code:

```swift
struct UIViewGetter: UIViewRepresentable {
    let onReceive: (UIView) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            self.onReceive(view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ContentView: View {
    @State private var viewController: UIViewController?

    var body: some View {
        VStack {
            Color.gray.opacity(0.1)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(
                    UIViewGetter { view in
                        self.customView = view
                    }
                )
        }
        .getViewControllerPubStar { controller in
            viewController = controller
        }
    }
}
```



### initAd()

Initialization Pubstar SDK.

#### Event

`InitAdListenerHandler`

| Callback                             | Function                                                      |
| ------------------------------------ | ------------------------------------------------------------- |
| `onDone`                             | call when Pubstar SDK initializes successfully                |
| `onError`                            | call when load ad failed. return object type `ErrorCode`      |

#### Example

```swift
import Pubstar

struct ContentView: View {
    
    init() {
        PubStarAdManager.getInstance()
            .setInitAdListener(InitAdListenerHandler(
                onDone: {
                    print("Pubstar", "onDone")
                },
                onError: { errorCode in
                    print("Pubstar", "\(errorCode)")
                }
            ))
            .initAd()
    }


    var body: some View {
        VStack {
            Text("Hello, Pubstar's publisher")
        }
    }
}
```

### load()

Load Pubstar ads by `Advertisement Id` to application.

#### Event

`AdLoaderListener`

| Callback                             | Function                                                      |
| ------------------------------------ | ------------------------------------------------------------- |
| `onError`                            | call when load ad failed. return object type `ErrorCode`      |
| `onLoaded`                           | call when ad loaded                                           |

#### Example

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()

// *** with no callback ***
PubStarAdManager.getAdController()
    .load(
        context: viewController,
        key: "Your_Ads_Key"
    )


// *** with callback ***
let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

PubStarAdManager.getAdController()
    .load(
        context: viewController!, 
        key: "Your_Ads_Key", 
        adLoaderListener: adLoaderListener
    )
```


### show()

Show ad had loaded before.

#### Event

`AdShowedListener`

| Callback             | Function                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------ |
| `onAdHide`           | call when ad hidden/closed (supports rewarded ads). Returns detailed `RewardModel` object. |
| `onAdShowed`         | call when ad showed                                                                        |
| `onError`            | call when show ad failed. return object type `ErrorCode`                                   |

#### Example

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()
@State private var customView: UIView?

// *** with no callback ***
PubStarAdManager.getAdController()
    .show(
        context: viewController!,
        key: "Your_Ads_Key",
        view: customView  // view has optional
    )

// *** with callback ***
let adShowListener: AdShowedListener = AdShowedHandler {
    // callback when ad showed
} onHide: { result in
    // callback when ad hide
} onError: { error in
    // callback when error
}

PubStarAdManager.getAdController()
    .show(
        context: viewController,
        key: "Your_Ads_Key",
        view: customView, // view has optional
        adShowedListener: adShowListener
    )
```


### loadAndShow()

Load and immediately show an ad by ID.

#### Event

`AdLoaderListener`
`AdShowedListener`

#### Example

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()
@State private var customView: UIView?

// *** with no callback ***
PubStarAdManager.getAdController()
    .loadAndShow(
        context: viewController!, 
        key: "Your_Ads_Key", 
        view: customView  // view has optional
    )

// *** with callback ***
let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

let adShowListener: AdShowedListener = AdShowedHandler {
    // callback when ad showed
} onHide: { result in
    // callback when ad hide
} onError: { error in
    // callback when error
}

PubStarAdManager.getAdController()
    .loadAndShow(
        context: viewController!, 
        key: "Your_Ads_Key", 
        view: customView, 
        adLoaderListener: adLoaderListener, 
        adShowedListener: adShowListener
    )
```


### Banner

Load and immediately show an Banner ad by ID.

#### Event

`AdLoaderListener`
`AdShowedListener`

#### Example

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()

let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

let adShowListener: AdShowedListener = AdShowedHandler {
    // callback when ad showed
} onHide: { result in
    // callback when ad hide
} onError: { error in
    // callback when error
}

let adRequest: AdRequest = BannerAdRequest.Builder(context: viewController!)
    .isAllowLoadNext(true) // allow load to cache after dismiss
    .withView(customView)
    .tag(.big)
    .adLoaderListener(adLoaderListener)
    .adShowedListener(adShowListener)
    .build()

PubStarAdManager.getAdController()
    .loadAndShow(
        key: "Your_Ads_Key", 
        adRequest: adRequest
    )
```


### Native

Load and immediately show an Native ad by ID.

#### Event

`AdLoaderListener`
`AdShowedListener`

#### Example

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()

let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

let adShowListener: AdShowedListener = AdShowedHandler {
    // callback when ad showed
} onHide: { result in
    // callback when ad hide
} onError: { error in
    // callback when error
}

let requestNative = NativeAdRequest.Builder(context: viewController!)
    .sizeType(.Small)
    .withView(customView)
    .adLoaderListener(adLoaderListener)
    .adShowedListener(adShowListener)
    .build()

PubStarAdManager.getAdController()
    .loadAndShow(
        key: "Your_Ads_Key", 
        adRequest: adRequest
    )
```


## Troubleshooting problems

Here's how to troubleshoot when integrating Pubstar SDK in your project

#### 1. Operation not permitted error

When you build your project, you may see the error ` ... : Operation not permitted`. This means that your project entered a `User Script Sandbox` mode. To fix this, you need to disable the `User Script Sandbox` mode in your project settings. Following this instrusction:

   - Open `Your_Project` in Xcode.
   - Select `Your_Project` in the Project Navigator.
   - Select `Your_Target`.
   - Go to the `Build Settings` tab.
   - Expand the `Build Options` section.
   - Set the `User Script Sandbox` option to `No`.


## Release Notes

See the [CHANGELOG.md](https://github.com/pubstar-io/PubStar-iOS-SDK/blob/main/CHANGELOG.md).


## ID Test AD

```python
App ID : pub-app-id-1233
Banner Id : 1233/99228313580
Native ID : 1233/99228313581
Interstitial ID : 1233/99228313582
Open ID : 1233/99228313583
Rewarded ID : 1233/99228313584
Video ID : 1233/99228313585
```

## Support
Email: developer@tqcsolution.com

Raise an issue on GitHub for bugs or feature requests.


## License

Pubstar is released under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/).

License agreement is available at [LICENSE](LICENSE).
