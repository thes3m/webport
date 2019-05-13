# WebPort

WebPort is a lightweight project template for developing iOS, Android and Web Apps with **any web technology**. WebPort gives you control over the native projects and their dependencies while leveraging HTML, CSS and JavaScript to develop shared application logic and UI. To put it in perspective WebPort simply **connects** your web project with your native projects and gives you some helper tools to make work easier. WebPort is similar to Cordova but with some differences: 
  * WebPort compared to Cordova does not generate native projects for Android and iOS. Native projects are part of this repository and all changes for native projects must be made manually for each platform seperately.
  * Integration for native features/libraries need to be made separately for each platform. If you need access to libraries or functionalities from webview you need to manually create JavaScript bindings - examples how to do this are provided in the project. (TODO)

Compared to Cordova or PhoneGap, native projects are not generated, but are provided as a template from which you can build from. Native projects and their native dependencies are still managed manually for each platform separately. This allows you to to manage all dependencies by yourself, for iOS with Cocoapods/Carthage and for Android you can use Gradle dependencies.

## How does it work

WebPort consists of 3 projects - Android/iOS/Web. The main app logic and UI is coded in **Web** project with web technologies of your choice, while Android and iOS projects contain basic code for setting up a WebView and loading a project that was created in **web** project. Android and iOS projects are just basic single page applications that create a Webview and load a page from **web** project. When running native app with **npm run dev-ios** or **npm run dev-android** commands the app will load the project directly from your local webserver and when packaging it with **np, run deploy-android** or **npm run deploy-ios** all the application files will be bundled with the application. 

For any native dependencies you would have to manually code **plugins** and then call them in JavaScript code.

## Getting started

Before you start using the framework you will need to install some tools and dependencies on your system.
You will need `NodeJS >= 8.9.0` and `Python 2.7`  to run this project.

After that you need to install some Node dependencies that we need globally:

```
npm install -g concurrently
```

If you are on OSx and you want to build and deploy with WebPort directly onto iOS device then you also need to install **ios-deploy**:

```
npm install -g ios-deploy
```

Then move to `./Web` Folder and install node dependencies for web project:

```
cd ./web
npm install
```

To run this project on local computer you can use the following package.json scripts method:

```
npm run dev-web
```

This will call a normal **ng serve** and your webserver will be ready for developement at http://localhost:4000.

To develop and preview this project on an iOS device first open **ios/webport.xcworkspace** in Xcode and update your app **bundle identifier** in project general tab and make sure that provisioning is set. After that you should build the project and make sure that build is successful and if not try to fix any issues that you might encounter. After that you can call:

```
npm run dev-ios
```

to deploy your app direcly from commandline to currently attached device.

You can deploy app to android you can call:

```
npm run dev-android
```

This will build android/ios project and run it on a device while staying connected to local web server so that if files change you will imediately see changes.

If you need to **bundle web application with mobile app** then you can run:

```
npm run deploy-ios
```

or

```
npm run deploy-android
```

This will build your web project and include all files in native projects and then deploy the project on your mobile device.

To build ipa/apk that you can later upload to AppStore or Google Play you can use

```
npm run build-ios
```

or

```
npm run build-android
```


### Before building projects you will have to:

* Open Xcode project and set provisioning profiles for release and developement or use Automatic signing.
* Open ios/exportOptions.plist and enter teamID to build an ipa

## Why use WebPort

Webport has similar goals as Cordova for building mobile applications. Cordova is a framework for developing native app with web prroject with a number of plugins for integrating native features that can speed up the developement process, however sometimes happens that plugins do not play well with eachother or you need some extra functionallity or a plugin requires an update. That can cause lots of pain and problems for the developement. For example lets say that you include `GoogleMaps` framework and `GoogleAnalytics` framwork, which both contain some shared native dependencies, but each Cordova plugin for this libraries contains a different version of the native dependencies. This issues can then be fixed in varios ways but it takes quite some time to figure out how everything is setup and then resolve the issue. And when project complexity rises the number of problems will likely aswell. Another difference is that cordova generates native projects and each plugin needs to also edit/postprocess native project files which potentially leads to a number of problems when multiple plugins change similar native project configurations. In WebPort native project are simply provided alongside and you are responsible to edit/update manually when the project grows.

## Features

* Shared cross platform developement with HTML/CSS/JS
* Develop native functionalities with Swift for iOS and Java for Android
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
* when you want to build for iOS or Android you execute a script that bundles your webcode in xcode or android project and then you build it by itself
* base iOS project that opens up WKWebview and opens a dev webserver page or creates a local webserver to serve bundled app pages
* base android project that opens WKWebView and opens a dev webserver page or opens up a local html file (android project does not use local webserver)

## What is included

* basic Angular project template for web is generated with angular-cli
* basic "one page" Android and iOS projects that contain a WebView that either opens a dev server page or a locally embedded html page
* a script (build-scripts/webport.py) that is used for developing, building ,deploying on mobile apps

## Project folder structure

```
/ios (Xcode project source)
/android (Android Studio project)
/web (Web project)
/build (Final html/js/css sources that will be embedded into iOS/Android application)
/output (outpt folders for .apk or .ipa)
/build-scripts/webport.py (webport script for building apps)
```

## How to use framework other than Angular

If you wish to other framework than Angular you can simply delete contents of `web/` folder and start your webproject there from scratch. In order to build a custom project with Webport you will have to call `build-scripts/webport.py` with some arguments or you can check scripts in `web/package.json` that show how the script is used.

## Used techologies

* Python for commandline scripts
* Angular 7
* ios-deploy (https://github.com/ios-control/ios-deploy)

## Webframeworks that you can use to develop native webapps:

* Framework7
* Onsen UI 
* Ionic