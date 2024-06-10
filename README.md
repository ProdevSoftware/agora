# Agora Video Call App in Flutter

The Agora Video Call App is a sample Flutter application that demonstrates how to integrate Agora's Video SDK for video calling functionality using Bloc State Management. This README provides a comprehensive guide on setting up, configuring, and running the application.

## Features

- One-on-one video calls
- Mute/unmute audio
- Switch between front and rear cameras
- End call functionality

## Prerequisites
Before you begin, ensure you have met the following requirements:

- Flutter installed on your machine. Follow the instructions here to set up Flutter.
- An Agora account. Sign up here and obtain your App ID.

## Getting Started

const String appId = "YOUR_APP_ID";

## Usage

## Starting a Video Call
- Open the app on your device.
- Enter a channel name and press the "Join" button to start a video call.

## In-Call Features
- Mute/Unmute Audio: Tap the microphone icon to mute or unmute your audio.
- Switch Camera: Tap the camera switch icon to toggle between front and rear cameras.
- End Call: Tap the end call button to leave the call.

## 1. Dependencies
- Add below dependencies in pubspec.yaml
```
  cupertino_icons: ^1.0.8
  agora_rtc_engine: ^6.3.1
  permission_handler: ^11.3.1
  share_plus: ^9.0.0
  google_fonts: ^6.2.1
  flutter_bloc: ^8.1.5
  freezed: ^2.5.2
  signal_strength_indicator: ^0.4.1
  convex_bottom_bar: ^3.2.0

dev_dependencies:
  flutter_lints: ^3.0.2
  build_runner: ^2.4.9
```
## 2. Add this permission in AndroidManifest.xml file
```
    <uses-permission  android:name="android.permission.READ_PHONE_STATE"/>
    <uses-permission  android:name="android.permission.INTERNET"  />
    <uses-permission  android:name="android.permission.RECORD_AUDIO"  />
    <uses-permission  android:name="android.permission.CAMERA"  />
    <uses-permission  android:name="android.permission.MODIFY_AUDIO_SETTINGS"  />
    <uses-permission  android:name="android.permission.ACCESS_NETWORK_STATE"  />
    <uses-permission  android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission  android:name="android.permission.BLUETOOTH"  />
``` 
```
    <uses-feature
        android:name="android.hardware.camera"
        android:required="false" />
```
##  3. Code SetUp
- Intialize
 ```
   final rtcEngine = createAgoraRtcEngine();

    await rtcEngine.initialize(const RtcEngineContext(
      appId: 'your applicationId',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

 ```

## Videos
https://github.com/ProdevSoftware/agora/assets/97152083/b9cb1913-3837-43c3-931f-1e23ef27d043



