    import XCTest
    @testable import ChimangoAI

    final class ChimangoAITests: XCTestCase {
        func test_setupWithCocoMode_IsSuccessful() {
            XCTAssertNoThrow(try VisualSearchManager.setupWithMode(.coco))
        }


        func test_setupWithFlowersMode_ThrowsNotSupportedError() {
            do {
                try VisualSearchManager.setupWithMode(.flowers)
            } catch let error {
                guard let vsError = error as? VSError else {
                    XCTFail("VSError was expected")
                    return
                }

                XCTAssertEqual(vsError, .detectionModeNotSupported)
            }
        }
    }
