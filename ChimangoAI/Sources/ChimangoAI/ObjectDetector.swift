//
//  ObjectDetector.swift
//  
//
//  Created by Dario on 29/08/2021.
//

import Vision
import UIKit

final class ObjectDetector {

    init?(withMode detectionMode: ObjectDetectionMode) {
        guard let modelURL = Bundle.module.url(forResource: detectionMode.objectDetectionModelName, withExtension: "mlmodelc") else {
            assertionFailure("Unable to obtain modelURL for mode: \(detectionMode) during init")
            return nil
        }

        guard let coreMLModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else {
            assertionFailure("Unable to generate a CoreMLModel")
            return nil
        }

        objectRecognitionRequest = VNCoreMLRequest(model: coreMLModel)

        // NOTE: Setting as .scaleFill eliminates the need to undo the cropping. If we opt for .centerCrop in the future we'll need to perform additional calculations as explained here: https://machinethink.net/blog/bounding-boxes/ (section: Undoing the cropping)
        objectRecognitionRequest.imageCropAndScaleOption = .scaleFill
        print(objectRecognitionRequest)
    }


    func detectObjectsIn(image: UIImage, andRun completionHandler: @escaping (Result<ObjectDetections, Error>) -> Void) {

        guard let cgImage = image.cgImage else {
            assertionFailure("Unable to get CGImage from IBSImage")
            return
        }

        let imageOrientation = CGImagePropertyOrientation(image.imageOrientation)

        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: imageOrientation)

        do {
            try imageRequestHandler.perform([objectRecognitionRequest])
            guard let results = objectRecognitionRequest.results as? [VNRecognizedObjectObservation] else {
                completionHandler(.failure(VSError.objectDetectionFailed))
                return
            }
            let objectDetections = ObjectDetections(from: results)

            if objectDetections.detections.isEmpty {
                completionHandler(.failure(VSError.noObjectDetected))
                return
            }

            completionHandler(.success(objectDetections))
        } catch {
            completionHandler(.failure(VSError.objectDetectionFailed))
        }
    }

    // MARK: - Private Section -
    private let objectRecognitionRequest: VNCoreMLRequest
}
