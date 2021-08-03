import Combine
import XCTest

@testable import MobilePayKit

final class InAppPurchasesServiceTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testFetchProducts_WhenReqeustSucceeds_PublishesDecodedIds() throws {

        try XCTSkipIf(true, "skipping this for now, need to call networking.load(request) instead of returning dummy values")

        let json = """
        [
            "com.product.1",
            "com.product.2"
        ]
        """

        let data = try XCTUnwrap(json.data(using: .utf8))

        let service = InAppPurchasesService(networking: NetworkingStub(returning: .success(data)))

        let expectation = XCTestExpectation(description: "Publishes decoded [String]")

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { productIds in
                    XCTAssertEqual(productIds.count, 2)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProducts_WhenRequestFails_PublishesReceivedError() throws {

        try XCTSkipIf(true, "skipping this for now, need to call networking.load(request) instead of returning dummy values")

        let expectedError = URLError(.badServerResponse)

        let service = InAppPurchasesService(networking: NetworkingStub(returning: .failure(expectedError)))

        let expectation = XCTestExpectation(description: "Publishes received URLError")

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure(let error) = completion else {
                        return
                    }

                    XCTAssertEqual(error as? URLError, expectedError)

                    expectation.fulfill()
                },
                receiveValue: { productIds in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }
}
