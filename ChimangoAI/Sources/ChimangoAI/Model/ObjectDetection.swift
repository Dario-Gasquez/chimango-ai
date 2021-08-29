//
//  ObjectDetection.swift
//  
//
//  Created by Dario on 13/04/2021.
//

import Vision

/// An array of `ObjectDetection`
public struct ObjectDetections {
    public private(set) var detections: [ObjectDetection]
}


extension ObjectDetections: CustomDebugStringConvertible {
    public var debugDescription: String {
        let debugString =
        """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        count: \(detections.count)
        detections: \(detections.debugDescription)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """

        return debugString
    }
}


extension ObjectDetections {
    init(from recognizedObjects: [VNRecognizedObjectObservation]) {
        detections = recognizedObjects.compactMap { ObjectDetection(from: $0) }
    }
}


/// The result obtained after executing an object detection model
public struct ObjectDetection {
    let boundingBox: BoundingBox
    let category: String
    let confidence: Float
}


extension ObjectDetection {
    init(from recognizedObject: VNRecognizedObjectObservation) {
        category = recognizedObject.labels.first?.identifier ?? "no category"
        confidence = recognizedObject.confidence
        boundingBox = BoundingBox(from: recognizedObject)
    }
}


extension ObjectDetection: CustomDebugStringConvertible {
    public var debugDescription: String {
        let debugString =
            """

        -----------------------------
        category: \(category)
        confidence: \(confidence)
        boundingBox: \(boundingBox)
        -----------------------------

        """

        return debugString
    }
}
