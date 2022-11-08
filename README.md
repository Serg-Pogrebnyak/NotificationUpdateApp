# NotificationUpdateApp📱
## This is a test application for testing delivering updates on BLE devices via ANCS using live activity or push notifications with collapse id. 
#### See more about ANCS [here](https://developer.apple.com/library/archive/documentation/CoreBluetooth/Reference/AppleNotificationCenterServiceSpecification/Specification/Specification.html), and about live activity [here](https://developer.apple.com/documentation/activitykit)

## Environment 🔨
- iOS 16.1
- Xcode 14.1

## Setup ⚙️
Preparing project in general:
- Clone or download the project
- Change the ```app-bundle-id``` on your (for application and for live activity widget)
- Add provision profile
- Make sure that the application builds successfully with your new data

Preparing stuff to send push notifications:
- Create a new key by going to https://developer.apple.com/account/resources/authkeys/list
- Press (+) to create a new key, give it a name and select [Apple Push Notifications service (APNs)]
- Press [Register] and download the .p8 file while saving the Auth Key ID somewhere safe
- Convert .p8 key to .pem key using ```openssl pkcs8 -nocrypt -in AuthKey_XXXXXXXXXX.p8 -out AuthKey_XXXXXXXXXX.pem```
- Open updateDelivery.sh in some editor
- Change ```TEAM_ID``` to your Apple Developer Team ID
- Change ```TOKEN_KEY_FILE_NAME```to the .pem file generated in step 4
- Change ```AUTH_KEY_ID``` to the Auth Key ID from step 3
- Change ```TOPIC``` to the bundle ID of your app (MAKE SURE to keep ```.push-type.liveactivity``` at the end!)
- Run ```./updateDelivery.sh '{LIVE_ACTIVITY_TOKEN}' '{DELIVERY_DRIVER}' {UNIX_TIME_DELIVERY}```
- Example: ```./updateDelivery.sh ABCDEFGH 1```
