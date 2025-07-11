//
//  ContentView.swift
//  PubstarExample
//
//  Created by Pubstar Ads on 25/5/25.
//

import SwiftUI
import Pubstar

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
    @State private var customView: UIView?
    @State private var index = 0
    private let prefix = "_Pangle"
    
    init() {
        PubStarAdManager.getInstance()
            .setIsDebug(isDebug: true)
            .setInitAdListener(InitAdListenerHandler(
                onDone: {
                    print("TQC", "onDone")
                },
                onError: { errorCode in
                    print("TQC", "\(errorCode)")
                }
            ))
            .initAd()
    }
    
    func showNonViewAds(key: String) {
        if viewController == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            print("onLoaded")
        } onError: { code in
            print("onLoadedError: \(code.rawValue)")
        }

        let adNetShowListener: AdShowedListener = AdShowedHandler {
            print("onAdShowed")
        } onHide: { any in
            print("onAdHide: \(any?.type ?? "None")")
        } onError: { code in
            print("onShowedError: \(code.rawValue)")
        }
        
        print("showNonViewAds key is \(key)")
        PubStarAdManager.getAdController().loadAndShow(context: viewController!,
                                        key: key,
                                        view: nil,
                                        adLoaderListener: adNetLoaderListener,
                                        adShowedListener: adNetShowListener)
    }
    
    func loadAndShowNativeAds(size: NativeAdRequest.TypeSize) {
        if viewController == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            print("onLoaded")
        } onError: { code in
            print("onLoadedError: \(code.rawValue)")
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            print("onAdShowed")
        } onHide: { any in
            print("onAdHide: \(any?.type ?? "None")")
        } onError: { code in
            print("onShowedError: \(code.rawValue)")
        }
        
        let requestNative = NativeAdRequest.Builder(context: viewController!)
            .sizeType(size)
            .withView(customView)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)
            .build()
        
        let adUnitID = "1295/99228313913"
        PubStarAdManager.getAdController().loadAndShow(key: adUnitID, adRequest: requestNative)
    }
    
    func loadAndShowBannerAds() {
        if viewController == nil {
            return
        }
        
        index += 1
        let tag: BannerAdRequest.AdTag = {
            if index % 3 == 0 {
                return .small
            } else if index % 3 == 1 {
                return .medium
            } else {
                return .big
            }
        }()
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            print("onLoaded")
        } onError: { code in
            print("onLoadedError: \(code.rawValue)")
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            print("onAdShowed")
        } onHide: { any in
            print("onAdHide: \(any?.type ?? "None")")
        } onError: { code in
            print("onShowedError: \(code.rawValue)")
        }
        
        let context = PubStarUtils.getHostingViewController()
        let requestNative = BannerAdRequest.Builder(context: context!)
            .withView(customView)
            .tag(tag)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)
            .build()
        
        let adUnitID = "1295/99228313910"
        PubStarAdManager.getAdController().loadAndShow(key: adUnitID, adRequest: requestNative)
    }

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
            Button("Show Banner Ads", action: {
                loadAndShowBannerAds()
            })
            Spacer().frame(height: 16)
            Button("Show Native Small Ads", action: {
                loadAndShowNativeAds(size: .Small)
            })
            Spacer().frame(height: 16)
            Button("Show Native Medium Ads", action: {
                loadAndShowNativeAds(size: .Medium)
            })
            Spacer().frame(height: 16)
                
            Button("Show Native Big Ads", action: {
                loadAndShowNativeAds(size: .Big)
            })
            Spacer().frame(height: 16)
            Button("Show Interstitial Ads", action: {
                let adKey = "1295/99228313911"
                showNonViewAds(key: adKey)
            })
            Spacer().frame(height: 16)
            Button("Show Open Ads", action: {
                let adKey = "1295/99228313912"
                showNonViewAds(key: adKey)
            })
            Spacer().frame(height: 16)
            Button("Show Reward Ads", action: {
                let adKey = "1295/99228313914"
                showNonViewAds(key: adKey)
            })
        }
        .padding(.horizontal, 0)
        .getViewControllerPubStar { controller in
            viewController = controller
        }
    }
}

#Preview {
    ContentView()
}
