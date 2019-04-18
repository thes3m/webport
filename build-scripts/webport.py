#!/usr/bin/env python
import os
import socket
import shutil
import subprocess
import argparse
from xml.dom import minidom

# Config variables
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
XCODE_PROJECT_DIR = "../ios"
ANDROID_PROJECT_DIR = "../android" #Android project directory relative to this script
ANDROID_MANIFEST_PATH = "../android/app/src/main/AndroidManifest.xml" # Android manifest location relative to ANDROID_PROJECT_DIR
OUTPUT_DIR = "../output" #Output directory relative to XCODE_PROJECT_DIR
BUILD_DIR = "../build"
WEB_SRC_DIR = "../web/build"
FNULL = open(os.devnull, 'w')

# Setupt commandline argument parser
arg_parser = argparse.ArgumentParser(description="Build an iOS project and embeds a web app project inside it. By default an app will have a webapp embeded and an .ipa will be generated as a result of build process. However you can specify different arguments to deploy to device or to connect to local webserver")
arg_parser.add_argument('--platform', help='Platform to build for - android or ios')
arg_parser.add_argument('--run', action='store_true', help='if specified application will be deployed and runned on currently attached device otherwise a ipa will be build')
arg_parser.add_argument('--usewebserver', action='store_true', help='if specified then app will open webpage from local webserver')
arg_parser.add_argument('--verbose', action='store_true', help='adds additional logging to console')

# Parse commandline arguments
args = arg_parser.parse_args()

# Method returns ip in local network
def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

# Method runs a commandline script and returns the status code
def run_cmd(command):
    output = None
    if args.verbose:
        print(command)
        output = subprocess.call(command.split(" "))
        print("Result:" + str(output))
    else:
        output = subprocess.call(command.split(" "), stdout=FNULL, stderr=FNULL)

    return output

# move to this script folder
os.chdir(SCRIPT_DIR)

#Variables
DEPLOY_AND_RUN = args.run # Weather to deploy app on device (if false the ipa will be generated)
USE_WEBSERVER = args.usewebserver # Weather to connect app to local webserver or use source files instead
EXPORT_OPTIONS_PLIST_PATH = "exportOptions.plist"
OUTPUT_ARCHIVE_PATH = OUTPUT_DIR+"/webport.xcarchive"
OUTPUT_IPA_PATH = OUTPUT_DIR+"/webport.ipa"
ARCHIVE_APP_PATH = OUTPUT_DIR+"/webport.xcarchive/Products/Applications/webport.app"
OUTPUT_APK_PATH = OUTPUT_DIR + "/android.apk"
IP_ADDRESS_FILE_PATH = BUILD_DIR+"/webserver"
DEV_WEBSERVER_PORT = 4200
DEV_WEBSERVER_IP_ADDRESS = get_ip()

# Clean build directory
if os.path.exists(BUILD_DIR):
    shutil.rmtree(BUILD_DIR)

# Write IP address to file that will be bundled with app and will be read on startup to open the webserver instead of local files
if USE_WEBSERVER == True:
    # Create build dir if it does not exists
    if not os.path.exists(BUILD_DIR):
        os.makedirs(BUILD_DIR)

    # Write a file that will contain a server address
    server_address = "http://" + DEV_WEBSERVER_IP_ADDRESS + ":" + str(DEV_WEBSERVER_PORT)
    f = open(IP_ADDRESS_FILE_PATH, "w")
    f.write(server_address)
    f.close()
    print("App will use a local server with address:" + server_address)
else:
    # Copy builded web app sources to build folder
    if os.path.exists(WEB_SRC_DIR):
        shutil.copytree(WEB_SRC_DIR,BUILD_DIR)
        print("Webapp files will be bundled with application")
    else:
        raise Exception("Cannot find webapp files to bundle them with application at path:" + WEB_SRC_DIR)

if args.platform == "ios": # iOS
    os.chdir(XCODE_PROJECT_DIR)

    # Remove previous archive if it exists
    if os.path.exists(OUTPUT_ARCHIVE_PATH):
        shutil.rmtree(OUTPUT_ARCHIVE_PATH)
        
    # Create xcode build build
    run_cmd("xcodebuild -workspace ./webport.xcworkspace -scheme webport -configuration Debug archive -archivePath "+ OUTPUT_ARCHIVE_PATH)
    # Log into console weather the build was successful or not
    if os.path.exists(OUTPUT_ARCHIVE_PATH):
        print("\nBuild SUCCESSFUL.\n")
    else:
        raise Exception('\nBuild FAILED.\n')

    if DEPLOY_AND_RUN: # If this is a dev build we try to deploy and run the app on the device
        # Verify that ios deploy is installed
        output = run_cmd("command -v ios-deploy")
        if output != 0:
            raise Exception("Missing ios-deploy! Install it via: npm install -g ios-deploy")
        print("Deploying app to device...")
        deploy_cmd = "ios-deploy --debug --justlaunch --bundle " + ARCHIVE_APP_PATH
        if args.verbose:
            subprocess.call(deploy_cmd.split(" "), stdin=subprocess.PIPE)
        else:
            subprocess.call(deploy_cmd.split(" "), stdout=FNULL, stderr=subprocess.STDOUT)

    else: # If this is not dev build we create ipa
        run_cmd("xcodebuild -exportArchive -allowProvisioningUpdates -archivePath " + OUTPUT_ARCHIVE_PATH + " -exportOptionsPlist " + EXPORT_OPTIONS_PLIST_PATH + " -exportPath "+OUTPUT_IPA_PATH)

        #Log into console weather the ipa was generated or not
        if os.path.exists(OUTPUT_IPA_PATH):
            print("\nIpa generated SUCCESSFULLY.\n")
        else:
            raise Exception("\nERROR: Failed to generate .ipa for archive: "+OUTPUT_ARCHIVE_PATH+"\n")
elif args.platform == "android": #ANDROID
    os.chdir(ANDROID_PROJECT_DIR)

    # Create variables
    package_name = ""
    if os.path.exists(ANDROID_MANIFEST_PATH):
        android_manifest = minidom.parse(ANDROID_MANIFEST_PATH)
        manifest_tag = android_manifest.getElementsByTagName("manifest")[0]
        package_name = manifest_tag.attributes["package"].value

    if len(package_name) == 0:
        raise Exception("Cannot read package name From AndroidManifest.xml")
    
    # Move to android folder and build the project
    if args.run == True:
        # Deploy to device
        print("Deploying app on device...")
        if run_cmd("./gradlew installDebug") == 0:
            print("Deploy successfull")
        else:
            raise Exception("Error building and deploying app, run command again with --verbose to pinpoint the issue")
        
        # Run application on device
        print("Running app on to device...")
        if run_cmd("adb shell monkey -p "+package_name+" -c android.intent.category.LAUNCHER 1") == 0:
            print("App deployed successfully")
        else:
            raise Exception("Error running app, run command again with --verbose to pinpoint the issue")
    else:
        # TODO build release apk
        print("Building release apk...")
        run_cmd("./gradlew buildDebug")
        print("Android project Build Successful")
else:
    raise Exception("Invalid argument specified for --platform")