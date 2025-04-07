
platform:ios,'13.0'

#use_frameworks!

target "EnergyHub" do
    pod 'AFNetworking', '~> 3.0'
    pod 'SDWebImage', '~> 4.0'
    pod 'MJExtension', '~> 3.0.13'
    pod 'OpenUDID', '~> 1.0.0'
    #pod 'ZFPlayer'
    pod 'CocoaLumberjack', '~> 1.9.2'
    # download
    pod 'SSZipArchive', '~> 2.0.3'
    pod 'FCFileManager', '~> 1.0.18'
    #pod 'SVProgressHUD', '~> 1.1.2'
    #pod 'CocoaSecurity', '~> 1.2.4'
    pod 'ReactiveObjC', '~> 2.1.0'
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'IQKeyboardManager', '5.0.3'
    #pod 'TPKeyboardAvoiding'
    pod 'Masonry'
    pod 'BlocksKit'
    pod 'PINCache', '~> 2.3'
    # empty tableview
    pod 'DZNEmptyDataSet', '~> 1.8.1'
    pod 'EasyListView'
    pod 'SteviaLayout'
    pod 'SnapKit'
    pod 'BRPickerView'
#    pod "Weibo_SDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    #分享 share
#    pod 'OpenShare'
#    pod 'ShareSDK3'
#    pod 'MOBFoundation', '~> 3.0.2'
#    pod 'ShareSDK3/ShareSDKUI'
#    pod 'ShareSDK3/ShareSDKPlatforms/QQ'
#    pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
#    pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
    #分享 end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0' # 这里统一设置最低支持版本
    end
  end
end
