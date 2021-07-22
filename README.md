# Chimango·AI
This is a Swift based visual search library based on [Vision](https://developer.apple.com/documentation/vision) and [CoreML](https://developer.apple.com/documentation/coreml) that you can use in your iOS app to detect objects in images in a simple way. For more information: [Chimango:AI Library Design](https://github.com/Dario-Gasquez/chimango-ai/wiki)

## Requirements
- iOS 12.0+
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

### Simplest use-case: detects objects in an image
The simplest way to obtain a list of objects detections is by pasing an image to the `VisualSearchManager` like this:
```swift

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
The [DemoApp]() directory contains a sample application. It allows the user to capture an image (either from the device's photos library or by taking a picture using the camera) and then sends that image to the `VisualSearchManager` for the ChimangoAI Library to detect objects in that image. 
