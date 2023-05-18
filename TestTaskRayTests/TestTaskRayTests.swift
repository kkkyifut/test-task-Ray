@testable import test_task_Ray
import XCTest

final class MainViewControllerTests: XCTestCase {
    var viewController: MainViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        viewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        
        try super.tearDownWithError()
    }
    
    func testGenerateImage() {
        viewController.textField.text = "Test Text"
        
        viewController.generateImage(UIButton())
        
        let imageExpectation = expectation(for: NSPredicate(format: "self != nil"), evaluatedWith: viewController.generatedImage.image, handler: nil)

        _ = XCTWaiter.wait(for: [imageExpectation], timeout: 7)
        
        XCTAssertNotNil(viewController.generatedImage.image, "Image should be generated")
        XCTAssertEqual(viewController.isLiked, false, "isLiked should be false after generating image")
        
        viewController.likeImageButton(UIButton())
        XCTAssertNotNil(viewController.savedImage, "Image should be generated and saved")
        XCTAssertEqual(viewController.savedImage?.queryText, "Test+Text")
    }
    
    func testLikeImageButton() {
        viewController.savedImages = [ImageData(queryText: "Test Text", image: UIImage(), isLiked: false)]
        viewController.savedImage = viewController.savedImages?.first
        
        viewController.likeImageButton(UIButton())
        
        XCTAssertTrue(viewController.isLiked, "isLiked should be true after liking image")
        XCTAssertEqual(viewController.savedImage?.queryText, "Test Text")
        
        viewController.likeImageButton(UIButton())
        
        XCTAssertFalse(viewController.isLiked, "isLiked should be false after unliking image")
    }
}
