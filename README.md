# picturemyworld-iOS

## About

Pict My World lets you discover the latest picture posts from the travel blog [picturemy.world](http://picturemy.world/).

Read the stories and view the beautiful images through a beautiful slideshow.

## How to get started

To be able develop on this project you first need the following:

* [Xcode](https://developer.apple.com/xcode/)
* [Cocoapods](https://cocoapods.org/)
* [git](https://git-scm.com/)
* [Swiftlint](https://github.com/realm/SwiftLint) (optional)

Back on your command line, execute the following and run the project:

```
$> git clone https://github.com/kevindelord/picturemyworld-iOS.git
$> cd picturemyworld-iOS
$> git submodule update --init --recursive
$> pod install
```

## Librairies

Most of the librairies are integrated with [Cocoapods](https://cocoapods.org/). 

Only [ImageSlideshow](https://github.com/zvonicek/ImageSlideshow) has been integrated manually as its version for Swift 2.3 has performance issues that needed to be fixed. It has also been improved with minor features and some code cleaning. The latest version for Swift 3.x seems to be better but requires a lot of migration.

## Analytics

[Google Analytics](https://console.developers.google.com) and [Firebase](https://console.firebase.google.com) are integrated to analyse how the users use the app.

## External Links:

* [picturemy.world](http://picturemy.world/)

## ROADMAP

### v1.0

* Show grid of all posts
* Integrate slideshow
* Works offline

### v1.1

* Push Notification
* Save image to PhotoLibrary from slideshow.
* Add videos

### v1.2

* Integrate maps of all locations.
* Location button: redirect to in app map.

### v2.0

* Translate all posts in system's language
