import XCTest
@testable import ChimangoAI


final class ObjectDetectorTests: XCTestCase {
    func test_InitWithCOCOMode_DoesNotFail() {
        let objectDetector = ObjectDetector(withMode: .coco)

        XCTAssertNotNil(objectDetector)
    }


    func test_SuccessfullyDetectsCat_InCOCOMode() {
        guard let imagePath = Bundle.module.path(forResource: "cat", ofType: "jpg"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTFail("unable to load test image")
            return
        }

        let objectDetector = ObjectDetector(withMode: .coco)
        XCTAssertNotNil(objectDetector)

        objectDetector?.detectObjectsIn(image: image, andRun: { result in
            switch result {
            case .failure:
                XCTFail("Unexpected error")
            case .success(let objectDetections):
                XCTAssertEqual(objectDetections.detections.count, 1)
                objectDetections.detections.forEach { detection in
                    XCTAssertEqual(detection.category, "cat")
                    XCTAssertGreaterThanOrEqual(detection.confidence, 0.5)
                }
            }
        })
    }


    func test_SuccessfullyDetectsExpectedObjects_InCOCOMode() {
        guard let imagePath = Bundle.module.path(forResource: "room", ofType: "jpg"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTFail("unable to load test image")
            return
        }

        let objectDetector = ObjectDetector(withMode: .coco)
        XCTAssertNotNil(objectDetector)

        objectDetector?.detectObjectsIn(image: image, andRun: { result in
            switch result {
            case .failure:
                XCTFail("Unexpected error")
            case .success(let objectDetections):
                XCTAssertEqual(objectDetections.detections.count, 5)
                objectDetections.detections.forEach { detection in
                    let expectedCategories = ["tvmonitor", "diningtable", "chair"]
                    XCTAssertTrue(expectedCategories.contains(detection.category), "\(detection.category) not expected")
                    XCTAssertGreaterThanOrEqual(detection.confidence, 0.35)
                }
            }
        })
    }


    func test_FailsDetectionOnEmptyImage() {
        guard let imagePath = Bundle.module.path(forResource: "empty-image", ofType: "png"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTFail("unable to load test image")
            return
        }

        let objectDetector = ObjectDetector(withMode: .coco)
        XCTAssertNotNil(objectDetector)

        objectDetector?.detectObjectsIn(image: image, andRun: { result in
            switch result {
            case .failure(let error):
                guard let vsError = error as? VSError else {
                    XCTFail("VSErropr was expected")
                    return
                }

                XCTAssertEqual(vsError, .noObjectDetected)
            case .success:
                XCTFail("Unexpected successful detection in empty image")
            }
        })
    }


    static var allTests = [
        ("test_InitWithCOCOMode_DoesNotFail", test_InitWithCOCOMode_DoesNotFail),
        ("test_SuccessfullyDetectsCat_InCOCOMode", test_SuccessfullyDetectsCat_InCOCOMode),
        ("test_SuccessfullyDetectsExpectedObjects_InCOCOMode", test_SuccessfullyDetectsExpectedObjects_InCOCOMode),
        ("test_FailsDetectionOnEmptyImage", test_FailsDetectionOnEmptyImage)
    ]
}
