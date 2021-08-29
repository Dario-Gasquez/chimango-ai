//
//  RectangleConverter.swift
//  
//
//  Created by Dario on 20/04/2021.
//

import UIKit
import Vision

/// A utility class offering `BoundingBox` and `CGRect` conversion and manipulation services
public final class RectangleConverter {
    /// Converts the normalized `BoundingBox`es into `CGRect` according to the received image dimensions
    ///
    /// - Note: As part of the conversion also inverts the Y coordinate to move the coordinate system origin from bottom-left to top-left
    public static func generateTransformedRects(from objectDetections: [ObjectDetection], imageWidth: CGFloat, imageHeight: CGFloat) -> [CGRect] {
        print("---- generateTransformedRects -----")
        print("image width: \(imageWidth). image height: \(imageHeight)")

        let rects = objectDetections.compactMap { (objectDetection) -> CGRect? in
            let boundingBox = objectDetection.boundingBox
            print("original boundingBox: \(boundingBox.debugDescription)")

            let transformedRect = generateInvertedYImageRect(from: boundingBox, imageWidth: imageWidth, imageHeight: imageHeight)
            print("transformed and inverted bbox rect:")
            print(transformedRect.debugDescription)

            return transformedRect
        }

        return rects
    }

    // MARK: - Private Section -

    /// Returns a `CGRect` whose coordinate system origin is inverted in the Y axis
    ///
    /// Because we have to deal with different coordinate system origins (for example: top-left for UIKit, but bottom-left for CGGraphic, or Vision and so on) we may need to obtain a `CGRect` with the inverted Y axis.
    private static func generateInvertedYImageRect(from boundingBox: BoundingBox, imageWidth: CGFloat, imageHeight: CGFloat) -> CGRect {
        let height = CGFloat(boundingBox.height)
        let invertedYRect = CGRect(
            x: CGFloat(boundingBox.x),
            y: 1 - CGFloat(boundingBox.y) - height, // calculate the Y coordinate in the oposite corner
            width: CGFloat(boundingBox.width),
            height: height
        )
        let invertedYImageRect = VNImageRectForNormalizedRect(invertedYRect, Int(imageWidth), Int(imageHeight))

        return invertedYImageRect
    }
}
