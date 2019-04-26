# WebPort

WebPort is a lightweight project template for developing iOS, Android and Web Apps with **any web technology**. WebPort gives you control over the native projects and their dependencies while leveraging HTML, CSS and JavaScript to develop shared application logic and UI. To put it in perspective WebPort simply **connects** your web project with your native projects and gives you some helper tools to make work easier. WebPort is similar to Cordova but with some differences: 
  * WebPort compared to Cordova does not generate native projects for Android and iOS. Native projects are part of this repository and all changes for native projects must be made manually for each platform seperately.
  * Integration for native features/libraries need to be made separately for each platform. If you need access to libraries or functionalities from webview you need to manually create JavaScript bindings - examples how to do this are provided in the project. (TODO)

Compared to Cordova or PhoneGap, native projects are not generated, but are provided as a template from which you can build from. Native projects and their native dependencies are still managed manually for each platform separately. This allows you to to manage all dependencies by yourself, for iOS with Cocoapods/Carthage and for Android you can use Gradle dependencies.

## Why

Webport somehow relates to Cordova for building applicatoons however Cordova offers a number of plugins and tools for integrating native features that do not play well with eachother all the time and each plugin might need to change native projects which complicates things. For example lets say that you include `GoogleMaps` framework and `GoogleAnalytics` framwork, which both contain some shared native dependencies, but each Cordova plugin for this libraries contains a different version of the native dependencies. This issues can then be in varios ways but it takes quite some time to resolve them and when project complexity rises the number of problems will likely aswell. Another difference is that cordova generates native project while WebPort simply does not.

## How does it work

WebPort is a project template that contains 2 native project (ios/android) and a starter for a web project. Both native projects contain a simple single view application that opens up Webview and initial page (index.html). Native projects take HTML/CSS/JS source code from `/build` folder and bundle it inside application. Webport allows any kind of frontend web project that might run on a webserver to be bundled inside native application. Besides native projects a python build script (`build-scripts/webport.py`) is provided that allows you to quickly build application for developement or production from commandline.

## Features

* Shared cross platform developement with HTML/CSS/JS
* Deployment of Web Apps to native Xcode or Android project
* Live Development on custom local server with live reload

## Supported Platforms

You can use WebPort to build for the following platforms:

* iOS 10+
* Android 4.0+
* Web

You can support older versions but you might have to do some additional work.

## Workflow

* you can develop a web app as you would normally do with your preferred web stack
* when you want to build for iOS or Android you execute a script that bundles your web project in Xcode or Android project and then you can run your project on a device or simulator - `npm run deploy-ios`/`npm run deploy-android`

## What is included

* base iOS project that opens up WKWebview and opens a dev webserver page or creates a local webserver to serve bundled app pages
* base android project that opens WKWebView and opens a dev webserver page or opens up a local html file (android project does not use local webserver)
* basic Angular project template for web is generated with angular-cli
* basic "one page" Android and iOS projects that contain a WebView that either opens a dev server page or a locally embedded html page
* a script (build-scripts/webport.py) that is used for developing, building ,deploying on mobile apps

## Project folder structure

```
++ ios/ (Xcode project source)
++ android/ (Android Studio project)
++ web/ (Web project)
++ build/ (Final html/js/css sources that will be embedded into iOS/Android application)
++ output/ (outpt folders for .apk or .ipa)
++ build-scripts/ (webport scripts used for building apps)
```

## How to use framework other than Angular

If you wish to other framework than Angular you can simply delete contents of `web/` folder and start your webproject there from scratch. In order to build a custom project with Webport you will have to call `build-scripts/webport.py` with some arguments or you can check scripts in `web/package.json` that show how the script is used.

## How to get started

Ensure that you have all dependencies and SDKs installed for building native projects. If you are building for iOS then you need Xcode and a developer account, if you develop for Android you will need Android Studio and AndroidSDK. For setting up your system you can google up some guides.

First install npm dependencies:
```
npm install -g concurrently
npm install
```

You will also need to install *Python* to use webport scripts.

If you are on iOS and you want to build and deploy with WebPort directly onto device then you also need to install **ios-deploy**:

```
npm install -g ios-deploy
```

To run this project on local computer you can use the following package.json scripts method:

```
npm run dev-web
```

This will call a normal **ng serve** and your webserver will be ready for developement.

To develop and preview this project on a device you can call:

```
npm run dev-ios
```

or

```
npm run dev-android
```

This will build android/ios project and run it on a device while staying connected to local web server for html-files.

If you need to bundle web application with mobile app then you can run:

```
npm run deploy-ios
```

or

```
npm run deploy-android
```

To build apk that you can later upload to AppStore or Google Play you can use

```
npm run build-ios
```

or

```
npm run build-android
```

### Before building projects you will have to:

* Open xcode project and set provisioning profiles for release and developement or use Automatic signing.
* Open ios/exportOptions.plist and enter teamID to build an ipa

### Not leveraging webport.py

You can choose to use webport.py to 

## Used techologies

* Angular 7
* https://github.com/ios-control/ios-deploy
* Python for commandline scripts

## Webframeworks that you can use to develop native webapps:

* Framework7
* Onsen UI 
* Ionic
