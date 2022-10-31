<p align="center">
<img src="https://raw.githubusercontent.com/Dario-Gasquez/chimango-ai/master/images/chimango-logo.png" alt="ChimangoAI" title="ChimangoAI" width="500"/>
</p>

A Swift based, visual search library based on [Vision](https://developer.apple.com/documentation/vision) and [CoreML](https://developer.apple.com/documentation/coreml) that you can add to your iOS app to detect objects in images in a simple way.<br> 
For more information about the underlying design see: [Chimango·AI Library Design](https://github.com/Dario-Gasquez/chimango-ai/wiki).<br>

**This is a work in progress**.

## Requirements
- iOS 13.0+
- Swift 5.0+
- Xcode 12.0+

## Install Instructions

### Swift Package Manager

---

**NOTE:**
These instructions are based on Xcode 12.4

---

1 . Open your project and add a package dependency by selecting: *File -> Swift Packages -> Add Package Dependency*

2 . When asked about the repository paste the following:  
HTTPS URL:  
`https://github.com/Dario-Gasquez/chimango-ai.git`

or SSH URL:  
`git@github.com:Dario-Gasquez/chimango-ai.git`

3 . Follow the instructions until the **ChimangoAI** package is added to the project  

Once the package was succesfully added you should be able to access it by importing the module:
```swift
import ChimangoAI
```

## Usage
### Initial setup
Before anything else, you will need to setup the library with the desired detection mode (using the [COCO](https://cocodataset.org/#home) dataset in the following example):
```Swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Chimango Visual Search Library setup
        do {
            try VisualSearchManager.setupWithMode(.coco)
        } catch let error {
            print("error during Visual Search Library initialization: \(error)")
        }

        return true
    }
```
NOTE: For the time being only the `.coco` mode is implemented.

### Simplest use-case: objects in an image detection
The simplest way to obtain a list of objects detections is by passing an image to the `VisualSearchManager` like this:
```Swift

import ChimangoAI

let sampleImage = UIImage(named: "sampleImage.png")!

VisualSearchManager.detectObjectsIn(image: image) { (result) in
    switch result {
    case .failure(let error):
        print("detectObjectsIn error: \(error.localizedDescription)")
        
    case .success(let detections):
        print("OBJECT DETECTION RESULT: ====================")
        print(detections.debugDescription)
    }
}
```


## Demo App
The [DemoApp](./DemoApp) directory contains a sample application. It allows the user to capture an image (either from the device's photos library or by taking a picture using the camera) and then sends that image to the `VisualSearchManager` for objects detection using the [COCO](https://cocodataset.org/#home) data set.<br>

If objects are detected an alert view with stats is shown. Also circular buttons are drawn on top of the detected objects (tapping on them shows debug information in Xcode debug console).
