# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'PetTip' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PetTip
  # RxSwift
  pod 'RxSwift', '~> 6.5.0'
  pod 'RxCocoa', '~> 6.5.0'
  pod 'NMapsMap'
  pod 'NVActivityIndicatorView'
  pod 'FSPagerView'
  pod 'Alamofire'
  pod 'AlamofireImage', '~> 4.3'
  pod 'KeychainAccess', '4.1.0'
  pod 'Toaster'
  pod 'Tabman', '~> 3.0'
  pod 'DropDown'
  pod 'DGCharts'
  pod 'KakaoSDKUser'
  pod 'KakaoSDKAuth'
  pod 'naveridlogin-sdk-ios'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'GoogleSignIn'
  pod 'GoogleSignInSwiftSupport'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "14.0"
      end
    end
  end

end
