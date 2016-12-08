source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

def corePods
    pod 'Reachability', '~> 3.2'
	pod 'Appirater', '~> 2.0.5'
	pod 'MBProgressHUD', '~> 1.0.0'
	pod 'DKHelper', '~> 2.2.3'
    pod 'Buglife', '~> 1.3.3'
    pod 'HockeySDK', '~> 4.1.2'
	pod 'Kanna', '~> 1.1.0'
	pod 'DKDBManager', '~> 1.0.0'
	pod 'SDWebImage', '~> 3.7.1'
	pod 'CollectionViewWaterfallLayoutSH', '~> 0.3.0'
	pod 'ImageSlideshow', :git => 'https://github.com/zvonicek/ImageSlideshow', :branch => 'swift-2.3'
end

target 'PictureMyWorld-AdHoc-Alpha' do
    corePods
end

post_install do |installer|

	installer.pods_project.targets.each do |target|
		if target.name.include?("Pods-")
			require 'fileutils'
			FileUtils.cp_r('Pods/Target Support Files/' + target.name + '/' + target.name + '-acknowledgements.plist',
			'Resources/Settings.bundle/Pods-acknowledgements.plist', :remove_destination => true)
		end

		target.build_configurations.each do |config|
			config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
			config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
			config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
		end
	end
end
