# PubStar iOS Mobile AD SDK

PubStar iOS Mobile AD SDK is a comprehensive software development kit designed to empower developers with robust tools and functionalities for integrating advertisements seamlessly into iOS mobile applications. Whether you're a seasoned developer or a newcomer to the world of app monetization, our SDK offers a user-friendly solution to maximize revenue streams while ensuring a non-intrusive and engaging user experience.

## Installation

### CocoaPods

1. If you haven't set up CocoaPods, run `pod init` in your project directory.
2. In your Podfile, add PubStar dependencies:

```ruby
target 'YourAppName' do
    # Add this line to use the latest version of PubStar SDK
    pod 'PubStar'

end
```

3. Install the dependencies using `pod install`.
4. Open your project in Xcode with the `.xcworkspace` file.


### Update your Info.plist

Update your app's Info.plist file to add several keys:

- A GADApplicationIdentifier key with a string value of your AdMob app ID [found in the AdMob UI](https://support.google.com/admob/answer/7356431).

- A `io.pubstar.key` key with a string value of your PubStar ad ID [found in the PubStar Dashboard](https://pubstar.io/).

- SKAdNetworkItems in Google AdMob refers to the necessary configuration within your iOS app's Info.plist file to support Apple's SKAdNetwork for conversion tracking, particularly when using the Google Mobile Ads SDK for AdMob [found in the AdMob privacy](https://developers.google.com/admob/ios/privacy/strategies).


```xml
<key>GADApplicationIdentifier</key>
<string>Your AdMob app ID</string>
<key>SKAdNetworkItems</key>
	<array>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>cstr6suwn9.skadnetwork</string>
		</dict>

        ...

        <dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3qcr597p9d.skadnetwork</string>
		</dict>
    </array>
<key>NSUserTrackingUsageDescription</key>
<string>We use your data to show personalized ads and improve your experience.</string>
<key>io.pubstar.key</key>
<string>Your PubStar app ID</string>
```


## Integration Quickstart

Here's how to add PubStar to your project (works for both SwiftUI and UIKit):

### Import the SDK

```swift
import PubStar
```

### Initialization

```swift
PubStarAdManager.getInstance()
    .setIsDebug(isDebug: true). // Set to true for debugging, false for production. By default isDebug is false
    .setInitAdListener(InitAdListenerHandler(
        onDone: {
            // callback when init done (ready to call load and show ad)
        },
        onError: { errorCode in
            // callback when init error
        }
    ))
    .initAd()
```

### Get UIViewController (context of PubStar SDK)
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


### Load AD

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()

// with no callback
PubStarAdManager.getAdController()
    .load(context: viewController!, key: "Your_Ads_Key")

// with callback
let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

PubStarAdManager.getAdController()
    .load(context: viewController!, key: "Your_Ads_Key", adLoaderListener: adLoaderListener)

// with builder
let adLoaderListener: AdLoaderListener = AdLoaderHandler {
    // callback when ad loaded
} onError: { code in
    // callback when ad load error
}

let adRequest: AdRequest = BannerAdRequest.Builder(context: viewController!)
        .isAllowLoadNext(true) // allow load to cache after dismiss
        .tag(.big)
        .adLoaderListener(adLoaderListener)
        .build()

PubStarAdManager.getAdController().load(key: "Your_Ads_Key", adRequest: adRequest)
```
### Show AD

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()
@State private var customView: UIView?

// with no callback
PubStarAdManager.getAdController()
    .show(context: viewController!, key: "Your_Ads_Key", view: customView) // view has optional

// with callback
let adShowListener: AdShowedListener = AdShowedHandler {
    // callback when ad showed
} onHide: { result in
    // callback when ad hide
} onError: { error in
    // callback when error
}

PubStarAdManager.getAdController()
    .show(
        context: viewController!, 
        key: "Your_Ads_Key", 
        view: customView, // view has optional
        adShowedListener: adShowListener
    )

// with builder
let adRequest: AdRequest = BannerAdRequest.Builder(context: viewController!)
    .isAllowLoadNext(true) // allow load to cache after dismiss
    .withView(customView)
    .tag(.big)
    .adLoaderListener(adLoaderListener)
    .build()

PubStarAdManager.getAdController()
    .show(key: "Your_Ads_Key", adRequest: adRequest)
```

### Load And Show AD

```swift
var viewController: UIViewController = PubStarUtils.getHostingViewController()
@State private var customView: UIView?

// with no callback
PubStarAdManager.getAdController()
    .loadAndShow(context: viewController!, key: "Your_Ads_Key", view: customView) // view has optional

// with callback

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

// with builder
let adRequest: AdRequest = BannerAdRequest.Builder(context: viewController!)
    .isAllowLoadNext(true) // allow load to cache after dismiss
    .withView(customView)
    .tag(.big)
    .adLoaderListener(adLoaderListener)
    .adShowedListener(adShowListener)
    .build()

PubStarAdManager.getAdController().loadAndShow(key: "Your_Ads_Key", adRequest: adRequest)
     
```

### Custom Banner

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

PubStarAdManager.getAdController().loadAndShow(key: "Your_Ads_Key", adRequest: adRequest)
```

### Custom Native

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

PubStarAdManager.getAdController().loadAndShow(key: "Your_Ads_Key", adRequest: adRequest)   
```

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

## Troubleshooting problems

Here's how to troubleshoot when integrating PubStar SDK in your project

#### 1. Operation not permitted error

When you build your project, you may see the error ` ... : Operation not permitted`. This means that your project entered a `User Script Sandbox` mode. To fix this, you need to disable the `User Script Sandbox` mode in your project settings. Following this instrusction:

   - Open `Your_Project` in Xcode.
   - Select `Your_Project` in the Project Navigator.
   - Select `Your_Target`.
   - Go to the `Build Settings` tab.
   - Expand the `Build Options` section.
   - Set the `User Script Sandbox` option to `No`.

## License

PubStar is released under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/).

License agreement is available at [LICENSE](LICENSE).