# PushPush

<p align="center">
  <img alt="PushPush screenshot" src="https://user-images.githubusercontent.com/27675073/96582644-3ff81b00-12e4-11eb-9f1e-31b7035e62a4.png" width="600">
</p>

Simple macOS application for sending push notifications directly to booted iOS simulators.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Example Payload](#example-payload)
- [Contributing](#contributing)

## Features

- Friendly GUI around `xcrun simctl push`
- Detects booted simulators automatically
- Convenient `.apns` file picker
- Alerts for success and errors
- Includes a sample payload in `Resources/notification.apns`

## Installation

1. Clone the repository.
2. Open `PushPush.xcodeproj` with Xcode.
3. Build and run the **PushPush** target.

> **Note**: Xcode command line tools are required.

## Usage

1. Launch an iOS Simulator.
2. Run **PushPush**.
3. Enter your application's **Bundle ID**.
4. Click **Choose .apns file** and select the notification payload.
5. Pick a booted device from the dropdown list.
6. Hit **Push** to send the notification.

## Example Payload

```json
{
    "aps": {
        "sound": "default",
        "badge": 1,
        "alert": {
            "body": "PUSH",
            "title": "YOOO"
        }
    },
    "type": "CULTURAL_EVENT",
    "eventIds": "[189313]",
    "pushId": 1234567
}
```

## Contributing

Contributions and bug reports are welcome! Feel free to open an issue or submit a pull request.

---

Enjoy pushing notifications!
