# PictureMyWorld-Uploader-iOS

Xcode Version: 11.3.1
Code Signing: Automatic
Swift Version: 5

## Dependencies

List of dependencies installed via [CocoaPods](https://cocoapods.org/):

- SDWebImage: Download and cache images
- Reachability: Check Internet Connection
- Alamofire: Handle API requests and image upload
- AppCenter: Crash reports and distribution platform

## Project Setup

Make sure to create and fill a `credentials.plist` using the following script:
```
$> cd PictureMyWorld
$> ./generate_credentials.sh
```

## Infrastructure

To automatically deploy a new version to TestFlight use Fastlane:
```
$> bundle exec fastlane ios deploy
```

More information [here](fastlane/README.md)
