//
//  ObjectDetectionOverlay.swift
//  
//
//  Created by Dario on 03/05/2021.
//


import UIKit

/// Contains an `ObjectDetection` and the `CGRect` (`rectangle`) for that detected object on top of the source image.
public struct ObjectDetectionOverlay {
    public let objectDetection: ObjectDetection
    let imageRect: CGRect

    public init(objectDetection: ObjectDetection, imageRect: CGRect) {
        self.objectDetection = objectDetection
        self.imageRect = imageRect
    }


    public var rectangle: CGRect {
        let transformedRect = RectangleConverter.generateTransformedRects(from: [objectDetection], imageWidth: imageRect.width, imageHeight: imageRect.height).first!

        return transformedRect.offsetBy(dx: imageRect.origin.x, dy: imageRect.origin.y)
    }
}
