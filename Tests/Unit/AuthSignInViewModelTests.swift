@testable import UniApp
import XCTest

final class AuthSignInViewModelTests: XCTestCase {
    func testValidEmail() {
        let viewModel = AuthSignInViewModel()
        viewModel.email = "student@campus.edu.tr"
        XCTAssertTrue(viewModel.isValidEmail)
    }

    func testInvalidEmail() {
        let viewModel = AuthSignInViewModel()
        viewModel.email = "student@gmail.com"
        XCTAssertFalse(viewModel.isValidEmail)
    }
}
