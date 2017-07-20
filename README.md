# yomblr

[![Build Status](https://travis-ci.org/ykws/yomblr.svg?branch=master)](https://travis-ci.org/ykws/yomblr)
![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)

Minimum Tumblr Client. Post cropped photo your likes on Tumblr.

## Installation

Install `cocoapods-keys`.

```
$ bundle install --path vendor/bundle
```

Get `OAuth consumer Key` and `OAuth consumer Secret` on Tumblr.

https://www.tumblr.com/oauth/apps

Install libraries.

```
$ bundle exec pod install
```

Set up keys. Type your keys.

```
$ bundle exec keys set TumblrOAuthConsumerKey [your_key]
Saved TumblrOAuthConsumerKey to yomblr.
$ bundle exec keys set TumblrOAuthConsumerSecret [your_key]
Saved TumblrOAuthConsumerSecret to yomblr.
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
