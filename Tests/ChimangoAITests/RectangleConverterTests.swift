import XCTest
import Vision
@testable import ChimangoAI


final class RectangleConverterTests: XCTestCase {

    func test_coordsAtOrigin_zeroWidthAndHeight() {
        let zeroDimensionsBBox = BoundingBox(x: 0, y: 0, width: 0, height: 0)
        let expectedRect = CGRect(x: 0, y: 100, width: 0, height: 0)

        testingHelperWithRect(expectedRect, inputBoundingBox: zeroDimensionsBBox, imageWidth: 100.0, imageHeight: 100.0)
    }


    func test_coordsAtOrigin_MaxWidthAndHeight() {
        let maxDimensionsBBox = BoundingBox(x: 0, y: 0, width: 1, height: 1)
        let width: CGFloat = 50.0
        let height: CGFloat = 200.0
        let expectedRect = CGRect(x: 0, y: 0, width: width, height: height)

        testingHelperWithRect(expectedRect, inputBoundingBox: maxDimensionsBBox, imageWidth: width, imageHeight: height)
    }


    func test_bottomLeftQuadrant_LandscapeImage() {
        let bottomLeftBBox = BoundingBox(x: 0, y: 0, width: 0.5, height: 0.5)
        let width: CGFloat = 200
        let height: CGFloat = 100
        let expectedRect = CGRect(x: 0, y: 50, width: width/2, height: height/2)

        testingHelperWithRect(expectedRect, inputBoundingBox: bottomLeftBBox, imageWidth: width, imageHeight: height)
    }


    func test_bottomRightQuadrant_LandscapeImage() {
        let bottomRightBBox = BoundingBox(x: 0.5, y: 0, width: 0.5, height: 0.5)
        let width: CGFloat = 200
        let height: CGFloat = 100
        let expectedRect = CGRect(x: 100, y: 50, width: width/2, height: height/2)

        testingHelperWithRect(expectedRect, inputBoundingBox: bottomRightBBox, imageWidth: width, imageHeight: height)
    }


    func test_topRightQuadrant_LandscapeImage() {
        let topRightBBox = BoundingBox(x: 0.5, y: 0.5, width: 0.5, height: 0.5)
        let width: CGFloat = 200
        let height: CGFloat = 100
        let expectedRect = CGRect(x: 100, y: 0, width: width/2, height: height/2)

        testingHelperWithRect(expectedRect, inputBoundingBox: topRightBBox, imageWidth: width, imageHeight: height)
    }


    func test_topLeftQuadrant_LandscapeImage() {
        let topLeftBBox = BoundingBox(x: 0, y: 0.5, width: 0.5, height: 0.5)
        let width: CGFloat = 200
        let height: CGFloat = 100
        let expectedRect = CGRect(x: 0, y: 0, width: width/2, height: height/2)

        testingHelperWithRect(expectedRect, inputBoundingBox: topLeftBBox, imageWidth: width, imageHeight: height)
    }

    static var allTests = [
        ("test_coordsAtOrigin_zeroWidthAndHeight", test_coordsAtOrigin_zeroWidthAndHeight),
        ("test_coordsAtOrigin_MaxWidthAndHeight", test_coordsAtOrigin_MaxWidthAndHeight),
        ("test_bottomLeftQuadrant_LandscapeImage", test_bottomLeftQuadrant_LandscapeImage),
        ("test_bottomRightQuadrant_LandscapeImage", test_bottomRightQuadrant_LandscapeImage),
        ("test_topRightQuadrant_LandscapeImage", test_topRightQuadrant_LandscapeImage),
        ("test_topLeftQuadrant_LandscapeImage", test_topLeftQuadrant_LandscapeImage)
    ]


    // MARK: - Private Section -

    private func testingHelperWithRect(_ expectedRect: CGRect, inputBoundingBox: BoundingBox, imageWidth: CGFloat, imageHeight: CGFloat) {
        let testObjDetection = ObjectDetection(boundingBox: inputBoundingBox, category: "test", confidence: 1.0)

        let transformedRects = RectangleConverter.generateTransformedRects(from: [testObjDetection], imageWidth: imageWidth, imageHeight: imageHeight)

        XCTAssertEqual(transformedRects.count, 1)
        XCTAssertEqual(transformedRects.first!, expectedRect)
    }
}
