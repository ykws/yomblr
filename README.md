# yomblr

[![Build Status](https://travis-ci.org/ykws/yomblr.svg?branch=master)](https://travis-ci.org/ykws/yomblr)
![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![StackShare](https://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/ykws/yomblr)
[![Join the chat at https://gitter.im/yomblr/Lobby](https://badges.gitter.im/yomblr/Lobby.svg)](https://gitter.im/yomblr/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Minimum Tumblr Client. Post cropped photo your likes on Tumblr.

<a href="https://itunes.apple.com/us/app/yomblr/id1259790615?mt=8">
  <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/8fD0fjB.png" width="130">
</a>
  
## Installation

Install `cocoapods-keys`.

```
$ bundle install --path vendor/bundle
```

Get `OAuth consumer Key` and `OAuth consumer Secret` on Tumblr.

https://www.tumblr.com/oauth/apps

Set up keys. Type your keys.

```
$ bundle exec pod keys set TumblrOAuthConsumerKey [your_key]
Saved TumblrOAuthConsumerKey to yomblr.
$ bundle exec pod keys set TumblrOAuthConsumerSecret [your_key]
Saved TumblrOAuthConsumerSecret to yomblr.
```

Install libraries.

```
$ bundle exec pod install
```

### Set up Firebase

https://firebase.google.com/

## Use libraries

### Tumblr SDK for iOS

http://tumblr.github.com/TMTumblrSDK

### A key value store for application keys

https://github.com/orta/cocoapods-keys

### Asynchronous image downloader

https://github.com/rs/SDWebImage

### Crop image

https://github.com/artemkrachulov/AKImageCropperView

### Firebase

https://github.com/firebase/firebase-ios-sdk
