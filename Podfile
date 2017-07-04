platform :ios, '9.0'

target 'yomblr' do
  use_frameworks!
  
  pod 'TMTumblrSDK', git: 'https://github.com/tumblr/TMTumblrSDK.git'
  pod 'SDWebImage'
  pod 'AKImageCropperView', git: 'https://github.com/ykws/AKImageCropperView.git', branch: 'develop-improve'
  pod 'MBProgressHUD'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'

  target 'yomblrTests' do
    inherit! :search_paths
  end

end

plugin 'cocoapods-keys', {
  :project => 'yomblr',
  :keys => [
    "TumblrOAuthConsumerKey",
    "TumblrOAuthConsumerSecret",
    "HockeyAppId",
  ]
}
