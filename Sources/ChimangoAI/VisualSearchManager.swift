//
//  VisualSearchManager.swift
//  
//
//  Created by Dario on 29/08/2021.
//


import Vision
import UIKit

/// Enumerates all possible detection modes
public enum ObjectDetectionMode {
    /// detect objects based on the COCO dataset
    case coco

    /// detect flowers based on the Oxford 102 dataset
    case flowers

    var objectDetectionModelName: String {
        switch self {
        case .coco:
            return Constants.cocoObjectDetectionModelName
        case .flowers:
            fatalError("Flowers detection is still not supported")
            //return Constants.flowersObjectDetectionModelName
        }
    }


    // MARK: - Private Section -
    private enum Constants {
        static let cocoObjectDetectionModelName = "YOLOv3TinyFP16"
        static let flowersObjectDetectionModelName = "FlowersObjectDetection"
    }
}

/// Provides an interface with the ChimangoAI Library
/// For more information see [ChimangoAI]
///
/// [ChimangoAI]:
/// https://github.com/Dario-Gasquez/chimango-ai/

public final class VisualSearchManager {

    /// Initial setup that prepares the Visual Search Library to provide its services
    ///
    /// - IMPORTANT: This method has to be executed before anything else
    public static func setupWithMode(_ detectionMode: ObjectDetectionMode) throws {

        guard let detector = ObjectDetector(withMode: detectionMode) else {
            throw VSError.librarySetupFailed
        }

        objectDetector = detector
    }


    public static func provideObjectDetector() -> ObjectDetectorType {
        return COCOObjectDetector()
    }

    /// Provides a list of objects detected in the provided image.
    ///
    /// Uses an `ObjectDetector` to find the objects in the provided image.
    /// - Note: This method provides a simpler alternative to `provideObjectDetector()`. For example in the case where a client does not need to interact with an `ObjectDetectorType`.
    public static func detectObjectsIn(image: UIImage, andRun completionHandler: @escaping (Result<ObjectDetections, Error>) -> Void ) throws {
        guard let detector = objectDetector else {
            preconditionFailure("Call `VisualSearchManager.setupWithMode(_)` before trying to detect objects")
        }

        detector.detectObjectsIn(image: image) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(error))
            case .success(let objectDetections):
                print(objectDetections)

                let transformedRects = RectangleConverter.generateTransformedRects(from: objectDetections.detections, imageWidth: image.size.width, imageHeight: image.size.height)
                let croppedImages = ImageCutter.cut(image, using: transformedRects)

                print("--- cropped images info -----")
                croppedImages.forEach { cgImage in
                    print("width: \(cgImage.width), height: \(cgImage.height)")
                }

                completionHandler(.success(objectDetections))
            }
        }
    }

    // MARK: - Private Section -

    private static var objectDetector: ObjectDetector?
}
