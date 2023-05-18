import XCTest

final class test_task_RayUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testGenerateImage() throws {
        let textField = app.textFields["textField"]
        let generateButton = app.buttons["generateButton"]
        let likeButton = app.buttons["likeButton"]
        let generatedImage = app.images["generatedImage"]

        textField.tap()
        textField.typeText("Test Text")
        
        generateButton.tap()
        
        let imageExpectation = expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: generatedImage, handler: nil)
        wait(for: [imageExpectation], timeout: 10)

        likeButton.tap()
        
        XCTAssertFalse(likeButton.isSelected, "Like button should be liked")
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let tablesQuery = app.tables
        
        var cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        var savedImage = cell.images["savedImage"]
        
        XCTAssertTrue(savedImage.exists, "Image should be exist")
        
        let saveButton = app.buttons["saveButton"]
        saveButton.tap()
        
        sleep(1)
        
        cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        savedImage = cell.images["savedImage"]
        
        XCTAssertFalse(savedImage.exists, "Image shouldn't be exist")
        sleep(1)
    }
}
