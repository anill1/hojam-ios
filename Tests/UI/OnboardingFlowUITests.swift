import XCTest

final class OnboardingFlowUITests: XCTestCase {
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Campus Connections"].waitForExistence(timeout: 5))
        app.buttons["Already have an account? Sign in"].tap()
        XCTAssertTrue(app.textFields["name@university.edu"].waitForExistence(timeout: 2))
    }
}
