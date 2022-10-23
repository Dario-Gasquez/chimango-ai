import XCTest
import Vision
@testable import ChimangoAI


final class ObjectDetectionTests: XCTestCase {
    func test_BoundingBoxInitFromVisionObjectObservation() {
        let objectRect = CGRect(x: 5, y: 10, width: 100, height: 200)
        let recognizedObject = VNRecognizedObjectObservation(boundingBox: objectRect)

        let boundingBox = BoundingBox(from: recognizedObject)

        XCTAssertEqual(boundingBox.x, Float(objectRect.minX))
        XCTAssertEqual(boundingBox.y, Float(objectRect.minY))
        XCTAssertEqual(boundingBox.width, Float(objectRect.width))
        XCTAssertEqual(boundingBox.height, Float(objectRect.height))
    }


    func test_ObjectDetectionInitFromVisionObjectObservation() {
        let objectRect = CGRect(x: 5, y: 10, width: 100, height: 200)
        let recognizedObject = VNRecognizedObjectObservation(boundingBox: objectRect)
        let expectedBBox = BoundingBox(from: recognizedObject)

        let objectDetection = ObjectDetection(from: recognizedObject)

        XCTAssertEqual(objectDetection.boundingBox, expectedBBox)
        XCTAssertEqual(objectDetection.category, "no category")
        XCTAssertEqual(objectDetection.confidence, 1.0)
    }


    func test_ObjectDetectionsInitFromVisionObjectObservations() {
        let objectDetections = ObjectDetections(from: testVisionObservations)

        XCTAssertEqual(objectDetections.detections.count, testVisionObservations.count)

        for index in 0 ..< objectDetections.detections.count {
            let expectedBBox = BoundingBox(from: testVisionObservations[index])
            let objectDetection = objectDetections.detections[index]
            XCTAssertEqual(objectDetection.boundingBox, expectedBBox)
            XCTAssertEqual(objectDetection.category, "no category")
            XCTAssertEqual(objectDetection.confidence, 1.0)
        }
    }

    static var allTests = [
        ("test_BoundingBoxInitFromVisionObjectObservation", test_BoundingBoxInitFromVisionObjectObservation),
        ("test_ObjectDetectionInitFromVisionObjectObservation", test_ObjectDetectionInitFromVisionObjectObservation),
        ("test_ObjectDetectionsInitFromVisionObjectObservations", test_ObjectDetectionsInitFromVisionObjectObservations)
    ]


    // MARK: - Private Section -
    private var testVisionObservations: [VNRecognizedObjectObservation] {
        let visionObservations: [VNRecognizedObjectObservation] = [
            VNRecognizedObjectObservation(boundingBox: CGRect(x: 10, y: 20, width: 100, height: 200)),
            VNRecognizedObjectObservation(boundingBox: CGRect(x: 0, y: 0, width: 1, height: 1)),
            VNRecognizedObjectObservation(boundingBox: CGRect(x: 1, y: 1, width: 200, height: 200))
        ]

        return visionObservations
    }
}

