import XCTest
import Vision
@testable import ChimangoAI


final class ImageCutterTests: XCTestCase {

    func test_FullImageCutReturnsOriginalSize() {
        guard let imagePath = Bundle.module.path(forResource: "female-full-body", ofType: "jpg"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTFail("unable to load test image")
            return
        }

        let originalRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        let croppedImages = ImageCutter.cut(image, using: [originalRect])

        XCTAssertEqual(croppedImages.count, 1)
        XCTAssertEqual(croppedImages.first!.width, Int(originalRect.integral.width))
        XCTAssertEqual(croppedImages.first!.height, Int(originalRect.integral.height))
    }


    func test_ImageIsCorrectlyCutInFour() {
        guard let imagePath = Bundle.module.path(forResource: "male-full-body", ofType: "jpg"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTFail("unable to load test image")
            return
        }

        let detectedObjectsRects = [
            CGRect(x: 83.20649123191833, y: 161.40528434515, width: 96.9208869934082, height: 102.47308230400085),
            CGRect(x: 75.13212323188782, y: 99.3242646753788, width: 86.37303113937378, height: 77.67714902758598),
            CGRect(x: 106.97098577022552, y: 248.72516150772572, width: 27.802861899137497, height: 33.32379837334156),
            CGRect(x: 146.73560166358948, y: 260.2124264985323, width: 40.5436224937439, height: 34.01335309445858)
        ]

        let croppedImages = ImageCutter.cut(image, using: detectedObjectsRects)

        XCTAssertEqual(croppedImages.count, 4)

        for (index, image) in croppedImages.enumerated() {
            XCTAssertEqual(image.width, Int(detectedObjectsRects[index].integral.width))
            XCTAssertEqual(image.height, Int(detectedObjectsRects[index].integral.height))
        }
    }


    static var allTests = [
        (test_FullImageCutReturnsOriginalSize, "test_FullImageCutReturnsOriginalSize"),
        (test_ImageIsCorrectlyCutInFour, "test_ImageIsCorrectlyCutInFour")
    ]
}
