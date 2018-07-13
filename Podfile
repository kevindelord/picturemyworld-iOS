source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/smartmobilefactory/SMF-CocoaPods-Specs.git'

platform :ios, '10.0'
use_frameworks!

inhibit_all_warnings!

project 'HockeyApp-iOS.xcodeproj'

def corePods
	pod 'SDWebImage', '~> 4.4.1'
	pod 'DKDBManager', '~> 1.1.0'
	pod 'Reachability', '~> 3.2'
	pod 'Alamofire', '~> 4.7.2'
	pod 'SMFLogger', '~> 4.2.0'
end

def coreApp
	pod 'KeychainAccess', '~> 3.1.1'
	pod 'SMF-HockeyAppBrowser-iOS', '~> 0.2.3'
	pod 'PagingMenuController', '~> 2.2.0'
	pod 'R.swift', '~> 4.0.0'
	pod 'SwiftLint', '~> 0.25.1'
	pod '1PasswordExtension', '~> 1.8.5'
	pod 'Shimmer', '~> 1.0.2'
	pod 'HockeySDK', '~> 5.1.1'
	pod 'QAKit', '~> 0.0.5'
	pod 'Buglife', '~> 2.8.0'
end

def oneSignal
	pod 'OneSignal', '~> 2.8.5'
end

target 'HockeyApp-Alpha-InHouse' do
	corePods
	coreApp
	oneSignal
end

target 'HockeyApp-Beta-InHouse' do
	corePods
	coreApp
	oneSignal
end

target 'NotificationContentExtension-ALPHA' do
	corePods
	oneSignal
end

target 'NotificationContentExtension-BETA' do
	corePods
	oneSignal
end

target 'TodayWidget-ALPHA' do
	corePods
end

target 'TodayWidget-BETA' do
	corePods
end

target 'IndexExtension-ALPHA' do
	corePods
end

target 'IndexExtension-BETA' do
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

		if target.name == 'PagingMenuController'
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '3.2'
			end
		end
    end
end
