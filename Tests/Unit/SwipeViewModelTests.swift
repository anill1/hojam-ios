import XCTest
@testable import UniApp

final class SwipeViewModelTests: XCTestCase {
    func testLoadCardsSetsLimit() async {
        let api = MockAPIClient()
        let viewModel = SwipeViewModel(apiClient: api, remoteConfig: RemoteConfigService(apiClient: api), haptics: NoOpHapticsClient())

        await viewModel.load()

        XCTAssertGreaterThan(viewModel.cards.count, 0)
        XCTAssertEqual(viewModel.remainingSwipes, viewModel.swipeLimit)
    }

    func testPerformSwipeConsumesLimit() async {
        let api = MockAPIClient()
        let viewModel = SwipeViewModel(apiClient: api, remoteConfig: RemoteConfigService(apiClient: api), haptics: NoOpHapticsClient())

        await viewModel.load()
        let initialRemaining = viewModel.remainingSwipes
        await viewModel.performSwipe(isLike: true)

        XCTAssertEqual(viewModel.remainingSwipes, initialRemaining - 1)
    }
}
