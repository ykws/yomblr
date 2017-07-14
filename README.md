# yomblr

![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)

Minimum Tumblr Client. Post cropped photo your likes on Tumblr.

## Installation

Install `cocoapods-keys`.

```
$ bundle install --path vendor/bundle
```

Get `OAuth consumer Key` and `OAuth consumer Secret` on Tumblr.

https://www.tumblr.com/oauth/apps

Get `App ID` on Hockey.

https://rink.hockeyapp.net/manage/dashboard

Install libraries and set up keys.
Type your keys.

```
$ bundle exec pod install

 CocoaPods-Keys has detected a keys mismatch for your setup.
 What is the key for TumblrOAuthConsumerKey
 > 

Saved TumblrOAuthConsumerKey to yomblr.
 What is the key for TumblrOAuthConsumerSecret
 > 

Saved TumblrOAuthConsumerSecret to yomblr.
...
```

## Use libraries

Tumblr SDK for iOS

http://tumblr.github.com/TMTumblrSDK

A key value store for application keys

https://github.com/orta/cocoapods-keys

Asynchronous image downloader

https://github.com/rs/SDWebImage

Crop image

https://github.com/artemkrachulov/AKImageCropperView
