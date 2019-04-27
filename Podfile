source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

inhibit_all_warnings!

project 'PictureMyWorld.xcodeproj'

target 'PictureMyWorld' do
	pod 'SDWebImage', '~> 4.4.2'
	pod 'Reachability', '~> 3.2.0'
	pod 'Alamofire', '~> 4.7.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
