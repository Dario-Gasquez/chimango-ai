//
//  BoundingBox.swift
//  
//
//  Created by Dario on 22/04/2021.
//

import Vision

// Contains a bounding box as obtained from the results of executing an object detection model
///
/// All the properties are in the range [0..1], representing a relative (in percentage) value
public struct BoundingBox: Equatable {
    let x: Float // swiftlint:disable:this identifier_name
    let y: Float // swiftlint:disable:this identifier_name
    let width: Float
    let height: Float
}


extension BoundingBox {
    init(from recognizedObject: VNRecognizedObjectObservation) {
        x = Float(recognizedObject.boundingBox.minX)
        y = Float(recognizedObject.boundingBox.minY)
        width = Float(recognizedObject.boundingBox.width)
        height = Float(recognizedObject.boundingBox.height)
    }
}


extension BoundingBox: CustomDebugStringConvertible {
    public var debugDescription: String {
        let debugString =
        """

        [x: \(x), y: \(y), width: \(width), height: \(height)]
        """

        return debugString
    }
}
