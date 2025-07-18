Pod::Spec.new do |s|
  s.name             = 'Pubstar'
  s.version          = '1.1.8'
  s.summary          = 'PubStar Mobile AD SDK'
  s.homepage         = 'https://pubstar.io/'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Pubstar' => 'support@pubstar.io' }
  s.platform         = :ios, '13.0'

  s.source           = { :git => 'https://github.com/pubstar-io/PubStar-SDK-iOS.git', :tag => s.version.to_s }

  s.swift_version    = '4.0'

  s.vendored_frameworks = 'Pubstar.xcframework'
  s.static_framework = false

  s.dependency 'Google-Mobile-Ads-SDK', '~> 11.10.0'
  s.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.26.1'
  s.dependency 'InMobiSDK', '~> 10.8.3'
end
