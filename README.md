# Profile downloader

This step enables you to download provisioning profiles on the fly by using [sigh](https://github.com/fastlane/fastlane/tree/master/sigh) from the [fastlane toolchain](https://github.com/fastlane/fastlane/).

Given your certificate and bundle identifier, this step downloads (and creates if required) a provisioning profile for your application.


## How to use this Step

Provide your Apple Developer account credentials in your `.bitrise.secrets.yml` file or via secret env vars on the web interface.
