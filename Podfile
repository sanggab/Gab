# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Gab' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Kingfisher', '~> 7.0'
  pod 'Alamofire', '~> 5.4'
  pod 'XHQWebViewJavascriptBridge'
  pod 'naveridlogin-sdk-ios'
  pod 'KakaoSDK'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'lottie-ios'
  # Pods for Gab
  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
end
