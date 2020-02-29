fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios deploy
```
fastlane ios deploy
```
Build and deploy a new app version to TestFlight!

This lane does:

- Ensure the git repository is clean

- Increment the build number

- Automatically code sign and build the app

- Upload the binary to TestFlight

- Add and push a new git tag

- Clean build artifacts

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
